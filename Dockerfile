FROM php:7.2-apache
MAINTAINER Michał Szczech <m.szczech@hotmail.com>

# Setup timezone
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "date.timezone=$TZ" >> /usr/local/etc/php/conf.d/default.ini

# Update sources
RUN apt-get update -y

# Enable "mod_rewrite" – http://httpd.apache.org/docs/current/mod/mod_rewrite.html
RUN a2enmod rewrite

# Enable "mod_headers" – http://httpd.apache.org/docs/current/mod/mod_headers.html
RUN a2enmod headers

# Enable "mod_expires" – http://httpd.apache.org/docs/current/mod/mod_expires.html
RUN a2enmod expires

# Install "Git" – https://git-scm.com/
RUN apt-get install -y git

# Install "Composer" – https://getcomposer.org/
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Midnight Commander, Vim, Nano
RUN apt-get install -y mc vim nano

# Install "mysql-client" – https://dev.mysql.com/doc/refman/5.7/en/mysql.html
RUN apt-get install -y mysql-client

# Install "psql" – https://www.postgresql.org/docs/current/static/app-psql.html
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=884457
# RUN apt-get install -y postgresql-client

# Install "ImageMagick" executable – https://www.imagemagick.org/script/index.php
RUN apt-get install -y imagemagick

# Install PHP "gd" extension
RUN apt-get install -y libjpeg-dev libpng-dev
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

# Install PHP "curl" extension – http://php.net/manual/en/book.curl.php
RUN apt-get install -y zlib1g-dev libicu-dev g++
RUN apt-get install -y libcurl4-openssl-dev
RUN docker-php-ext-install curl

# Install PHP "intl" extension – http://php.net/manual/en/book.intl.php
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

# Install PHP "xsl" extension – http://php.net/manual/en/book.xsl.php
RUN apt-get install -y libxslt-dev
RUN docker-php-ext-install xsl

# Install PHP "exif" extension – http://php.net/manual/en/book.exif.php
RUN apt-get install -y libexif-dev
RUN docker-php-ext-install exif

# Install PHP "mysqli" extension – http://php.net/manual/pl/book.mysqli.php
RUN docker-php-ext-install mysqli

# Install PHP "pdo" extension with "mysql", "pgsql", "sqlite" drivers – http://php.net/manual/pl/book.pdo.php
RUN apt-get install -y libpq-dev libsqlite3-dev
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_mysql pgsql pdo_pgsql pdo_sqlite

# Install PHP "opcache" extension – http://php.net/manual/en/book.opcache.php
RUN docker-php-ext-install opcache

# Install PHP "zip" extension – http://php.net/manual/en/book.zip.php
RUN apt-get install -y zlib1g-dev
RUN docker-php-ext-install zip

# Install PHP "memcached" extension – http://php.net/manual/en/book.memcached.php
RUN apt-get install -y libmemcached-dev \
&& cd /tmp \
&& git clone -b php7 https://github.com/php-memcached-dev/php-memcached.git \
&& cd php-memcached \
&& phpize \
&& ./configure \
&& make \
&& echo "extension=/tmp/php-memcached/modules/memcached.so" > /usr/local/etc/php/conf.d/memcached.ini

# Cleanup the image
RUN rm -rf /var/lib/apt/lists/* /tmp/*
