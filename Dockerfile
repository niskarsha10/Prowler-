
FROM node:latest
WORKDIR /app

COPY package*.json /app


COPY . .
CMD [ "node", "server.js" ]
EXPOSE 5000
