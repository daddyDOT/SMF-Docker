# Dockerfile

FROM php:8.2-fpm

# Install nginx + tools
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        nginx \
        curl \
        unzip \
        ca-certificates \
        openssl \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions for DB support
# - mysqli / pdo_mysql → MySQL/MariaDB
# - pdo_pgsql / pgsql → PostgreSQL (optional but nice to have)
RUN docker-php-ext-install mysqli pdo_mysql pdo_pgsql pgsql

# Create a self-signed SSL cert where nginx.conf expects it
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 \
      -subj "/CN=localhost" \
      -newkey rsa:2048 \
      -keyout /etc/nginx/ssl/nginx.key \
      -out /etc/nginx/ssl/nginx.crt

WORKDIR /app

# Download and unpack SMF (2.1.6 full install)
RUN set -eux; \
    curl -L -o install.zip "https://download.simplemachines.org/index.php/smf_2-1-6_install.zip"; \
    unzip install.zip; \
    rm install.zip; \
    chown -R www-data:www-data .; \
    chmod -R 777 .

# Use our own nginx config (full file)
COPY _docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Make php-fpm listen on 127.0.0.1:9000 (single-container setup)
RUN sed -i 's|^listen = .*|listen = 127.0.0.1:9000|' /usr/local/etc/php-fpm.d/www.conf

# Entry script to start php-fpm + nginx in the same container
COPY _docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 443

CMD ["/entrypoint.sh"]
