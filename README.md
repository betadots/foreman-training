
# Foreman/Katello Training

(c) 2021 - example42 GmbH
(c) 2021 - betadots GmbH

# Hard- und Software Anforderungen

Im Rahmen dieses Trainings werden VM's gestartet. Fuer diese muss genug RAM und CPU und Festplatte vorhanden sein.

Minimale Anforderungen:

- min 4 CPU Cores
- min 16 GB RAM
- min 50 GB freien Festplattenplatz

Als Betriebssystem koennen Mac OS oder Linux eingesetzt werden. Mit Windows wurde das Training noch nicht getestet.

Es werden die folgenden Softwarekomponenten genutzt:

- VirtualBox
- vagrant
- git

# Inhalt

Tag 1:

01 - Installation

02 - Content - Pakete, Repositories, Versionierung

Tag 2:

03 - Konfigurations Management - Puppet/Ansible

04 - Provisionierung CentOS

05 - Provisionierung Debian

06 - Deprovisionierung

07 - Compute Resources - Container, Cloud, VM

Tag 3:

08 - Verwalten bestehender Systeme

09 - Hammer CLI

10 - Wartung - Backup, Restore, Update

11 - Mandaten, Lokationen, User, Gruppen

12 - Plugins

# Trainings Unterlagen holen

Zuerst brauchen wir einen GIT Client. Mit `which git` oder `git --version` prüfen, ob GIT installiert ist.

Wenn nicht: Je nach OS bitte installieren:

- Debian: `sudo apt-get install git`
- CentOS: `sudo yum install git`

Nun das GitHub repository auf die Workstation/das Trainingslaptop herunterladen:

    git clone https://github.com/tuxmea/foreman-training
    cd foreman-training

Weiter geht es mit Teil1: [Installation](01_installation)

# License

Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License

# Contributing

Contributing to this repository is possible as long as the original author is always referenced.
