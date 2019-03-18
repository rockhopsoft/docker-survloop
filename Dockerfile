FROM php:7.3-fpm

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
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

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring zip exif pcntl 
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

# Double-check permissions needed to auto-install Laravel & SurvLoop
RUN chown -R www-data:33 app
RUN chown -R www-data:33 config
RUN chown -R www-data:33 database
RUN chown -R www-data:33 storage
RUN chmod -R gu+w storage

# Install composer and SurvLoop
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN php artisan key:generate
RUN php artisan make:auth
RUN composer update
RUN composer require wikiworldorder/survloop
RUN composer update
RUN php artisan vendor:publish
RUN php artisan migrate
RUN php artisan optimize
RUN composer dump-autoload
RUN php artisan db:seed --class=SurvLoopSeeder

# Copy existing application directory contents
COPY . /var/www
# Copy existing application directory permissions
COPY --chown=www:www . /var/www
# Change current user to www
USER www
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
