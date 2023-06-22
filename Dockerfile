ARG PHP_VERSION=8.1

FROM php:${PHP_VERSION}-fpm-alpine3.16
LABEL org.opencontainers.image.authors="example@example.com"

WORKDIR /app

COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/

# persistent / runtime deps
RUN apk add --no-cache \
        acl \
        bash \
        fcgi \
        file \
        gettext \
        git \
        nginx \
        ncurses \
        redis \
    ;

RUN set -eux; \
    install-php-extensions \
        bcmath \
        gd \
        intl \
        zip \
        amqp \
        apcu \
        opcache \
        redis \
        pdo_mysql \
        sockets \
        soap \
    ;

RUN mkdir -p /var/run/php

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

EXPOSE 80

STOPSIGNAL SIGTERM

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["bash", "-c", "php-fpm & nginx -g 'daemon off;' & wait -n && exit $?"]
