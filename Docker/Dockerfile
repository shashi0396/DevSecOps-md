# 1. Heavy base image carrying hundreds of unnecessary operating system utilities
FROM node:14

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

# 2. Defaults to running as root inside the container
CMD ["node", "server.js"]