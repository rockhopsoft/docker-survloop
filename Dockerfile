FROM php:7.3-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get upgrade && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libpq-dev \
    locales \
    zip \
    unzip \
    wget \
    jpegoptim optipng pngquant gifsicle \
    vim \
    nano \
    git \
    curl

# php7.3-mbstring
#RUN docker-php-ext-install php7.3-mbstring

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo pdo_pgsql pgsql zip exif pcntl 
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install -j$(nproc) iconv
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# RUN /etc/init.d/postgresql start &&\
#     psql --command "CREATE USER {DB_USERNAME} WITH SUPERUSER PASSWORD '{DB_PASSWORD}';" &&\
#     createdb -O {DB_DATABASE} {DB_USERNAME}

# Install composer and SurvLoop
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer require wikiworldorder/survloop
#RUN php -d memory_limit=1024M composer require wikiworldorder/survloop

# Copy existing application directory contents
COPY . /var/www
# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Double-check permissions needed to install and run Laravel and SurvLoop
RUN mkdir /var/www/app/Models
RUN mkdir /var/www/database/seeds
RUN chmod -R gu+w www-data:33 /var/www/app/Models
RUN chmod -R gu+w www-data:33 /var/www/app/User.php
RUN chmod -R gu+w www-data:33 /var/www/config
RUN chmod -R gu+w www-data:33 /var/www/database
RUN chmod -R gu+w www-data:33 /var/www/storage/app

# Change current user to www
USER www
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
