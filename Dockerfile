FROM php:7.3-fpm

# Copy composer.lock and composer.json
COPY composer.json /var/www/
#COPY composer.lock /var/www/

# Set working directory
WORKDIR /var/www

#RUN nano /etc/apt/sources.list
#RUN add-apt-repository "http://archive.ubuntu.com/ubuntu bionic main multiverse restricted universe"
#RUN add-apt-repository "http://archive.ubuntu.com/ubuntu bionic-updates main multiverse restricted universe"
#RUN add-apt-repository "http://archive.ubuntu.com/ubuntu bionic-security main multiverse restricted universe"

#RUN apt-get install php-dev libmcrypt-dev php-pear
#RUN apt-get install php-dev
#RUN apt-get install libmcrypt-dev
#RUN apt-get install php-pear
#RUN sudo pecl channel-update pecl.php.net
#RUN sudo pecl install mcrypt-1.0.1

# Install dependencies
RUN apt-get update
RUN apt-get upgrade 
RUN apt-get install -y \
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
    curl \
    php7.3-mbstring

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo pdo_pgsql pgsql php7.3-mbstring zip exif pcntl 
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
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer require rockhopsoft/survloop
#RUN php -d memory_limit=1024M composer require rockhopsoft/survloop

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
