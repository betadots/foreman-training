
# Foreman/Katello Training

(c) 2022-2023 - betadots GmbH

## Versionen

Das Training basiert auf Foreman 3.4 und Katello 4.6.

Diese Versionskombination ist nur mit EL8 kompatibel.

Die aktuelle Versionen (Stand 03/2023) sind: Foreman 3.5 Katello 4.7

## Hard- und Software Anforderungen

Im Rahmen dieses Trainings werden VM's gestartet. Fuer diese muss genug RAM und CPU und Festplatte vorhanden sein.

Minimale Anforderungen:

- min 4 CPU Cores
- min 16 GB RAM
- min 70 GB freien Festplattenplatz

Als Host-Betriebssystem koennen Mac OS, Linux oder Windows eingesetzt werden.

Es werden die folgenden Softwarekomponenten genutzt:

- VirtualBox
- vagrant
- git

## Inhalt

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

09 - Hammer CLI/API

10 - Wartung - Backup, Restore, Update

11 - Mandaten, Lokationen, User, Gruppen

12 - Plugins

## Trainings Unterlagen holen

Zuerst brauchen wir einen GIT Client. Mit `which git` oder `git --version` prüfen, ob GIT installiert ist.

Wenn nicht: Je nach OS bitte installieren:

- Debian: `sudo apt-get install git`
- CentOS: `sudo yum install git`
- SuSE: `sudo zypper in git-core`
- Windows: `choco install git` # <- Erfordert [Chocolatey](https://chocolatey.org/)

Nun das GitHub Repository auf die Workstation/das Trainingslaptop herunterladen:

    git clone https://github.com/betadots/foreman-training
    cd foreman-training

Weiter geht es mit Teil1: [Installation](01_installation)

# License

Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License

# Contributing

Contributing to this repository is possible as long as the original author is always referenced.
