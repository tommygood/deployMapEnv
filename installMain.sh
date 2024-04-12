#!/bin/bash

'''
# yum utils
sudo yum install -y yum-utils
sudo yum install -y gcc-c++ make git curl

# node
curl -sL https://rpm.nodesource.com/setup_20.x | sudo -E bash -
sudo yum install nodejs -y
sudo npm install -g pm2

# docker-compose install
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


# docker install
echo "install docker"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
'''

# clone repo
username="tommygood"
echo "start git clone the repo"
git clone https://github.com/$username/deployMapEnv.git /var/www/

# activate services of docker-compose.yml with daemon mode
echo "docker-compose up in daemon mode"
sudo docker-compose up -d

'''
# MQTT
sudo yum install -y epel-release
sudo yum install mosquitto -y
sudo systemctl start mosquitto
sudo systemctl enable mosquitto
'''
