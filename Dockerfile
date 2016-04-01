############################################################
# Dockerfile to build Nginx Installed Containers
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# File Author / Maintainer
MAINTAINER Yousaf Syed

# Install Nginx

RUN mkdir -p /var/www/laravel/pricegenius_laravel/

RUN useradd -ms /bin/bash docker

ADD index.php /var/www/laravel/index.php

RUN adduser www-data docker

RUN chown -R docker:www-data /var/www/laravel

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y nano wget dialog net-tools

# Download and Install Nginx
RUN apt-get install -y nginx php5-fpm php5-cli php5-mcrypt git curl

RUN curl -sS https://getcomposer.org/installer | php

RUN mv composer.phar /usr/local/bin/composer

RUN php5enmod mcrypt

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/sites-available/default
RUN rm -v /etc/php5/fpm/php.ini
# Copy a configuration file from the current directory
ADD default /etc/nginx/sites-available/
ADD php.ini /etc/php5/fpm/php.ini 

# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80

# Set the default command to execute
# when creating a new container
CMD service nginx start && service php5-fpm start

