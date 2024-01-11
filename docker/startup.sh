#!/bin/sh

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

# while ! nc -w 1 -z 127.0.0.1 9000; do sleep 0.1; done;
php-fpm -D

nginx -g 'daemon off;'

