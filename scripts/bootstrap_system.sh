#!/bin/bash

echo "dnf update"
sudo dnf update -y

echo "Installing Repo Packages"
echo "Puppet 7"
sudo dnf localinstall https://yum.puppet.com/puppet7-release-el-8.noarch.rpm

echo "installing some tools: tree vim net-tools"
sudo dnf -y install tree vim net-tools

echo "installing puppet agent"
sudo dnf -y install puppet-agent

echo "using forman dns"
cat <<EOF >/etc/resolv.conf
domain betadots.training
nameserver 10.100.10.101
nameserver 8.8.8.8
options timeout:1
EOF

echo "setting puppet server"
cat <<EOF >/etc/puppetlabs/puppet/puppet.conf
[agent]
server = foreman.betadots.training
EOF

echo "Jetzt einloggen und root user werden"
echo "vagrant ssh <vm name>"
echo "sudo -i"
echo "Wenn Puppet genutzt werden soll, kann der Agent gestartet werden:"
echo "puppet agent --test"
