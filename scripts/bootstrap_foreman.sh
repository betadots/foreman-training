#!/bin/bash

echo "DNF: Clean metadata"
sudo dnf clean all
echo "Installing Repo Packages"
echo "foreman"
sudo dnf -y localinstall https://yum.theforeman.org/releases/3.4/el8/x86_64/foreman-release.rpm
# sudo yum -y localinstall https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm
echo "Katello"
sudo dnf -y localinstall https://yum.theforeman.org/katello/4.6/katello/el8/x86_64/katello-repos-latest.rpm
# sudo yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm
# echo "Katello-Client"
# sudo yum -y localinstall https://yum.theforeman.org/client/2.3/el7/x86_64/foreman-client-release.rpm
echo "Puppet 7"
sudo dnf -y localinstall https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
# sudo yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
# echo "RH SCL"
# sudo yum -y install epel-release centos-release-scl-rh
echo "Enable powetoools"
sudo dnf config-manager --set-enabled powertools
echo "Enable DNF Modules"
sudo dnf -y module enable katello:el8 pulpcore:el8

# centos 7
# echo "yum cleanup"
# sudo yum clean all
# sudo rm -fr /var/cache/yum/x86_64/7/*
# sudo yum makecache

echo "DNF update"
sudo dnf -y update

echo "installing some tools: tree vim net-tools"
sudo dnf -y install tree vim net-tools

# echo "python-qpid fix (https://community.theforeman.org/t/katello-installation-broken/21374)"
# sudo yum -y localinstall https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/p/python2-qpid-1.37.0-4.el7.noarch.rpm

echo "Katello installation part 2"
sudo dnf -y install foreman-installer-katello
# sudo yum -y install katello

if [ ! -d /var/lib/tftpboot/boot ]; then
  echo "fix for https://github.com/theforeman/puppet-foreman/issues/580"
  echo "creating boot directory foir tftpserver"
  sudo mkdir -p /var/lib/tftpboot/boot
fi

echo "Jetzt einloggen, root user werden und installer starten"
echo "vagrant ssh foreman.betadots.training"
echo "sudo -i"
echo "foreman-installer --scenario katello -i --tuning development"
