ARG PHP_VERSION=8.0

FROM phpdockerio/php:${PHP_VERSION}-fpm

ARG PHP_VERSION
ARG SMF_VERSION

RUN apt-get update; \
    apt-get -y --no-install-recommends install \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-imagick \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mysql \
        php${PHP_VERSION}-pgsql \
        php${PHP_VERSION}-memcached \
        php${PHP_VERSION}-redis \
        nginx \
        curl \
        unzip \
        ca-certificates; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR /app

RUN set -eux; \
    SMF_VERSION_DASH="${SMF_VERSION//./-}"; \
    curl -s -k -o install.zip "https://download.simplemachines.org/index.php/smf_${SMF_VERSION_DASH}_install.zip"; \
    unzip install.zip; \
    rm install.zip; \
    chown -R www-data:www-data .; \
    chmod -R 777 .

COPY _docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i 's|^listen = .*|listen = 127.0.0.1:9000|' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

COPY _docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443

CMD ["/entrypoint.sh"]
