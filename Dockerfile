FROM ubuntu:latest

MAINTAINER Olivier Philippe <olivier.philippe@gmail.com>

# Install php and apache
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 php7.0 libapache2-mod-php7.0 git


# Clone the repository that contain Steam Friend website
RUN git clone https://github.com/Kirom12/steam-gf /tmp


# Enable apache mods.
RUN a2enmod php7.0
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# Copy the repo into place
RUN mkdir /var/www/steam_ffs
RUN cp -R /tmp/* /var/www/steam_ffs

RUN chown www-data:www-data /var/www/steam_ffs -R
# Create the steam_key file and copy the key in it
RUN mkdir /app
RUN touch /app/steam_key.php

RUN echo "<?php define('STEAM_KEY', 'KEY_TO_REPLACE');" > /app/steam_key.php

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

## Cleaning
# RUN rm -rf /tmp

## Launch the entrypoint to get the steam_key in the approriate file


## STROUT apache logs
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log



# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /usr/sbin/apache2ctl -D FOREGROUND
