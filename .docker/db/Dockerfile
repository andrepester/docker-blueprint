FROM alpine:latest

RUN apk --update add --no-cache \
        mysql \
        mysql-client

ADD run.sh /scripts/run.sh

RUN chmod -R 755 /scripts
