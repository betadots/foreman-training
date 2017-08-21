#!/bin/bash

echo "Yum update"
sudo yum update

echo "Installing Repo Packages"
echo "Puppet 4"
sudo yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

echo "installing some tools: tree vim net-tools"
sudo yum -y install tree vim net-tools

echo "installing puppet agent"
sudo yum -y install puppet-agent

echo "Jetzt einloggen, root user werden und puppet agent starten"
echo "vagrant ssh docker.example42.training"
echo "sudo -i"
echo "puppet agent --test --server foreman.example42.training"

