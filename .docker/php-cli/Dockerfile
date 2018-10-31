FROM php:7.2-cli-alpine3.8

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && apk add --no-cache \
        git \
        bash \
        coreutils \
        mariadb-client \
    && pecl install \
        xdebug \
    && docker-php-ext-enable \
        xdebug \
    && apk del .build-deps \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /usr/src/app
