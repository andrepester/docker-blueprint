FROM php:7.2-cli-alpine3.7

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && apk add --no-cache \
        git \
        bash \
        coreutils \
        openssh-client \
    && pecl install \
        xdebug \
    && docker-php-ext-enable \
        xdebug \
    && apk del .build-deps \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD php.ini /usr/local/etc/php/php.ini
#ADD .bashrc /home/www-data/.bashrc

WORKDIR /usr/src/app
