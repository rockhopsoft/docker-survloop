#!/bin/bash
echo Running SurvLoop Intaller Part 2!

composer update

php artisan key:generate
php artisan make:auth

php artisan vendor:publish
php artisan migrate
php artisan optimize
composer dump-autoload
php artisan db:seed --class=SurvLoopSeeder
