FROM php:7.4-fpm
MAINTAINER Dmitriy Bespalov <dbespalov.rosko@gmail.com>

# Set working directory
WORKDIR /var/www

# Set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    libicu-dev \
    libmpc-dev \
    libzip-dev \
    libpng-dev \
    libssl-dev \
    libmemcached-dev \
    librabbitmq-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# PHP Extensions
RUN docker-php-ext-install pdo_mysql pdo_sqlite intl bcmath gmp zip pcntl gd
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN pecl install memcached && docker-php-ext-enable memcached
RUN pecl install amqp && docker-php-ext-enable amqp

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www-user
RUN useradd -u 1000 -ms /bin/bash -g www-user www-user

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www-user:www-user . /var/www

# Change current user to www-user
USER www-user

# Expose port 9000 and start php-fpm server
EXPOSE 9000 9001
CMD ["php-fpm"]
