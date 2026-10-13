FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
        gcc \
        libfcgi-dev \
        spawn-fcgi \
        nginx \
    && rm -rf /var/lib/apt/lists/*

COPY ./server/server.c /tmp/
RUN gcc /tmp/server.c -o /usr/local/bin/fastcgi-server -lfcgi

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

# RUN groupadd -r for_docker && useradd -r -g for_docker for_docker

# USER for_docker

CMD spawn-fcgi -p 8080 -n /usr/local/bin/fastcgi-server & nginx -g "daemon off;"
