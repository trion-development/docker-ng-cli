#simple angular-cli docker installation
#docker build -t ng-cli .
FROM node:6

MAINTAINER trion development GmbH "info@trion.de"

ENV HOME=/home/app
RUN mkdir -p $HOME
WORKDIR $HOME


RUN npm install -g angular-cli@1.0.0-beta.24 && npm cache clean

EXPOSE 4200
