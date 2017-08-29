# Katello

ACHTUNG: Katello benoetigt mindestens 8 GB RAM!

Es wird abgeraten katello auf einem existierenden Foreman Setup hinzuzufuegen.

Statt dessen soll katello vor der foreman installation vorbereitet werden:

WICHTIG: Vor der Installation muss die Uhrzeit bereits korrekt gesetzt sein!

Alternativ kann man vor der Installation das Answer File bearbeiten:
/etc/foreman-installer/scenarios.d/katello-answers.yaml

1. Vagrant

    vagrant up katello.example42.training

Moegliche Tasks:
 - Repository fuer CentOS 7.2 und 7.3
 - Nodes fuer upgrade


# Repository erzeugen

## Yum

Katello Login -> Content -> GPG Keys

Key kopieren vom mirror

Katello Login -> Content -> Products -> Repo Discovery

yum + URL

Daten ausfuellen

Katello Login -> Content -> Sync Status

Repo auswaehlen und sync starten (benoetigt ca. 8 GB Fetsplattenplatz pro OS Version)

## Docker Registry

Katello Login -> Content -> Products -> 



