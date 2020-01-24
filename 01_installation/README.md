# Foreman Training - Teil 1 - Installation

## VirtualBox Vorbereitung

Unbedingt pruefen, ob die Host-only Netzwerke einen DHCP Server aktiviert haben !!

VirtualBox -> Einstellungen -> Netzwerk -> Host-Only Netzwerk -> DHCP Server

Wenn der Host-Only DHCP Server aktiv ist: deaktivieren.

## Initialisieren:

Es werden zwei Vagrant Plugins eingesetzt:

    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-vbguest

Jetzt kann die VM instantiiert werden:

    cd vagrant
    vagrant up foreman.example42.training

Danach Login:

    vagrant ssh foreman.example42.training
    sudo -i

Pruefen, ob eth1 Interface eine IP hat, ```ip a```. Wenn nein: ```ifup eth1```

    foreman-installer -i

Den Output sichern. z.B.:

      Success!
      * Foreman is running at https://foreman.example42.training
          Initial credentials are admin / DhXNVncksVCTxSrF
      * Foreman Proxy is running at https://foreman.example42.training:8443
      * Puppetmaster is running at port 8140
      The full log is at /var/log/foreman-installer/foreman.log

Nun muessen die Dienste konfiguriert werden:

    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp
    puppet apply /vagrant_foreman/scripts/04_selinux.pp

Achtung! Dieses Setup kann nur einmal durchgefuehrt werden.
Spaetestens das Provisionierungs Setup aendert diese Einstellungen grundlegend.

Namensauflösung prüfe Evtl in `/etc/named.conf` einen anderen "forwarder" eintragen (8.8.8.8).


# Foreman Training - Smart Proxies

Smart-Proxy ist ein Service, der auf einem System laeuft, welches Infrastruktur Komponenenten bereitstellt.
Dazu gehoeren zum Beispiel:

  - Puppet Server
  - DHCP Server
  - TFTP Server
  - DNS Server

## Foreman Web Interface

https://foreman.example42.training

## Smart proxies

Foreman Login -> Infrastructure -> Smart proxies

Actions -> Refresh

Klick auf 'foreman.example42.training'

Auf aktive Services und Fehler pruefen.

### Puppet Environments

    puppet module install puppetlabs-docker
    puppet module install puppetlabs-apache

Foreman Login -> Configure -> Puppet Environments -> 'Import environments from foreman.example42.training'

Haken setzen -> Update

## Domain

Foreman Login -> Infrastructure -> Domains -> 'example42.training'

- Tab Domain: DNS domain: 'example42.training'
- Tab Domain: DNS Proxy: 'foreman.example42.training'

Submit

## Netzwerk

Foreman Login -> Infrastructure -> Subnets -> Create Subnet

- Tab Subnet: Name: example42.training
- Tab Subnet: Network Address: 10.100.10.0
- Tab Subnet: Network Prefix: 24
- Tab Subnet: Gateway Address: 10.100.10.101
- Tab Subnet: Primary DNS Server: 10.100.10.101
- Tab Subnet: IPAM: DHCP
- Tab Subnet: Start of IP Range: 10.100.10.120
- Tab Subnet: End of IP Range: 10.100.10.240

- Tab Domains: example42.training ausaehlen

- Tab Proxies: foreman.example42.training bei DHCP, TFTP und Reverse DNS auswaehlen

Submit

Weiter geht es mit Teil 2 [Provisionieren](../02_provisioning)
