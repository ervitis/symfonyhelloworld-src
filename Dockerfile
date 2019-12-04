FROM php:7.3-fpm-alpine3.10

RUN apk --no-cache add --virtual .dependencies \
    git autoconf gcc g++ make && \
    apk --no-cache add zlib-dev libzip-dev && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /tmp/*

WORKDIR /usr/src/app

ENV APP_ENV=dev

COPY . .

RUN composer install
RUN apk del .dependencies