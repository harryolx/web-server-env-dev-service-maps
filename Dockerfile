FROM ubuntu:trusty-20180712
MAINTAINER harryosmar <harryosmarsitohang@gmail.com>

ENV HTTPD_PREFIX /etc/apache2

# Configured timezone.
ENV TZ=Asia/Jakarta

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y curl

# install OS packages
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    git \
    libapache2-mod-php \
    netcat \
    php \
    php-cli \
    php-curl \
    php-dom \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-sqlite3 \
    php-zip \
    php-xdebug \
    php-gd \
    php-memcache \
    git \
    vim \
    s3cmd \
    rsyslog-gnutls \
    && phpenmod mcrypt \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod a+x /usr/local/bin/composer

# set vhost
ADD sites-available/maps.conf $HTTPD_PREFIX/sites-available/maps.conf
ADD mods-available/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini


RUN sed -i "s/display_errors = Off/display_errors = On/g" /etc/php/7.0/apache2/php.ini

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Remove default site, configs, and mods not needed
# WORKDIR $HTTPD_PREFIX
RUN rm -f \
    sites-enabled/000-default.conf \
    conf-enabled/serve-cgi-bin.conf \
    mods-enabled/autoindex.conf \
    mods-enabled/autoindex.load

# Enable additional configs and mods
RUN ln -s $HTTPD_PREFIX/mods-available/expires.load $HTTPD_PREFIX/mods-enabled/expires.load \
    && ln -s $HTTPD_PREFIX/mods-available/headers.load $HTTPD_PREFIX/mods-enabled/headers.load \
	&& ln -s $HTTPD_PREFIX/mods-available/rewrite.load $HTTPD_PREFIX/mods-enabled/rewrite.load \
    && a2enmod rewrite \
    && a2ensite maps.conf

EXPOSE 80

WORKDIR /var/www/html

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]