#!/bin/sh
set -e

# Start PHP-FPM in background (php-fpm8.0, using PHP_VERSION env)
php-fpm${PHP_VERSION} &

# Start Nginx in foreground (keeps the container running)
nginx -g 'daemon off;'
