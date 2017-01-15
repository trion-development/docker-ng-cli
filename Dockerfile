#simple angular-cli docker installation
#docker build -t ng-cli .
#or specify angular-cli version
#docker build --build-arg NG_CLI_VERSION=1.0.0-beta.24 -t ng-cli .
FROM node:6

MAINTAINER trion development GmbH "info@trion.de"

ARG NG_CLI_VERSION=1.0.0-beta.24
ARG USER_HOME_DIR="/home/app"
ARG USER_ID=1000

RUN mkdir -p $USER_HOME_DIR && chown $USER_ID $USER_HOME_DIR
WORKDIR $USER_HOME_DIR

RUN npm install -g angular-cli@$NG_CLI_VERSION && npm cache clean

VOLUME "$USER_HOME_DIR/"
EXPOSE 4200

USER $USER_ID
