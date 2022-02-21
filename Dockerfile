FROM debian:stretch
MAINTAINER Daniel Vilar

RUN apt-get update && apt-get install -y curl git python build-essential xvfb apt-transport-https

# Install nvm with node and npm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.17.1

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install -g yarn
RUN npm install -g pm2@^3
RUN pm2 install pm2-logrotate
RUN pm2 set pm2-logrotate:compress true

RUN mkdir -p /src

# Installing and building learning locker ui, api and worker
WORKDIR /src
RUN git clone https://github.com/LearningLocker/learninglocker.git
WORKDIR /src/learninglocker
COPY .env_learninglocker /src/learninglocker/.env
RUN git checkout v2.0.7
RUN yarn install
RUN yarn build-all

#Installing the xapi service
WORKDIR /src
RUN git clone https://github.com/LearningLocker/xapi-service.git
WORKDIR /src/xapi-service
COPY .env_xapi /src/xapi-service/.env
RUN npm install
RUN npm run build

EXPOSE 3000
EXPOSE 8080
EXPOSE 8081

WORKDIR /src
COPY start_learninglocker.sh /src
RUN chmod +x /src/start_learninglocker.sh
ENTRYPOINT /src/start_learninglocker.sh
