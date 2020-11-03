# Foreman Training - Teil 2 - Provisionieren

Das Provisionieren besteht aus:
  - Betriebssystem und -version
  - OS Architektur
  - Installations Medium (Repository Server)
  - Provisionierungstemplates

## Provisioning OS

Es koennen meherere OS ausgewaehlt werden.
Das OS mit Version und Architektur der Foreman Instanz ist automatisch hinzugefuegt worden.

## Provisioning Repository Server

Default Repository Server fuer unterschiedliche Betriebssysteme sind bereits standardmaessig angelegt.

## Provisioning Templates

Foreman Login -> Hosts -> Provisioning Templates

Templates unterscheiden sich nach Funktionalitaet:

  - PXELinux, PXEGrub, PXEGrub2 : werden auf den TFTP Server deployed
  - Provision : Kickstart oder Preseed fuer unattended Installation
  - Finish : Post-Install Scripts
  - user_data: Post-Install fuer Cloud VMs
  - Script : generische Skripte
  - iPXE : {g,i}PXE anstelle von PXE


Normalerweise werden nur die ersten 3 benoetigt.

Standard Templates sind "Locked". Niemals Standard Templates editieren, immer Klonen!

Beispiel Suchen: kind=PXELinux

### Provisionierungs Templates mit OS Assoziieren

Foreman Login -> Hosts -> Provisioning Templates

1. Stelle: Templates mit OS Assoziieren

1.a. kind = PXELinux

"Kickstart default PXELinux" auswaehlen -> Association -> OS auswaehlen

1.b. kind = provision

"Kickstart default" auswaehlen -> Association -> OS auswaehlen

1.c. kind = finish

"Kickstart default finish" auswaehlen -> Association -> OS auswaehlen

1.d. PXE bauen

"Build PXE Default"

### Installation media

Wenn man einen eigenen anstelle der CentOS Mirror verwenden moechte:

Foreman Login -> Hosts -> Installation Media -> Create medium

Name eintragen, bei "Path" den http Pfad eintragen.
Achtung: auf Namensaufloesung achten!

Operatingsystem Family angeben!

### OS mit Provisionierungs Templates assoziieren

Foreman Login -> Hosts -> Operating Systems

OS auswaehlen

2. Stelle: OS mit Templates Assoziieren

- Partition Table -> "Kickstart default" auswaehlen
- Installation media -> "CentOS mirror" auswaehlen (oder das vorher angelegten Installation media auswaehlen)
- Templates -> alle Templates auswaehlen, die man auswaehlen kann.

Submit

## Host Group

Wenn man Puppet einsetzen will, brauchen Host Groups das Puppet Environment

Foreman Login -> Configure -> Host Groups -> Create Host Group

Tab Host Group:

- Name: Training
- Environment: Production
- Puppet Master: foreman.example42.training
- Puppet CA: foreman.example42.training

Tab Puppet Classes

keine Klasse auswählen !!

Tab Network

- Domain: example42.training
- IPv4 Subnet: example42.training

Tab Operating System

- Architecture: x86_64
- Operatingsystem: CentOS...
- Media: CentOS Mirror (oder den vorher angelegten auswählen)
- Partition Table: Kickstart
- PXE Loader: PXELinux BIOS
- Root Password: <eines setzen>

Wenn Puppet explizit ausgeschaltet werden soll:

Tab Parameters:

Host Group Parameters: Add Parameter:

enable-puppet: boolean: false

Wenn Puppet 6 aktiviert werden soll:

enable-puppetlabs-puppet6-repo: boolean: true

Submit

## Host erzeugen in VirtualBox:

Hinweis: die Images werden initial in eine RAM Disk geladen. Deshalb benoetigt die VM mindesten 1516 MB RAM.

New -> Host -> 2048 MB RAM -> 8 GB HDD

Boot Einstellungen aendern: 1. Festplatte -> 2. Netzwerk

Netzwerk aendern: gleiches vboxnet, wie foreman.example42.training

MAC Adresse notieren

## Host in Foreman anlegen

Foreman Login -> Hosts -> Create Host

ACHTUNG: nicht docker als hostname nehmen. Dieser Name wird in Teil 4 verwendet.

Host Tab:
- Name: hostname (ohne Domain)
- Hostgroup: Training
- Environment: Production (sollte automatisch aus der Hostgroup rausfallen)

Interfaces Tab:
- Edit
  - Mac Adresse eintragen und OK zum speichern

ACHTUNG: MAC Adresse mit Doppelpunkten eintragen!!! aa:bb:cc:dd:ee

Operating System Tab:

- Operating System: auswaehlen (CentOS Linux 7.3...)
- Media: Mirror waehlen
- Partition Table: Kickstart default
- PXE Loader: PXELinux BIOS

Submit

Es erscheint ein "New in progress" Balken.

## Host in VirtualBox starten

Wenn man alles richtig gemacht hat, bootet die VM via DHCP und fängt die Installation an.

Die Installation kann je nach verwendetem Repository Server einige Zeit dauern.

Weiter geht es mit Teil 3 [Provisionieren von Debian](../03_provisionining_debian)
Oder mit Teil 4 [CfgMgmt](../04_cfgmgmt)
