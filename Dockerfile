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
RUN apt-get install -y git
RUN apt-get update
RUN apt-get install -y unzip
RUN apt-get update
RUN apt-get install -y php7.4 php7.4-cli
RUN apt-get install -y php7.4-bcmath php7.4-bz2 php7.4-intl php7.4-gd php7.4-mbstring php7.4-mysql php7.4-curl php7.4-zip php7.4-xml
RUN apt-get install -y curl
RUN apt-get install -y sudo
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y gcc g++ make
RUN apt-get install -y nodejs
RUN apt-get -y install build-essential
RUN npm install --global cross-env

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

ENV ALLOW_OVERRIDE All
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN chown -R www-data:www-data /var/www/html
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i '/<Directory \/var\/www\/html\/public>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


EXPOSE 80

CMD ["apache2ctl", "-D","FOREGROUND"]
