# Foreman Training
(c) 2017 - example42 GmbH

# Inhalt

Tag 1:

Teil 01 - Installation

Teil 02 - Provisionierung CentOS - GUI und CLI - gemeinsam

Teil 03 - Provisionierung Debian - selbstaendig

Teil 04 - Konfigurations Management - CLI?

Teil 05 - Deprovisionierung - CLI?

Tag 2:

Teil 06 - Verwalten bestehender Systeme

Teil 07 - Compute Resources - Docker und Cloud

Teil 08 - Plugins

Teil 09 - RBAC und Self Service

Optionale Erweiterungen:

Teil 11 - Katello

Teil 12 - Integration in bestehende Infrastruktur

Teil 13 - Backup und Recovery

# Vorbereitung:

[Vagrant](https://www.vagrantup.com/) installieren und CentOS 7 image lokal ablegen:

    vagrant box add centos/7

    ==> box: Loading metadata for box 'centos/7'
        box: URL: https://vagrantcloud.com/centos/7
    This box can work with multiple providers! The providers that it
    can work with are listed below. Please review the list and choose
    the provider you will be working with.
    
    1) hyperv
    2) libvirt
    3) virtualbox
    4) vmware_desktop

    Enter your choice: 3
    ==> box: Adding box 'centos/7' (v1905.1) for provider: virtualbox
        box: Downloading: https://vagrantcloud.com/centos/boxes/7/versions/1905.1/providers/virtualbox.box
        box: Download redirected to host: cloud.centos.org
    ==> box: Successfully added box 'centos/7' (v1905.1) for 'virtualbox'!

ACHTUNG: wenn die VirtualBox Erweiterungen noch nicht geladen wurden, dann muss nach dem Anlegen der foreman VM der DHCP Server am Host-only networking deaktiviert und das Linux System neu gebootet werden.

Ansonsten erkennt VirtualBox nicht die Änderung am host-only Networking.

Weiter geht es mit Teil1: [Installation](01_installation)

# License
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License

# Contributing
Contributing to this repository is possible as long as the original author is always referenced.


