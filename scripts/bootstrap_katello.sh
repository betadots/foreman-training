#!/bin/bash

echo "Installing Repo Packages"
echo "Katello"
sudo yum -y install http://fedorapeople.org/groups/katello/releases/yum/3.14/katello/el7/x86_64/katello-repos-latest.rpm
echo "foreman"
sudo yum -y install http://yum.theforeman.org/releases/1.23/el7/x86_64/foreman-release.rpm
echo "Puppet 6"
sudo yum -y install https://yum.puppetlabs.com/puppet6/puppet6-release-el-7.noarch.rpm
echo "epel"
sudo yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm


echo "yum cleanup"
sudo yum clean all
sudo rm -fr /var/cache/yum/x86_64/7/*
sudo yum makecache

echo "Yum update"
sudo yum -y update

echo "installing some tools: tree vim net-tools"
sudo yum -y install tree vim net-tools

echo "installing foreman installer"
sudo yum -y install foreman-release-scl

echo "Katello installation part 2"
sudo yum -y install katello

echo "fix for https://github.com/theforeman/puppet-foreman/issues/580"
sudo mkdir -p /var/lib/tftpboot/boot

echo "Jetzt einloggen, root user werden und installer starten"
echo "vagrant ssh katello.example42.training"
echo "sudo -i"
echo "foreman-installer --scenario katello -i"

