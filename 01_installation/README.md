# Foreman Training - Teil 1 - Installation

## VirtualBox Vorbereitung

Unbedingt pruefen, ob die Host-only Netzwerke einen DHCP Server aktiviert haben !!

VirtualBox -> Einstellungen -> Netzwerk -> Host-Only Netzwerk -> DHCP Server

Wenn der Host-Only DHCP Server aktiv ist: deaktivieren.
Wenn im DHCP Server Daten hinterlegt sind, diese bitte durch '0.0.0.0' ersetzen (auch wenn man DHCP danach ausschaltet.

Don't ask.

## Initialisieren:

Es werden zwei Vagrant Plugins eingesetzt:

    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-vbguest

Falls die Plugins schon installiert waren, kann man prüfen, ob Aktualisierungen vorliegen:

    vagrant plugin update

Als nächstes brauchen wir einen GIT Client. Je nach OS bitte installieren:

- Debian: sudo apt-get install git
- CentOS: sudo yum install git

Nun das GitHub repository auf die Workstation/das Trainingslaptop installieren:

    git clone https://github.com/example42/foreman-training
    cd foreman-training
    
Jetzt kann die VM instantiiert werden:

    cd vagrant
    vagrant up foreman.example42.training

Danach Login:

    vagrant ssh foreman.example42.training
    sudo -i

Pruefen, ob eth1 Interface eine IP hat, ```ip a```. Wenn nein: ```ifup eth1```

    foreman-installer -i

Am Installer die notwendigen Komponenten auswählen:

    3. [✗] Configure foreman_cli_ansible
    12. [✗] Configure foreman_plugin_ansible
    31. [✗] Configure foreman_plugin_remote_execution
    44. [✗] Configure foreman_proxy_plugin_ansible
    56. [✗] Configure foreman_proxy_plugin_remote_execution_ssh

Dann Punkt 59 - Save und run auswählen.

Achtung:

Wenn hier eine Fehlermeldung kommt: `Forward DNS points to 127.0.1.1 which is not configured on this server`, dann in `/etc/hosts` sicherstellen, dass folgender Eintrag weg kommt `127.0.1.1 foreman.example42.training foreman` und folgender Eintrag hinzugefügt wird: `10.100.10.101 foreman.example42.training foreman`

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

Namensauflösung prüfen: `ping -c1 heise.de`

Evtl in `/etc/named.conf` einen anderen "forwarder" eintragen (8.8.8.8) und named neu starten: `systemctl restart named`.

Weitermachen, wenn die Namensauflösung funktioniert.

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

Foreman Login -> Configure -> Puppet -> Environments -> 'Import environments from foreman.example42.training'

Haken setzen -> Update

### Ansible Roles

    ansible-galaxy collection install ericsysmin.docker -p /etc/ansible/roles
    ansible-galaxy install geerlingguy.apache -p /etc/ansible/roles
    ansible-galaxy install geerlingguy.mysql -p /etc/ansible/roles

Foreman Login -> Configure -> Ansible -> Roles -> 'Import from foreman.example42.training'

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

- Tab Proxies: foreman.example42.training bei DHCP, TFTP, HTTPBoot und Reverse DNS auswaehlen

Submit

Weiter geht es mit Teil 2 [Provisionieren](../02_provisioning)
