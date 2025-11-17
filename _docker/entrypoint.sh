#!/bin/sh
set -e

# Start PHP-FPM in background
php-fpm &

# Start Nginx in foreground (keeps container alive)
nginx -g 'daemon off;'
