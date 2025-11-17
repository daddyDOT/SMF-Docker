#!/bin/sh
set -e

# Start PHP-FPM in background
php-fpm &

# Start Nginx in foreground (keeps the container running)
nginx -g 'daemon off;'
