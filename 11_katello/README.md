# Katello

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

Katello Dienste konfigurieren:

    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp
    puppet apply /vagrant_foreman/scripts/04_selinux.pp
    puppet apply /vagrant_foreman/scripts/05_katello_services.pp


# REBOOT !!!!

Katello hat ein Problem, bei der initialen Installation alle Dienste sauber zu starten.

    reboot

Nach reboot die share wieder mounten:

    sudo -i

    mount -t vboxsf vagrant_foreman /vagrant_foreman

    rm /etc/network_config
    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/06_katello_reboot.pp

## Repository erzeugen

### Yum

1. GPG Key

Katello Login -> Content -> GPG Keys

Default Organization auswaehlen -> Create GPG Key

Name: CentOS7

CentOS GPG Key kopieren vom mirror (http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7)

2. Repository

Katello Login -> Content -> Products -> Repo Discovery

Repository Type: Yum Repositories

URL: http://mirror.centos.org/centos/7 (oder lokaler Mirror)

Click Discover

os/x86_64 auswaehlen.

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

Katello Login -> Infrastructure -> Domains -> Create Domain

- Tab Domain: DNS domain: provision.example42.training
- DNS Proxy: katello.example42.training

Submit

### Subnetz

Katello Login -> Infrastructure -> Subnets -> Create Subnet

- Tab Subnet: Name: provision.example42.training
- Tab Subnet: Network Address: 10.100.10.0
- Tab Subnet: Network prefix: 24
- Tab Subnet: Gateway address: 10.100.10.102
- Tab Subnet: Primary DNS server: 10.100.10.102
- Tab Subnet: IPAM: DHCP
- Tab Subnet: Start IP range: 10.100.10.120
- Tab Subnet: End IP range: 10.100.10.240

Submit

## lokalen Repo Mirror bekannt machen

Katello Login -> Hosts -> Installation Media -> Create Installation Medium

- Name: CentOS7
- Path: http://katello.example42.training/pulp/repos/Default_Organization/Library/custom/CentOS7/os_x86_64/
- Operating System Family: RedHat

Submit


## Einrichten der Organisation

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

- Tab Network: Domain: provision.example42.training
- Tab Network: IPv4 Subnet: provision.example42.training

- Tab Operatingsystem: Architecture: x86_64
- Tab Operatingsystem: Operating System: CentOS_Linux_7
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

Safemode_render????

Nach Abschluss VirtualBox Host starten

