#!/usr/bin/env bash

# Upgrade Packages
echo "Upgrading Ubuntu…"
apt-get update
apt-get -y upgrade

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
echo "Installing MySQL…"
echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
apt-get -y install mysql-server

# Setup MySQL Database & Users
#echo "Preparing database…"
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS ape;"
mysql -uroot -proot -e "CREATE USER 'ape'@'localhost' IDENTIFIED BY 'ape';"
mysql -uroot -proot -e "GRANT ALL ON ape.* TO 'ape'@'localhost';"
mysql -uroot -proot -e "FLUSH PRIVILEGES;"

# Load Last Dump Database
export DB_BACKUP_FILEPATH=/vagrant/provision.sql.gz
if [ -f $DB_BACKUP_FILEPATH ]; then
    echo "Loading existing database…"
    gunzip < $DB_BACKUP_FILEPATH | mysql -uroot -proot ape
fi

# Install Other Packages…
echo "Installing utilities and NodeJS…"
apt-get -y install nfs-common nodejs nodejs-legacy npm node-mysql

# Install project dependencies
echo "Installing dependencies..."
cd /vagrant/ && npm install

# End
echo "Ready for action!"
