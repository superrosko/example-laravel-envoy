FROM php:7.4-fpm
MAINTAINER Dmitriy Bespalov <dbespalov.rosko@gmail.com>

# Set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    zip unzip \
    git \
    curl

# PHP Extensions
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo_mysql

RUN apt-get update \
    && apt-get install -y \
        libpng-dev \
        libpq-dev \
        libpq5 \
    && docker-php-ext-configure pdo_pgsql \
    && docker-php-ext-install -j$(nproc) \
        pdo_pgsql \
    && apt-get purge -y \
        libpng-dev \
        libpq-dev

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libpng-dev \
        libjpeg-dev \
        libfreetype6 \
        libpng16-16 \
        libjpeg62 \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
    && apt-get purge -y \
        libfreetype6-dev \
        libpng-dev \
        libjpeg-dev

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        intl \
    && apt-get purge -y \
        libicu-dev

RUN docker-php-ext-install bcmath

RUN apt-get update \
    && apt-get install -y \
        libmpc-dev \
    && docker-php-ext-configure gmp \
    && docker-php-ext-install -j$(nproc) \
        gmp \
    && apt-get purge -y \
        libmpc-dev

RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        libzip4 \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) \
        zip \
    && apt-get purge -y \
        libzip-dev

RUN docker-php-ext-install pcntl

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN pecl install mongodb && docker-php-ext-enable mongodb

RUN apt-get update \
    && apt-get install -y \
        libmemcached-dev \
        libmemcached11 \
        libmemcached-tools \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && apt-get purge -y \
        libmemcached-dev

RUN apt-get update \
    && apt-get install -y \
        librabbitmq-dev \
        librabbitmq4 \
    && pecl install amqp \
    && docker-php-ext-enable amqp \
    && apt-get purge -y \
        librabbitmq-dev

RUN apt-get update \
    && apt-get install -y \
    && pecl install redis \
    && docker-php-ext-enable redis

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get autoremove -y

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
