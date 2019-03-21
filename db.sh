#!/bin/bash
#
#	Datenbank installieren und Konfigurieren
#

# root Password setzen, damit kein Dialog erscheint und die Installation haengt!
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password Welcome1'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password Welcome1'

# Installation
sudo apt-get install -y mysql-server

# MySQL Port oeffnen
sudo sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# User fuer Remote Zugriff einrichten - aber nur fuer Host web 192.168.10.1
mysql -uroot -Welcome1 <<%EOF%
	CREATE USER 'admin'@'192.168.10.101' IDENTIFIED BY '1234';
	GRANT ALL PRIVILEGES ON *.* TO 'admin'@'192.168.10.101';
%EOF%

# Restart fuer Konfigurationsaenderung
sudo service mysql restart
