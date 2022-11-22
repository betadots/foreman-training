#!/bin/bash

echo "Installing Repo Packages"
echo "foreman"
sudo yum -y localinstall https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm
echo "Katello"
sudo yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm
echo "Katello-Client"
sudo yum -y localinstall https://yum.theforeman.org/client/2.3/el7/x86_64/foreman-client-release.rpm
echo "Puppet 6"
sudo yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
echo "RH SCL"
sudo yum -y install epel-release centos-release-scl-rh


echo "yum cleanup"
sudo yum clean all
sudo rm -fr /var/cache/yum/x86_64/7/*
sudo yum makecache

echo "Yum update"
sudo yum -y update

echo "installing some tools: tree vim net-tools"
sudo yum -y install tree vim net-tools

echo "python-qpid fix (https://community.theforeman.org/t/katello-installation-broken/21374)"
sudo yum -y localinstall https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/p/python2-qpid-1.37.0-4.el7.noarch.rpm

echo "Katello installation part 2"
sudo yum -y install katello

if [ ! -d /var/lib/tftpboot/boot ]; then
  echo "fix for https://github.com/theforeman/puppet-foreman/issues/580"
  echo "creating boot directory foir tftpserver"
  sudo mkdir -p /var/lib/tftpboot/boot
fi

echo "Jetzt einloggen, root user werden und installer starten"
echo "vagrant ssh foreman.betadots.training"
echo "sudo -i"
echo "foreman-installer --scenario katello -i"
