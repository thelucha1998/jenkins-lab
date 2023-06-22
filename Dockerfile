FROM node:8  
WORKDIR /app  
COPY package.json /app  
RUN NODE_ENV=development npm i
COPY . /app  
EXPOSE 8081  
CMD node index.js

