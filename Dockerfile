FROM ubuntu:18.04

RUN apt-get update

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get install -y apt-utils
RUN apt-get install -y nano
RUN apt-get install -y apache2 apache2-utils
RUN apt-get install -y software-properties-common
RUN echo date
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php7.4
RUN apt-get install -y php7.4-bcmath php7.4-bz2 php7.4-intl php7.4-gd php7.4-mbstring php7.4-mysql php7.4-zip php7.4-xml
RUN apt-get install -y curl
RUN apt-get install -y sudo
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get install -y nodejs

ENV ALLOW_OVERRIDE All
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["a2enmod", "rewrite"]
CMD ["apache2ctl", "-D","FOREGROUND"]
