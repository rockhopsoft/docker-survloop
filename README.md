# docker-survloop
Docker Compose configuration for SurvLoop ^0.1 running PHP 7.3 with Nginx, PHP-FPM, PostgreSQL 11.2 and Composer.

## Overview

Docker Compose configuration for SurvLoop ^0.1 running PHP 7.3 with Nginx, PHP-FPM, PostgreSQL 11.2 and Composer. 
It exposes 4 services:

* web (Nginx)
* php (PHP 7.3 with PHP-FPM)
* db (PostgreSQL 11.2)
* composer
* survloop

The PHP image comes with the most commonly used extensions and is configured with xdebug.
The UUID extension for PostgreSQL has been added.
Nginx default configuration is set up for Symfony 4 and serves the working directory.
Composer is run at boot time and will automatically install the vendors.

Thank you to https://github.com/ineat/docker-php-nginx-postgres-composer for getting me started in the Docker world.

## Install prerequisites

You will need:

* [Docker CE](https://docs.docker.com/engine/installation/)
* [Docker Compose](https://docs.docker.com/compose/install)
* Git (optional)

## How to use it


### Starting Docker Compose

Checkout the repository or download the sources.

Simply run `docker-compose up` and you are done.

Nginx will be available on `localhost:80` and PostgreSQL on `localhost:5432`.


## Change configuration

### Configuring PHP

To change PHP's configuration edit `.docker/conf/php/php.ini`.
Same goes for `.docker/conf/php/xdebug.ini`.

You can add any .ini file in this directory, don't forget to map them by adding a new line in the php's `volume` section of the `docker-compose.yml` file.

### Configuring PostgreSQL

Any .sh or .sql file you add in `./.docker/conf/postgres` will be automatically loaded at boot time.

If you want to change the db name, db user and db password simply edit the `.env` file at the project's root.

If you connect to PostgreSQL from localhost a password is not required however from another container you will have to supply it.
