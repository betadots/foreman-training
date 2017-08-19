# Foreman Training

## Initialisieren:

Es werden zwei Vagrant Plugins eingesetzt:

    vagrant plugin install vagrant-hostmanager
    vagrnat plugin install vagrant-vbguest

Jetzt kann die VM instantiiert werden:

    cd vagrant
    vagrant up foreman.example42.training

Danach Login:

    vagrant ssh foreman.example42.training
    sudo -i
    foreman-installer -i

Den Output sichern. z.B.:

      Success!
      * Foreman is running at https://foreman.example42.training
          Initial credentials are admin / DhXNVncksVCTxSrF
      * Foreman Proxy is running at https://foreman.example42.training:8443
      * Puppetmaster is running at port 8140
      The full log is at /var/log/foreman-installer/foreman.log

Nun muessen die Dienste konfiguriert werden:

    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp


## Foreman Einrichtung fertigstellen

### Smart proxies

Foreman Login -> Infrastructure -> Smart proxies

Actions -> Refresh

Klick auf 'foreman.example42.training'

Auf Fehler prüfen.

### Netzwerk

Foreman Login -> Infrastructure -> Subnets -> 'foreman.training'

Tab Subnet: Primary DNS Server: 10.100.10.101
Tab Domains: Auswaehlen 'example42.training'

Submit

### Domain

Foreman Login -> Infrastructure -> Domains

DNS Proxy -> 'foreman.example42.training' -> Submit

### Puppet Environments

    puppet module install garethr-docker
    puppet module install puppetlabs-ntp

Foreman Login -> Configure -> Puppet Environments -> 'Import environments from foreman.example42.training'

### Provisionieren

Foreman Login -> Infrastructure -> Provisioning Setup

Pre-requisites: Provisioning Network: 10.100.10.101/24 -> Submit
Network config: -> Submit
Foreman Installer: 'Install provisioning with DHCP' -> Kopieren und Ausfuehren -> Next
Installation Media: 'CentOS mirror' -> Submit

## Docker Setup

New Host
Host: Host Group -> Provision from foreman.example42.training
Host: Deploy on -> Bare Metal
Host: Environment -> production
Host: Puppet Master: foreman.example42.training
Host: Puppet CA: foreman.example42.training

Puppet Classes: docker

Interfaces: Edit
Eintragen: Mac Addresse und IP Adresse

Hinweis: vagrant box docker starten und MAC Adresse in Virtualbox auslesen.


Oprating System: root password

    vagrant up docker.example42.training
