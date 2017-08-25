#!/bin/bash

echo "Installing Repo Packages"
echo "Katello"
sudo yum -y localinstall http://fedorapeople.org/groups/katello/releases/yum/3.4/katello/el7/x86_64/katello-repos-latest.rpm
echo "foreman"
sudo yum -y localinstall http://yum.theforeman.org/releases/1.15/el7/x86_64/foreman-release.rpm
echo "Puppet 4"
sudo yum -y localinstall https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm # will install with Puppet 4
echo "epel"
sudo yum -y localinstall http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm


echo "Yum update"
sudo yum -y update

echo "Katello installation"
sudo yum -y install katello

echo "installing some tools: tree vim net-tools"
sudo yum -y install tree vim net-tools

echo "installing foreman installer"
sudo yum -y install foreman-release-scl

echo "Jetzt einloggen, root user werden und installer starten"
echo "vagrant ssh katello.example42.training"
echo "sudo -i"
echo "foreman-installer --scenario katello --help"

