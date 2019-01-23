#simple angular-cli docker installation
#docker build -t ng-cli .
#or specify angular-cli version
#docker build --build-arg NG_CLI_VERSION=7.2.3

#FROM node:alpine

#alternative to reduce size instead of alpine, but does not
#include build tools for native compilation of npm packages
#we therefore add gcc
FROM node:8-slim

MAINTAINER trion development GmbH "info@trion.de"

ARG NG_CLI_VERSION=7.2.3
ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/app"
ARG USER_ID=1000

LABEL angular-cli-version=$NG_CLI_VERSION node=$NODE_VERSION

ENV NPM_CONFIG_LOGLEVEL warn
#angular-cli rc0 crashes with .angular-cli.json in user home
ENV HOME "$USER_HOME_DIR"

RUN apt-get update && apt-get install -qqy --no-install-recommends \
    dumb-init \
    git \
    build-essential \
    python \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# npm 5 uses different userid when installing packages, as workaround su to node when installing
# see https://github.com/npm/npm/issues/16766
RUN set -xe \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin \
    && (cd "$USER_HOME_DIR"; su node -c "npm install -g @angular/cli@$NG_CLI_VERSION; npm install -g yarn; chmod +x /usr/local/bin/yarn; npm cache clean --force")

#not declared to avoid anonymous volume leak
#VOLUME "$USER_HOME_DIR/.cache/yarn"
#VOLUME "$APP_DIR/"
WORKDIR $APP_DIR
EXPOSE 4200

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

USER $USER_ID
