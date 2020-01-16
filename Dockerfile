FROM ubuntu:18.04

# START BASE --------------------------------------------------------

# install base soft for allow apt-add-repository
## Disable interactive install
RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get update -qq \
    && apt-get -qqy install software-properties-common apt-utils locales tzdata \
    && apt-get install -y --no-install-recommends libzip-dev unzip procps inotify-tools

# set UTC timezone
RUN echo "UTC" > /etc/timezone \
    && rm -f /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && date

# install git
RUN apt-get install -y git zip unzip

RUN apt-get -qqy install build-essential libssl1.0-dev curl wget libfontconfig1 libxrender1 ghostscript fontconfig htop

RUN apt-add-repository ppa:ondrej/php

# install requirements (php)
RUN apt-get update -qq \
    && apt-get -qqy install php php-common php-xdebug php-curl php7.4-dom php-mbstring \
    && apt-get -y clean > /dev/null \
    && rm -rf /var/www/* && rm -rf /var/lib/apt/lists/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && composer clear-cache \
    && composer global require hirak/prestissimo

RUN rm -rf /srv/www/* && mkdir /srv/www \
    # Clean up
    && apt-get -y clean > /dev/null \
    && rm -rf /var/www/* && rm -rf /var/lib/apt/lists/*

# END BASE --------------------------------------------------------

WORKDIR /srv/www

RUN rm -rf vendor

COPY . /srv/www

RUN chmod +x /srv/www/*

ENTRYPOINT ["tail", "-f", "/dev/null"]
