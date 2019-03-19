#!/bin/bash
set -x

echo Running SurvLoop Intaller!.. Act 4

composer update

php artisan key:generate
php artisan make:auth

php artisan vendor:publish
php artisan migrate
php artisan optimize
composer dump-autoload
php artisan db:seed --class=SurvLoopSeeder
