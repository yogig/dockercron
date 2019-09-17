FROM php:7.2-fpm-alpine

LABEL maintainer="info@milchundzucker.de" \
      muz.customer="lufthansa" \
      muz.product="widc" \
      container.mode="development"

#https://pkgs.alpinelinux.org/packages
RUN apk add --no-cache --virtual .deps autoconf tzdata build-base libzip-dev mysql-dev gmp-dev \
            libxml2-dev libpng-dev zlib-dev freetype-dev jpeg-dev icu-dev openldap-dev libxslt-dev &&\
    docker-php-ext-install zip xml mbstring json intl gd pdo pdo_mysql iconv soap \
                           dom gmp fileinfo sockets bcmath mysqli ldap xsl &&\
    echo 'date.timezone="Europe/Berlin"' >> "${PHP_INI_DIR}"/php.ini &&\
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime &&\
    echo 'Europe/Berlin' > /etc/timezone &&\
    curl -s https://www.phing.info/get/phing-latest.phar > /bin/phing &&\
    chmod a+x /bin/phing &&\
    ln -s /bin/phing /usr/local/bin/phing &&\
    ln -s /bin/phing /usr/local/phing &&\
    ln -s /bin/phing /usr/bin/phing &&\
    apk del .deps &&\
    apk add --no-cache libzip mysql libxml2 libpng zlib freetype jpeg icu gmp git subversion libxslt openldap \
            apache2 apache2-ldap apache2-proxy libreoffice openjdk11-jre ghostscript msttcorefonts-installer \
            terminus-font ghostscript-fonts &&\
    ln -s /usr/lib/apache2 /usr/lib/apache2/modules &&\
    ln -s /usr/sbin/httpd /etc/init.d/httpd &&\
    update-ms-fonts

#https://github.com/docker-library/httpd/blob/3ebff8dadf1e38dbe694ea0b8f379f6b8bcd993e/2.4/alpine/httpd-foreground
#https://github.com/docker-library/php/blob/master/7.2/alpine3.10/fpm/Dockerfile
CMD ["/bin/sh", "-c", "rm -f /usr/local/apache2/logs/httpd.pid && httpd -DBACKGROUND && php-fpm"]