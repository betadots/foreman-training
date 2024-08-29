# Foreman Training - Teil 4 - Provisionieren CentOS

Das Provisionieren besteht aus:

- Betriebssystem und -version
- OS Architektur
- Installations Medium (Repository Server)
- Provisionierungstemplates

Zusätzlich lassen wir mit Foreman die Vergabe von IP Adressen (DHCP) und die Namensauflösung (DNS) verwalten.

## Domain

    Foreman Login
      -> Infrastructure
        -> Domains
          -> 'betadots.training'

- Tab Domain: DNS domain: `betadots.training`
- Tab Domain: DNS Proxy: `foreman.betadots.training`

Submit

## Netzwerk

    Foreman Login
      -> Infrastructure
        -> Subnets
          -> Create Subnet

- Tab Subnet: Name: `betadots.training`
- Tab Subnet: Network Address: `10.100.10.0`
- Tab Subnet: Network Prefix: `24`
- Tab Subnet: Gateway Address: `10.100.10.101`
- Tab Subnet: Primary DNS Server: `10.100.10.101`
- Tab Subnet: IPAM: `DHCP`
- Tab Subnet: Start of IP Range: `10.100.10.120`
- Tab Subnet: End of IP Range: `10.100.10.240`

- Tab Domains: `betadots.training` auswählen

- Tab Proxies: `foreman.betadots.training` bei DHCP, TFTP, HTTPBoot und Reverse DNS auswählen

Submit

## Provisioning OS

Es können meherere OS ausgewählt werden.
Das OS mit Version und Architektur der Foreman Instanz ist automatisch hinzugefügt worden.

## Provisioning Repository Server

Default Repository Server für unterschiedliche Betriebssysteme sind bereits standardmässig angelegt.
Hier eventuell die Lifecycle Environment Repositories auswählen.

## Provisioning Templates

    Foreman Login
      -> Hosts
        -> Provisioning Templates

Templates unterscheiden sich nach Funktionalität:

- PXELinux, PXEGrub, PXEGrub2 : werden auf den TFTP Server deployed
- Provision : Kickstart oder Preseed für unattended Installation
- Finish : Post-Install Scripts
- user_data: Post-Install für Cloud VMs
- Script : generische Skripte
- iPXE : {g,i}PXE anstelle von PXE

Normalerweise werden nur die ersten 3 benötigt.

Standard Templates sind "Locked". Niemals Standard Templates editieren, immer Klonen!

Beispiel Suchen: kind=PXELinux

### Provisionierungs Templates mit OS Assoziieren

    Foreman Login
      -> Hosts
        -> Provisioning Templates

1. Stelle: Templates mit OS Assoziieren

1.a. kind = PXELinux

"Kickstart default PXELinux" auswählen -> Association -> OS auswählen

1.b. kind = provision

"Kickstart default" auswählen -> Association -> OS auswählen

1.c. kind = finish

"Kickstart default finish" auswählen -> Association -> OS auswählen

1.d. PXE bauen

"Build PXE Default"

### Installation media

Wenn man einen eigenen anstelle der CentOS Mirror verwenden möchte:

    Foreman Login
      -> Hosts
        -> Installation Media
          -> Create medium

Name eintragen, bei "Path" den http Pfad eintragen.
Achtung: auf Namensauflösung achten!

Wichtig: im Linuxhotel bitte unbedingt den Mirror verwenden: path: `http://centos.linuxhotel.de/8/os/x86_64`

Operatingsystem Family angeben!

#### lokalen Repo Mirror bekannt machen (nur wenn man das CentOS Repository als Content erzeugt hat.)

    Katello Login
      -> Hosts
        -> Installation Media
          -> Create Installation Medium

- Name: CentOS Katello
- Path: `http://foreman.betadots.training/pulp/repos/Default_Organization/Library/custom/CentOS8/os_x86_64/`
- Operating System Family: RedHat

Submit

### OS mit Provisionierungs Templates assoziieren

    Foreman Login
      -> Hosts
        -> Operating Systems

OS auswählen

2. Stelle: OS mit Templates Assoziieren

- Partition Table -> "Kickstart default" auswählen
- Installation media -> "CentOS 8 stream mirror" auswählen (oder das vorher angelegten Installation media auswählen)
- Templates -> alle Templates auswählen, die man auswählen kann.

Submit

## Host Group

Wenn man Puppet einsetzen will, brauchen Host Groups das Puppet Environment

    Foreman Login
      -> Configure
        -> Host Groups
          -> Create Host Group

Tab Host Group:

- Name: Hostgruppe auswählen

Die folgenden Einträge werden nur bei der Verwendung von Puppet benötigt:

- Environment: `production`
- Puppet Proxy: `foreman.betadots.training`
- Puppet CA Proxy: `foreman.betadots.training`

Tab Puppet Classes

keine Klasse auswählen !!

Tab Network

- Domain: `betadots.training`
- IPv4 Subnet: `betadots.training`

Tab Operating System

- Architecture: `x86_64`
- Operatingsystem: `CentOS...`
- Media: `CentOS Mirror` (oder den vorher angelegten auswählen)
- Partition Table: `Kickstart`
- PXE Loader: `PXELinux BIOS`
- Root Password: `eines setzen`

Puppe tmuss explizit aktiviert werden (ab Foreman 3.10):

Tab Parameters:
  Host Group Parameters:
    Add Parameter:

    enable-puppet: boolean: true

Wenn die PuppetLabs Puppet 7 Repositories genutzt werden sollen::

    enable-puppetlabs-puppet7-repo: boolean: true

Submit

## Host erzeugen in VirtualBox

Hinweis: die Images werden initial in eine RAM Disk geladen. Deshalb benötigt die VM mindesten 2500 MB RAM (CentOS 8 Stream, Stand Juni 2023).

    New
      -> Host
        -> 2548 MB RAM
          -> 8 GB HDD

Boot Einstellungen ändern: 1. Festplatte -> 2. Netzwerk

Netzwerk ändern: gleiches vboxnet, wie foreman.betadots.training

MAC Adresse notieren

### ACHTUNG

Nach dem Anlegen der VM in Virtual Box unbedingt den Status des VirtualBox-internen DHCP Servers prüfen! Dieser muss deaktiviert sein. Die in der VirtualBox UI angegebene IP Adresse ist egal.

## Host in Foreman anlegen

    Foreman Login
      -> Hosts
        -> Create Host

Host Tab:

- Name: `hostname` (ohne Domain)
- Hostgroup: `Training`

Die folgende Einstellung ist nur vorhanden, wenn man in der Hostgruppe Puppet aktiviert hat.

- Environment: `production` (sollte automatisch aus der Hostgroup rausfallen)

Interfaces Tab:

- Edit
  - Mac Adresse eintragen und OK zum speichern

ACHTUNG vor Foreman 3.10: MAC Adresse mit Doppelpunkten eintragen!!! aa:bb:cc:dd:ee

Operating System Tab:

- Operating System: auswählen (CentOS Linux 9 Streams...)
- Media: Mirror wählen
- Partition Table: Kickstart default
- PXE Loader: PXELinux BIOS

Submit

Es erscheint ein "New in progress" Balken.

Bevor die VM gestartet wird, bitte unbedingt prüfen, ob die Router Konfiguration noch aktiv ist:

    iptables -L -n -t nat

## Host in VirtualBox starten

Achtung: bitte mit dem Starten der VM etwas warten. (ca 5 min!!!!!!!)

Foreman muss im Hintergrund die Images für den TFTP Server herunterladen!!!
Das kann mit VirtualBox einige Zeit dauern....

Wenn man alles richtig gemacht hat, bootet die VM via DHCP und fängt die Installation an.
Wenn man timeout oder not found Fehler bekommt, hat man nicht lange genug gewartet.

Die Installation kann je nach verwendetem Repository Server einige Zeit dauern.

Zur Überprüfung der Installation kann man dann von der Foreman Instanz aus via SSH auf den neu erzeugten Host zugreifen:

    ssh <name> -l root
    yum install -y net-tools
    netstat -rn
    cat /etc/resolv.conf
    ping -c1 heise.de

Weiter geht es mit Teil 5 [Provisionieren von Debian](../05_provisionining_debian)
Oder mit Teil 6 [Deprovisionieren](../06_deprovisioning)
