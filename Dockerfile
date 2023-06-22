FROM node:8  
WORKDIR /app  
COPY package.json /app  
RUN sudo npm install
COPY . /app  
EXPOSE 8081  
CMD node index.js

