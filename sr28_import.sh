#!/bin/bash

# first download and unzip USDA National Nutrient Database (Release SR-28) ASCII version
#wget https://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR/SR28/dnload/sr28asc.zip
unzip ./sr28asc.zip

# transform all data files from DOS to UNIX file format
dos2unix *.txt

# set MySQL variables used for later database management operations
MYSQL_HST=127.0.0.1
MYSQL_PORT=3306
MYSQL_USR=$1
MYSQL_PWD=$2

# create database with predefined schema
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} < ./sr28_schema.sql &&

# the following data imports only work, if mysql -h${MYSQL_HST} -P${MYSQL_PORT} permits to import 
# these files. To prepare for the correct permission, path to CSV 
# files must be added to apparmor config, and apparmor config must 
# be reloaded.
#
#   1) sudo vim /etc/apparmor.d/usr.sbin.mysqld 
#   2) add line "/path/to/csv/ rw" to file within curly brackets
#   3) sudo /etc/init.d/apparmor reload
#

HOME=`pwd`
# import USDA SR-28 data files into predefined table schema
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/FD_GROUP.txt' INTO TABLE FD_GROUP FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/FOOD_DES.txt' INTO TABLE FOOD_DES FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/DATA_SRC.txt' INTO TABLE DATA_SRC FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/DERIV_CD.txt' INTO TABLE DERIV_CD FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/FOOTNOTE.txt' INTO TABLE FOOTNOTE FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/LANGDESC.txt' INTO TABLE LANGDESC FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/WEIGHT.txt' INTO TABLE WEIGHT FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/NUTR_DEF.txt' INTO TABLE NUTR_DEF FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/LANGUAL.txt' INTO TABLE LANGUAL FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/SRC_CD.txt' INTO TABLE SRC_CD FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/DATSRCLN.txt' INTO TABLE DATSRCLN FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28; LOAD DATA LOCAL INFILE '${HOME}/NUT_DATA.txt' INTO TABLE NUT_DATA FIELDS TERMINATED BY '^' ENCLOSED BY '\~';" &&

echo "USDA National Nutrient Database imported successfully"
rm *.txt
echo "Clean up complete."

# run test query
mysql -h${MYSQL_HST} -P${MYSQL_PORT} -u${MYSQL_USR} -p${MYSQL_PWD} -e "USE usdanlsr28;select * from NUT_DATA;"
