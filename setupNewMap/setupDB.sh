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
