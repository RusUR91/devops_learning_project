#!/bin/bash

sudo apt update
sudo apt install -y docker
sudo apt install -y docker-compose
sudo usermod -aG docker "$USER"

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker "$USER"

# Initialize Docker Swarm
docker swarm init --advertise-addr 192.168.56.50
TOKEN=$(docker swarm join-token -q worker)
MANAGER_TOKEN=$(docker swarm join-token -q manager)
# Save the token to a file for later use
echo $TOKEN > /vagrant/services/scripts/token.txt

# deploy
docker network create --driver overlay --attachable monitoring	
