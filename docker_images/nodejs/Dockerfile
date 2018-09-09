FROM node:latest

RUN useradd --user-group --create-home --shell /bin/false nodejs

USER nodejs

RUN mkdir -p /home/nodejs

WORKDIR /home/nodejs

COPY package.json .

RUN npm install

COPY server.js .

EXPOSE 8888

CMD [ "node", "server.js" ]
