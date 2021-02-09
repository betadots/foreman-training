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

echo "Jetzt einloggen und root user werden"
echo "vagrant ssh <vm name>"
echo "sudo -i"
echo "Wenn Puppet genutzt werden soll, kann der Agent gestartet werden:"
echo "puppet agent --test"

