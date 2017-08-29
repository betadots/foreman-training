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

Katello Login -> Content -> Sync Status

Repo auswaehlen und sync starten (benoetigt ca. 8 GB Fetsplattenplatz pro OS Version)




