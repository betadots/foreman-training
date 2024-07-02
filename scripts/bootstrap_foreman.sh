#!/bin/bash

echo "DNF: Clean metadata"
sudo dnf clean all
echo "Installing Repo Packages"
echo "foreman"
sudo dnf -y localinstall https://yum.theforeman.org/releases/3.10/el9/x86_64/foreman-release.rpm
echo "Katello"
sudo dnf -y localinstall https://yum.theforeman.org/katello/4.12/katello/el9/x86_64/katello-repos-latest.rpm
echo "Puppet 7"
sudo dnf -y install https://yum.puppet.com/puppet7-release-el-9.noarch.rpm
echo "Enable DNF Modules"
sudo dnf -y repolist enabled

echo "DNF update"
sudo dnf -y update

echo "installing some tools: tree vim net-tools"
sudo dnf -y install tree vim net-tools

echo "Katello installation part"
sudo dnf -y install foreman-installer-katello

if [ ! -d /var/lib/tftpboot/boot ]; then
  echo "fix for https://github.com/theforeman/puppet-foreman/issues/580"
  echo "creating boot directory for tftpserver"
  sudo mkdir -p /var/lib/tftpboot/boot
fi

echo "Jetzt einloggen, root user werden und installer starten"
echo "vagrant ssh foreman.betadots.training"
echo "sudo -i"
echo "foreman-installer --scenario katello -i # --tuning development"
