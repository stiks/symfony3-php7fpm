FROM php:7.1-fpm-alpine

MAINTAINER Kirill Garbar <kirill@iterium.co.uk>

ENV REDIS_VERSION 4.0.2

# Install Symfony 3 requirements
RUN set -xe \
    # Git (need for composer)
    && apk add --no-cache git \
    # Fixed Intl version
    #&& apk add --no-cache libintl icu icu-dev \
    #&& docker-php-ext-install intl \
    #&& apk del icu-dev \
    && docker-php-ext-install opcache bcmath sockets pdo pdo_mysql \
    # Clear
    && rm -rf /tmp/* /var/cache/apk/* \
    # Install PHP Redis extension
    && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$REDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-* /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    # Install composer
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer global require hirak/prestissimo

WORKDIR /srv
