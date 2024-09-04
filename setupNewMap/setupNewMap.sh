#!/bin/bash

# this script is used for creating a new map site and relative settings for a organization

# get info of organization
read -p "enter the name of organization : " organ_name
read -p "enter the abbreviation of organization : " organ_abbre
read -p "enter the region of organization : " organ_region
read -p "enter the port of map site : " map_port
read -p "enter the latitude of map site : " organ_lat
read -p "enter the longitude of map site : " organ_lon
read -p "enter the ip of mosquitto server (make sure `connect` container in docker can use this ip connect to mosquitto server) : " mqtt_ip
read -p "enter the port of mosquitto server : " mqtt_port  

# create /var/www to place repo if it does not exist"
if [ ! -d /var/www ]; then
    sudo mkdir /var/www
fi

# create /var/www/mqttElderyMeal to place repo if it does not exist"
root_path="/var/www/mqttElderyMeal/"
if [ ! -d /var/www/mqttElderyMeal ]; then
    sudo mkdir root_path
fi

# clone repo from github
echo -e "\nclone repo from github"
username="tommygood"
repo_path=$root_path${organ_region}_${organ_abbre}
read -p "enter the password of ${username} on github : " password
sudo git clone https://$username:$password@github.com/$username/FoodDelivery.git $repo_path

# setting config.json, replace the variable of this organization
echo -e "\nsetting config.json, replace the variable of this organization"
cp config.json $repo_path
sed -i -e s/organ_name/${organ_name}/g $repo_path/config.json
sed -i -e s/organ_abbre/${organ_abbre}/g $repo_path/config.json
sed -i -e s/organ_region/${organ_region}/g $repo_path/config.json
sed -i -e s/map_port/${map_port}/g $repo_path/config.json
sed -i -e s/organ_lon/${organ_lon}/g $repo_path/config.json
sed -i -e s/organ_lat/${organ_lat}/g $repo_path/config.json

# setting mqtt.json, replace the variable of this organization
echo -e "\nsetting mqtt.json, replace the variable of this organization"
cp mqtt_template.json $repo_path/mqtt.json
sed -i -e s/organ_abbre/${organ_abbre}/g $repo_path/mqtt.json
sed -i -e s/organ_region/${organ_region}/g $repo_path/mqtt.json
sed -i -e s/mqtt_ip/${mqtt_ip}/g $repo_path/mqtt.json
sed -i -e s/mqtt_port/${mqtt_port}/g $repo_path/mqtt.json

# setting mqtt2.json, replace the variable of this organization
echo -e "\nsetting mqtt2.json, replace the variable of this organization"
cp mqtt2_template.json $repo_path/mqtt2.json
sed -i -e s/organ_abbre/${organ_abbre}/g $repo_path/mqtt2.json
sed -i -e s/organ_region/${organ_region}/g $repo_path/mqtt2.json
sed -i -e s/mqtt_ip/${mqtt_ip}/g $repo_path/mqtt2.json
sed -i -e s/mqtt_port/${mqtt_port}/g $repo_path/mqtt2.json

# create kafka topic with relative mqtt topic to receive message from mosquitto server
echo -e "\ncreate kafka topic with relative mqtt topic to receive message from mosquitto server"
curl -d @$repo_path/mqtt.json -H "Content-Type: application/json" -X POST http://127.0.0.1:8083/connectors
curl -d @$repo_path/mqtt2.json -H "Content-Type: application/json" -X POST http://127.0.0.1:8083/connectors
echo -e "\ncurrent kafka connection state : "
curl http://127.0.0.1:8083/connectors

# create db and dump schema of sql
echo -e "\ncreate db and dump schema of sql"
cp schema.sql temp_schema.sql
sed -i -e s/db_name/${organ_region}_${organ_abbre}/g temp_schema.sql
# create db user
db_user="im_meal"
db_password="meal@delivery"
sed -i -e s/db_user/${db_user}/g temp_schema.sql
sed -i -e s/db_password/${db_password}/g temp_schema.sql
sudo mysql < temp_schema.sql
rm temp_schema.sql

# activate map site with nodejs
echo -e "\nactivate map site with nodejs"
cd $repo_path
sudo pm2 start npm --name "${organ_region}_${organ_abbre}" -i 1 -- start # start with cluster mode and with one app
echo -e "\ncurrent pm2 list"
sudo pm2 list

# activate kafka conusmer
sleep_time=10
echo -e "\nsleep ${sleep_time} sec to wait the socket of nodejs ready"
sleep ${sleep_time}
echo -e "\n activate kafka consumer"
sudo python3 kafkaConnection.py -u ${organ_region}_${organ_abbre}

# check whether the map site can receive message which sending from mosquitto server
echo -e "\nuse the command below to check whether the map site can receive message which sending from mosquitto server : "
echo -e "mosquitto_pub -h ${mqtt_ip} -t ${organ_region}.${organ_abbre}/room1 -m '24.0757333333333,120.717493333333,測試外送員,40,63ff3Nk1TZDBSdXEweVBJMHRkYTBpYjkwWXJDNGNTbjZLazY,0' -p ${mqtt_port}"
