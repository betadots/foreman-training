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


## Repository erzeugen

### Yum

Katello Login -> Content -> GPG Keys

CentOS GPG Key kopieren vom mirror (http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7)

Katello Login -> Content -> Products -> Repo Discovery

yum + URL ausfuellen

Click Discover

os/x86_64 auswaehlen.

Daten ausfuellen

Katello Login -> Content -> Sync Status

Repo auswaehlen und sync starten (benoetigt ca. 8 GB Fetsplattenplatz pro OS Version)




