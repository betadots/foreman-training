# Foreman Training - Teil 3 - Provisionieren Debian

TFTP images werden von folgender URL heruntergeladen:
<http://ftp.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/>

Der Host wird anhand des Mirrors gesetzt.
Bei lokalen Mirrorn unbedingt beachten, dass die Installer Images mit gemirrort werden.

## OS anlegen

    Foreman Login
      -> Hosts
        -> Operating System
          -> Create Operating System

Tab Operating System -> Name: Debian

Tab Operating System -> Major: 12

Tab Operating System -> Minor: 6

Tab Operating System -> Release Name: bookworm

Tab Operating System -> Description: Debian 12.6

Tab Operating System -> Architecture: x86_64

Tab Partition Table -> Preseed Default

Tab Installation Media -> Debian Mirror

Achtung: Templates können erst nach dem nächsten Schritt ausgewählt werden!

Submit

### Provisionierungs Templates mit OS Assoziieren

    Foreman Login
      -> Hosts
        -> Provisioning Templates

1. Stelle: Templates mit OS Assoziieren

1.a. kind = PXELinux

"Preseed default PXELinux" auswählen -> Association -> OS auswählen

1.b. kind = provision

"Preseed default" auswählen -> Association -> OS auswählen

1.c. kind = finish

"Preseed default finish" auswählen -> Association -> OS auswählen

1.d. PXE bauen

"Build PXE Default"

### Installation media

Wenn man einen eigenen anstelle der Debian Mirror verwenden möchte:

    Foreman Login
      -> Hosts
        -> Installation Media
          -> Create medium

Name eintragen, bei "Path" den http Pfad eintragen.
Achtung: auf Namensauflösung achten!

Operatingsystem Family angeben!

Wenn man ein Lifecycle Environment nutzen möchte, kann man dies hier auswählen.

### OS mit Provisionierungs Templates assoziieren

    Foreman Login
      -> Hosts
        -> Operating Systems

OS auswaehlen

2. Stelle: OS mit Templates Assoziieren

- Partiäon Table -> "Preseed default" auswaehlen
- Installation media -> "Debian mirror" auswählen (oder das vorher angelegten Installation media auswählen)
- Templates -> alle Templates auswählen, die man auswählen kann.

Submit

## Host erzeugen in VirtualBox

Hinweis: die Images werden initial in eine RAM Disk geladen. Deshalb benötigt die VM mindesten 1516 MB RAM.

New -> Host -> 2048 MB RAM -> 8 GB HDD

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

- Name: hostname (ohne Domain)
- Hostgroup: Provision from foreman
- Environment: Production (sollte automatisch aus der Hostgroup rausfallen)

Interfaces Tab:

- Edit
  - Mac Adresse eintragen und OK zum speichern

Operating System Tab:

- Operating System: auswählen (Debian 11.5...)
- Media: Mirror waehlen
- Partition Table: Preeseed default
- PXE Loader: PXELinux BIOS

Submit

## Host in VirtualBox starten

Weiter mit Teil 6 [Deprovisionieren](../06_deprovisioning)
