#simple angular-cli docker installation
#docker build -t ng-cli .
#or specify angular-cli version
#docker build --build-arg NG_CLI_VERSION=1.2.6

FROM node:6

MAINTAINER trion development GmbH "info@trion.de"

ARG NG_CLI_VERSION=1.2.6
ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/app"
ARG USER_ID=1000

ENV NPM_CONFIG_LOGLEVEL warn
#angular-cli rc0 crashes with .angular-cli.json in user home
ENV HOME "$USER_HOME_DIR"

RUN set -xe \
    && curl -sL https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 > /usr/bin/dumb-init \
    && chmod +x /usr/bin/dumb-init \
    && mkdir -p $USER_HOME_DIR \
    && chown $USER_ID $USER_HOME_DIR \
    && chmod a+rw $USER_HOME_DIR \
    && (cd "$USER_HOME_DIR"; npm install -g @angular/cli@$NG_CLI_VERSION; npm install -g yarn; npm cache clean)

VOLUME "$USER_HOME_DIR/.cache/yarn"
VOLUME "$APP_DIR/"
WORKDIR $APP_DIR
EXPOSE 4200

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

USER $USER_ID
