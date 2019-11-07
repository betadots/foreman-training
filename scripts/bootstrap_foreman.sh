#!/bin/bash

echo "Yum update"
sudo yum update

echo "Installing Repo Packages"
echo "Puppet 6"
sudo yum -y install https://yum.puppetlabs.com/puppet6/puppet6-release-el-7.noarch.rpm
echo "epel"
sudo yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
echo "foreman"
sudo yum -y install https://yum.theforeman.org/releases/1.23/el7/x86_64/foreman-release.rpm

echo "installing some tools: tree vim net-tools"
sudo yum -y install tree vim net-tools

echo "installing foreman installer"
sudo yum -y install foreman-installer

echo "fix for https://github.com/theforeman/puppet-foreman/issues/580"
sudo mkdir -p /var/lib/tftpboot/boot

echo "Jetzt einloggen, root user werden und installer starten"
echo "vagrant ssh foreman.example42.training"
echo "sudo -i"
echo "foreman-installer -i"

