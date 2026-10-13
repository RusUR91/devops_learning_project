#!/bin/bash

TOKEN=$(docker swarm init --advertise-addr 192.168.56.10 | awk 'NR==5')

rm /vagrant/scripts/token.sh

echo "#!/bin/bash" >> /vagrant/scripts/token.sh
echo "$TOKEN" >> /vagrant/scripts/token.sh

chmod + x /vagrant/scripts/token.sh
