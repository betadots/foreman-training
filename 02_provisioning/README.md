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

"Kickstart default PXELinux" auswaehlen -> Association -> OS auswaehlen

"Kickstart default" auswaehlen -> Association -> OS auswaehlen

"Kickstart default finish" auswaehlen -> Association -> OS auswaehlen

"Build PXE Default"

Foreman Login -> Hosts -> Operating Systems

2. Stelle: OS mit Templates Assoziieren

Partition Table -> "Kickstart default" auswaehlen
Installation media -> "CentOS mirror" auswaehlen
Templates -> alle Templates auswaehlen

Submit

ACHTUNG: beim Verwenden der default templates muss safemode : false gesetzt werden.
Foreman Login -> Administrator -> Settings


## Provisionieren

Foreman Login -> Infrastructure -> Provisioning Setup

Pre-requisites: Provisioning Network: 10.100.10.101/24 -> Submit
Network config: -> Submit (Bei Fehler das Netzwerk umbenennen)
Foreman Installer: 'Install provisioning with DHCP' -> Kopieren und Ausfuehren -> Next
Installation Media: 'CentOS mirror' -> Submit

ACHTUNG: nach dem foreman installer Kommando unbedingt die /etc/named/options.conf forwarders pruefen!!

### Host Group

Host Group braucht das Puppet Environment

Foreman Login -> Configure -> Host Groups
"Provision from foreman.example42.training" auswaehlen
Host Group: Puppet Environment setzen (Production)
Operating System: PXE Loader auswaehlen (PXELinux BIOS)

Submit

