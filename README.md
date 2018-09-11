# terraform-ansible-Docker(Nginx, Mysql, NodeJS)
Quick start on how to orchestrate EC2 instance with Terraform and configure the instance using Ansible to build Docker containers.

## Project structure
* ansible - folder with ansible playbooks, inventories and configuration
* terraform - folder with terraform infrastructure files

$ cat ~/.aws/credentials
[default]
aws_access_key_id = <AWS_ACCESS_TOKEN>
aws_secret_access_key = <AWS_SECRET_ACCESS_KEY>
regions = us-east-1

or aws access key and secret key can be hardcodedin the terraform tfvars file to pass as variables.
## Usage
if you want just up example infrastructure you need set your variables in .tfvars files
```
pub_key_path = "~/.ssh/id_rsa.pub"
private_key_path = "~/.ssh/id_rsa"
key_name = "sample"
env = "dev"
aws_secret_access_key = ""
aws_access_key_id = ""
```

Go to terraform folder and download all modules to .terraform folder (for local modules it just creates symlinks)
```
$ cd terraform
$ terraform get
```

If your want to see plan of your own infrastructure

```
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_ami.image: Refreshing state...
The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

Plan: 9 to add, 0 to change, 0 to destroy.

```
To create all resources and provision all services
```
$ terraform apply
```
To delete all created resources
```
$ terraform destroy
```
# Terraform structure

#### main.tf - contain general infrastructure description
We describe used provider, can create resources, call some modules, and can also define provision  
action
```
provider "aws" {
  region = "${var.region}"
}
...
module "base_linux" {
  source = "./modules/base"
}
...
resource null_resource "ansible_web" {
  depends_on = ["module.web"]

  provisioner "local-exec" {
    command = "cd ../ansible && ansible-playbook playbooks/apache.yml -e env=${var.env} -e group_name=${var.web_server_params["name"]}"
  }
}
...
```


#### variables.tf - define all required variables, its description(optional) default values(optional)

There are three types of variables in terraform:

* string
```
variable "string_var_name" {
    default = "string_value"
}
```
* map
```
variable "map_var_name" {
    default = {
      key-1 = "image-1234"
      key-2 = "image-4567"
}
```
* list
```
variable "list_var_name" {
    default = ["us-east-1a", "us-east-1b"]
}
```

Variables can be defined in
* variables.tf or any other .tf file
```
  variable env {
    description = "current environment (dev, prod, stage)"
    default = "dev"
  }
```
You can just create it but not define in .tf file, but then you'll need to define it anywhere
  ```
    variable "name" {}
  ```

* terraform.tfvars (default) or any other .tfvars file with flag -var-file
```
$ terraform plan \
  -var-file="secret.tfvars" \
  -var-file="production.tfvars"
```
* input argument to terraform with flag -var
```
$ terraform plan -var 'access_key=foo'
```

[More information about variables](https://www.terraform.io/docs/configuration/variables.html)

#### outputs.tf - define all important output data like variables

```
output "web_address" {
  value = "${module.web.public_ip}"
}
```

#### modules/
Modules are used in Terraform to modularize and encapsulate groups of resources in your infrastructure.
Every module is a little terraform project - it can contain its own variables and outputs

Module structure:
* base - module used in every infrastructure
* key_pair - upload public keys to cloud provider
* web - build web-service resources

We can use module just like:
```
  module "exemplar_name" {
    source ./modules/web
    name = server_name
    env = "${var.env_name}"
  }
```
[More information about modules](https://www.terraform.io/docs/modules/index.html)

To Deploy the Docker containers in AWS EC2 instance, run the Terraform Script to create the EC2 instance with the required configurations.

### Ansible

Here we are using Terraform to bring uo EC2 instance and Ansible to Install Docker and Deploy Docker containers using docker-compose on the target machine.

### Ansible Installation

[Ansible Installation for various Platforms can be found here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

#### Ansible Roles Available
Various Ansible Roles used are,

* Install Docker
* Start Docker Containers 
* Stop Docker Containers


Depending on executing the Ansible Script locally or on AWS EC2 instance, the `hosts:` part of yml file will change.

Open file the file `/etc/ansible/hosts` and at end of the file, add the following entry if your are going to run the ansible script against EC2 instance,
```
[my-ec2]
ec2-ip
```
Then your yml file will look like

```
---
- hosts: my-ec2
  become: yes

  roles:
    - { role: docker_install }
```

Or if your going to run locally, then your yml file will look file,

```
---
- hosts: 127.0.0.1
  connection: local
  become: yes

  roles:
    - { role: docker_install }
```

You can also group all the ansible roles together in a single yml file and run the tasks one by one like,

```
---
- hosts: 127.0.0.1
  connection: local
  become: yes

  roles:
    - { role: docker_install }
    - { role: docker-compose }
```
Which will install Docker on your Target Machine and run docker-compose to bring all the Docker Containers.

To stop all the containers,

```
---
- hosts: 127.0.0.1
  connection: local
  become: yes

  roles:
    - { role: docker-compose-down }
```










