#!/bin/bash

# this script is used for installing and setting the necessary utils about map system

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

# create /var/www to place repo if it does not exist"
if [ ! -d /var/www ]; then
    sudo mkdir /var/www
fi

# clone repo
username="tommygood"
echo "start git clone the repo"
git clone https://github.com/$username/deployMapEnv.git /var/www/deployMapEnv

# activate services of docker-compose.yml with daemon mode
echo "docker-compose up in daemon mode"
sudo docker-compose -f /var/www/deployMapEnv/setupUtilsEnv/docker-compose.yml up -d

# MQTT
sudo yum install -y epel-release
sudo yum install mosquitto -y
sudo systemctl start mosquitto
sudo systemctl enable mosquitto
sudo cp /var/www/deployMapEnv/setupUtilsEnv/mosquitto.conf /etc/mosquitto/mosquitto.conf # overwrite config of mosquitto
sudo systemctl restart mosquitto
sudo firewall-cmd --permanent --add-port=19883/tcp # open 19883 port to make others can access mosquitto server 
sudo firewall-cmd --reload

# redis
sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-9.rpm # change the num of release-[num] with different version of epel-release(use sudo yum repolist to check version)
sudo yum -y --enablerepo=remi install redis
sudo systemctl start redis
sudo systemctl enable redis

# mariadb
sudo yum install mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

# install pip3 and relative python packages
sudo yum -y install python3-pip
sudo pip3 install kafka-python python-socketio python-socketio[client] python-daemon mysql-connector geopy redis

# install Auto_Backup_DB
sudo git clone https://github.com/tommygood/Auto_Backup_DB /var/www/deployMapEnv/Auto_Backup_DB
echo "Make sure you have set config correctly in Auto_Backup_DB"
