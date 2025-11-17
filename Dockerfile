FROM nginx:alpine

WORKDIR /app

COPY . /app

COPY _docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
