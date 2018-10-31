FROM alpine:latest

RUN apk --update add --no-cache mariadb

ADD run.sh /scripts/run.sh

RUN chmod -R 755 /scripts
