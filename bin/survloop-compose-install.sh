#!/bin/bash
set -x
# ******* Running SurvLoop Intaller *******

composer global require "laravel/installer"
composer create-project laravel/laravel $1 "5.8.*"
cd $1

# Laravel basic preparations
php artisan key:generate
php artisan make:auth

# Install SurvLoop
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

php artisan optimize
composer dump-autoload
