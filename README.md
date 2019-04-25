d# docker-survloop
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




<h1 class="slBlueDark">How To Install SurvLoop with Docker on Digital Ocean</h1>
<p>This process runs a variety of <a href="https://www.digitalocean.com/community/tutorials/how-to-set-up-laravel-nginx-and-mysql-with-docker-compose" target="_blank">Digital Ocean's layered tutorials</a>. I don't understand all of it yet, so will leave the explanations to their superb articles. This variation uses PostgresSQL instead of MYSQL, and it also adds SurvLoop stuff. You should be able to accept the defaults.</p>
<p>After starting up a new <b class="red">Ubuntu 18.04</b> Droplet, connect it with the root account and your SSH key. The first install script will create a non-root user, e.g. <span class="red">survuser</span>. Be sure to create and save a copy of a strong password, which you'll need handy throughout this install:</p>

<pre>$ git clone https://github.com/wikiworldorder/docker-survloop.git /usr/local/lib/docker-survloop
$ chmod +x /usr/local/lib/docker-survloop/bin/*.sh
$ /usr/local/lib/docker-survloop/bin/survloop-install-1.sh <span class="red">survuser</span>
</pre>
<p>Then exit to logout as root, and log back in as <span class="red">survuser</span>. Your key should work, and you should have sudo power.</p>
<pre>$ exit
# ssh <span class="red">survuser</span>@<span class="red">YOUR.SERVER.IP</span>
</pre>
<h3 class="slBlueDark">Now logged in as a non-root user</h3>
<pre>$ sudo chmod +x /usr/local/lib/docker-survloop/bin/*.sh
$ bash /usr/local/lib/docker-survloop/bin/survloop-install-2.sh
$ cd ~/survloop
$ docker run --rm -v $(pwd):/app composer install
$ docker-compose up -d
$ docker-compose exec app nano .env
</pre>
<p>Update the .env file for your system with a database password you can create now...</p>
<pre>DB_PASSWORD=survlooppass</pre>
<p>Add on SurvLoop package...</p>
<pre>$ bash /usr/local/lib/docker-survloop/bin/survloop-install-3.sh
</pre>



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
