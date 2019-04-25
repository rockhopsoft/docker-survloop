#!/bin/bash
set -x
# ******* Running SurvLoop Laradock Intaller *******

cp .env.example .env
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/g' .env
sed -i 's/DB_DATABASE=homestead/DB_DATABASE=default/g' .env
sed -i 's/DB_USERNAME=homestead/DB_USERNAME=default/g' .env

# Laravel basic preparations
composer install
php artisan key:generate
php artisan make:auth

# Install SurvLoop & OpenPolice
composer require wikiworldorder/survloop

composer dump-autoload
php artisan optimize

# Install SurvLoop user model
#cp vendor/wikiworldorder/survloop/src/Models/User.php app/User.php
#sed -i 's/namespace App\\Models;/namespace App;/g' app/User.php
sed -i 's/App\\User::class/App\\Models\\User::class/g' config/auth.php

# Clear caches for good measure, then push copies of vendor files
echo "0" | php artisan vendor:publish --force

# Migrate database designs, and seed with data
php artisan migrate

php artisan optimize
composer dump-autoload

php artisan db:seed --class=SurvLoopSeeder
php artisan db:seed --class=ZipCodeSeeder
php artisan db:seed --class=OpenPoliceSeeder
php artisan db:seed --class=OpenPoliceDeptSeeder

php artisan optimize
composer dump-autoload
