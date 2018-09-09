FROM mysql:5.7

ADD my.cnf /etc/mysql/my.cnf
RUN apt-get update && apt-get install vim -y && mkdir /root/mysql_dump 
COPY ./mysql_dump/database_schema.sql /root/mysql_dump/
