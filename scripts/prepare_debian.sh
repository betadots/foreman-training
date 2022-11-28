#!/bin/bash
sudo cat <<EOF > /etc/apt/sources.list
deb http://ftp.de.debian.org/debian buster main contrib non-free
#deb-src http://ftp.de.debian.org/debian buster main contrib non-free

deb http://ftp.de.debian.org/debian-security buster/updates main contrib non-free
#deb-src http://deb.debian.org/debian buster/updates main contrib non-free

deb http://ftp.de.debian.org/debian buster-updates main contrib non-free
#deb-src http://debian/debian buster-updates main contrib non-free
EOF

sudo apt-get update
sudo apt-get install -y git

wget https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb
sudo dpkg -i vagrant_2.2.14_x86_64.deb

vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest

echo "Wenn nach dem Provider grfragt wird, bitte VirtualBox auswaehlen"
vagrant box add centos/8

