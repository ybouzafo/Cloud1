#!/bin/bash

service mariadb start

sleep 2

mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY ${MYSQL_ROOT_PASSWORD};"

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};\
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';\
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';\
FLUSH PRIVILEGES;"

service mariadb stop

exec mysqld_safe --bind-address=0.0.0.0 --port=3306