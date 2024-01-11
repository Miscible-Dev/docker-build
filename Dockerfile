FROM php:8.1-fpm-alpine

RUN apk update && apk add --no-cache nginx wget
RUN mkdir -p /run/nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache zip \
    unzip \
    git \
    curl \
    # Added to install autoconf
    autoconf \  
    # Often required for building PHP extensions
    g++ \       
    # Often required for building PHP extensions
    make \ 
    # Added to install zlib development packages
    zlib-dev \        
    # Optional: for JPEG support
    libjpeg-turbo-dev \ 
    # Optional: for WebP support
    libwebp-dev \      
    # Optional: for FreeType support
    freetype-dev \
    # Confirm this is the correct package name      
    linux-headers      

# Install gd /Install grpc and probuf with pecl
RUN docker-php-ext-install gd && \
    pecl install grpc \
    pecl install protobuf

RUN docker-php-ext-enable grpc\
    protobuf \
    gd \
    sodium

RUN mkdir -p /app
COPY . /app
# COPY ./src /app

RUN wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer && apk add --update nodejs npm
RUN cd /app/src && \
    /usr/local/bin/composer install --no-dev 

RUN chown -R www-data: /app
RUN chmod +x /app/docker/startup.sh
CMD sh /app/docker/startup.sh

