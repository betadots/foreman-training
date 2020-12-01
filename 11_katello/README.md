# Foreman Training - Teil 11 - Katello

ACHTUNG: Katello benoetigt mindestens 8 GB RAM!

Es wird abgeraten katello auf einem existierenden Foreman Setup hinzuzufuegen.

Statt dessen soll katello vor der foreman installation vorbereitet werden:

WICHTIG: Vor der Installation muss die Uhrzeit bereits korrekt gesetzt sein!

## Vorbereitung

alle laufenden Vagrant Boxen loeschen:

    cd vagrant
    vagrant destroy -f

## Katello starten

    vagrant up katello.example42.training
    vagrant ssh katello.example42.training
    sudo -i
    foreman-installer --scenario katello -i

ACHTUNG: wenn es zu Problemen wegen VirtualBox Guest Additions kommt:

    vagrant ssh katello.example42.training
    sudo yum upgrade
    sudo shutdown now
    vagrant halt katello.example42.training
    vagrant up katello.example42.training
    
Katello Dienste konfigurieren:

    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp
    # puppet apply /vagrant_foreman/scripts/04_selinux.pp
    puppet apply /vagrant_foreman/scripts/05_katello_services.pp

Achtng: bei 01_install_service_dhcp können Fehler auftreten.
Diese können ignoriert werden.


# REBOOT !!!!

Katello hat ein Problem, bei der initialen Installation alle Dienste sauber zu starten.

    reboot

Nach reboot die share wieder mounten:

    vagrant ssh katello.example42.training
    sudo -i
    mount -t vboxsf vagrant_foreman /vagrant_foreman

    rm /etc/gateway_config
    puppet apply /vagrant_foreman/scripts/00_router_config.pp

Achtung: /etc/resolv.conf prüfen:

    # /etc/resolv.conf
    domain example42.training
    nameserver 10.100.10.102

## Repository erzeugen

### Yum

1. GPG Key

Katello Login -> Content -> Content Credentials -> Create Content Credential

Name: CentOS7

CentOS GPG Key kopieren vom mirror (http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7)

Save

2. Repository

Katello Login -> Content -> Products -> Repo Discovery

Repository Type: Yum Repositories

URL: http://mirror.centos.org/centos/7 (oder lokaler Mirror)

Click Discover

Das kann einige Zeit dauern (5 min und mehr).

os/x86_64 und updates/x86_64 auswaehlen.

Klick: Create selected

Name: CentOS7

GPG Key: aus Liste auswaehlen

Verify SSL: ?? probieren....

Run Repository Creation

3. Syncen

Katello Login -> Content -> Sync Plans

Create Sync Plan

Name: daily

Interval: daily

Start Date: Datum von heute

Start Time: 1,5 Stunden vorher (UTC time auf System)

Save

Products Tab auswählen.

Add auswählen

CentOS7 auswählen und Klick auf "Add selected"


Katello Login -> Content -> Sync Status

Repo auswaehlen und sync starten (benoetigt ca. 8 GB Festplattenplatz pro OS Version)

4. Intiiales Syncen

Katello Login -> Content -> Products -> CentOS7 -> os x86_64

Download Policy: Immediate

Select Action -> Sync Now


## Docker

Katello Login -> Content -> Products -> Create Product

Name: Fedora

Rest leer lassen

Save

Repository -> New Repository

Name: Fedora SSH

Type: Docker

URL: https://registry.hub.docker.com

Upstream Repository Name: fedora/ssh

Save

## Smart Proxies

Katello Login -> Infrastructure -> Smart Proxies -> Actions -> Pfeil -> Refresh
## DNS

### Domain

Katello Login -> Infrastructure -> Domains -> example42.training

- DNS Proxy: katello.example42.training

Submit

### Subnetz

Katello Login -> Infrastructure -> Subnets -> Create Subnet

- Tab Subnet: Name: example42.training
- Tab Subnet: Network Address: 10.100.10.0
- Tab Subnet: Network prefix: 24
- Tab Subnet: Gateway address: 10.100.10.102
- Tab Subnet: Primary DNS server: 10.100.10.102
- Tab Subnet: IPAM: DHCP
- Tab Subnet: Start IP range: 10.100.10.120
- Tab Subnet: End IP range: 10.100.10.240

- Tab Domain: example42.training
- Tab Proxies: all auswaehlen
- Tab Locations: Default Location auswaehlen


Submit

## lokalen Repo Mirror bekannt machen

Katello Login -> Hosts -> Installation Media -> Create Installation Medium

- Name: CentOS7
- Path: http://katello.example42.training/pulp/repos/Default_Organization/Library/custom/CentOS7/os_x86_64/
- Operating System Family: RedHat

Submit


## Einrichten der Organisation

Bug in altemKatello (< 1.20)

Katello Login -> Default Organization -> Manage Organizations -> Edit Pfeil -> Assign the 1 host with no organization to Default Organization

Default Organization anklicken

Pruefen:

  - Smart Proxies
  - Subnets
  - Media
  - Provisioning Templates
  - Partition Tables
  - Domains
  - Environments
  - Location

Submit

## Provisionierung

Teil 1: Templates an OS binden

  - kind = PXELinux
  - kind = provision
  - kind = finish

Teil 2: OS an Templates binden

- Installation Media
- Templates: entfernen von Katello Kickstart Default User Data

## Host Groups anlegen

Katello Login -> Configure -> Host Groups -> Create Host Group

- Tab Host Group: Name: Katello Hostgroup
- Tab Host Group: Lifecycle Environment: Library
- Tab Host Group: Content View: Default Organization Content View
- Tab Host Group: Content Source: katello.example42.training
- Tab Host Group: Puppet Environment: production
- Tab Host Group: Puppet Master: katello.example42.training
- Tab Host Group: Puppet CA: katello.example42.training

- Tab Network: Domain: example42.training
- Tab Network: IPv4 Subnet: example42.training

- Tab Operatingsystem: Architecture: x86_64
- Tab Operatingsystem: Operating System: CentOS_Linux_7
- Tab Operatingsystem: Media: my reo mirror
- Tab Operatingsystem: Partition Table: Kickstart Default
- Tab Operatingsystem: Root passwort: setzen

- Tab Location: Default Location auswaehlen

Submit



## Host erzeugen in VirtualBox

2 GB RAM !!!

Netzwerk wie katello.

Boot Reihenfolge einstellen

MAC Adresse notieren

## Host in Katello erzeugen

Katello Login -> Hosts -> Create host

- Tab Host: Name: test
- Tab Host: Location: Default Location
- Tab Host: Host Group: Katello Hostgroup

- Tab Interfaces: Edit: MAC adresse eintragen -> OK

Submit

Am Anfang der Webseite steht, welche Aktionen ausgefuehrt werden.


Nach Abschluss VirtualBox Host starten

## Host Collections

Innerhalb von Host Collections werden die folgenden Komponenten n Zusammenhang gesetzt:

- Products (Repositories)
- Nodes

Foreman Login -> Hosts -> Host Collections -> Create Host Collection

Name angeben (Host Collection 1) und den neu angelegten Host hinzufügen.

Für weitere Funktionalität wird eine subscription benötigt und der katello-agent muss installiert werden.

    curl  --insecure --output katello-ca-consumer-latest.noarch.rpm https://katello.example42.training/pub/katello-ca-consumer-latest.noarch.rpm
    yum localinstall katello-ca-consumer-latest.noarch.rpm

    subscription-manager register --org="Default_Organization" --environment="Library"

Wenn das Foreman Client Repo eingebunden ist, kann das katello-agent Paket installiert werden.

Weitere Informationen: https://theforeman.org/plugins/katello/3.14/installation/clients.html#manual


