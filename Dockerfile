ARG PHP_VERSION=8.0
FROM phpdockerio/php:${PHP_VERSION}-fpm

ARG PHP_VERSION

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        nginx \
        curl \
        unzip \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR /app

RUN set -eux; \
    curl -L -o install.zip "https://download.simplemachines.org/index.php/smf_2-1-6_install.zip"; \
    unzip install.zip; \
    rm install.zip; \
    chown -R www-data:www-data .; \
    chmod -R 777 .

COPY _docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i "s|^listen = .*|listen = 127.0.0.1:9000|" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

COPY _docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443

CMD ["/entrypoint.sh"]
