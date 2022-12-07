#!/bin/bash
#
# Dieses Script bereitet ein Linux System auf die Nutzung des Trainings vor.
# Hier werden VirtualBox, Vagrnat und die erforderlichen Plugins installiert.
# Ausserdem wird die notwendige Vagrant Box heruntergeladen.

# falls keine sources.list vorhanden ist:
# sudo cat <<EOF >/etc/apt/sources.list
# deb http://ftp.de.debian.org/debian bullseye main contrib non-free
# deb http://ftp.de.debian.org/debian-security bullseye/updates main contrib non-free
# deb http://ftp.de.debian.org/debian bullseye-updates main contrib non-free
# EOF

sudo apt update
sudo apt install -y git

# VirtualBox
deb=$(curl -w "%{filename_effective}" -LO https://download.virtualbox.org/virtualbox/7.0.4/virtualbox-7.0_7.0.4-154605~Debian~bullseye_amd64.deb) && sudo dpkg -i $deb && rm $deb && unset deb

# Vagrant
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vagrant

# Vagrant Plugins
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-disksize

echo "Wenn nach dem Provider gefragt wird, bitte VirtualBox auswaehlen"
vagrant box add centos/stream8 --provider virtualbox
