#!/bin/bash

sudo apt update
sudo apt install -y docker.io
sudo usermod -aG docker "$USER"

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Join the Docker Swarm
JOIN_TOKEN=$(cat /vagrant/services/script/token.txt)
docker swarm join --token "$JOIN_TOKEN" 192.168.56.50:2377
