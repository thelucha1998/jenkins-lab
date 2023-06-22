FROM node:8  
WORKDIR /app  
COPY package.json /app  
RUN apt update\
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash\
    && . $HOME/.nvm/nvm.sh\
    && nvm install $NODE_VERSION
ENV NODE_PATH /root/.nvm/v$NODE_VERSION/lib/node_modules
ENV PATH /root/.nvm/versions/node/v$NODE_VERSION/bin:$PATH 
COPY . /app  
EXPOSE 8081  
CMD node index.js

