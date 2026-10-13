#!/bin/bash

apt-get update
    apt-get install -y curl firewalld nginx
    curl -fsSL https://get.docker.com | sh
    apt-get install -y docker-compose-plugin
    usermod -aG docker vagrant
    
    systemctl enable firewalld
    systemctl start firewalld
    systemctl start nginx
    
    if ! swapon --show | grep -q '/swapfile'; then
      fallocate -l 1G /swapfile
      chmod 600 /swapfile
      mkswap /swapfile
      swapon /swapfile
      echo '/swapfile none swap sw 0 0' >> /etc/fstab
    fi
    
    case "$HOSTNAME" in
      manager01)
        /vagrant/scripts/manager_ports.sh
        /vagrant/scripts/manager_swarm.sh
        ;;
      worker*)
        /vagrant/scripts/worker_ports.sh
        /vagrant/scripts/token.sh
        ;;
    esac
    
    if [ "$HOSTNAME" = "manager01" ]; then
      /vagrant/scripts/manager_deploy.sh
    fi

