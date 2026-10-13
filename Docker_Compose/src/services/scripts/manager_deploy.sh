#!/bin/bash

docker config create nginx_conf /vagrant/nginx_conf
docker stack deploy --with-registry-auth -c /vagrant/docker-compose.yml app

