#!/bin/bash

echo "Yum update"
sudo yum update -y

echo "Installing Repo Packages"
echo "Puppet 6"
sudo yum -y install https://yum.puppetlabs.com/puppet6-release-el-7.noarch.rpm

echo "installing some tools: tree vim net-tools"
sudo yum -y install tree vim net-tools

echo "installing puppet agent"
sudo yum -y install puppet-agent

echo "using forman dns"
cat << EOF > /etc/resolv.conf
domain example42.training
nameserver 10.100.10.101
nameserver 8.8.8.8
options timeout:1
EOF

echo "setting puppet server"
cat << EOF > /etc/puppetlabs/puppet/puppet.conf
[agent]
server = foreman.example42.training
EOF

echo "first puppet run"
sudo /opt/puppetlabs/bin/puppet agent --test

echo "Jetzt einloggen, root user werden und puppet agent starten"
echo "vagrant ssh docker.example42.training"
echo "sudo -i"
echo "puppet agent --test"

