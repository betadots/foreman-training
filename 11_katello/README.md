# Foreman Training - Teil 11 - Katello

ACHTUNG: Katello benoetigt mindestens 8 GB RAM!

Es wird abgeraten katello auf einem existierenden Foreman Setup hinzuzufuegen.

Statt dessen soll katello vor der foreman installation vorbereitet werden:

WICHTIG: Vor der Installation muss die Uhrzeit bereits korrekt gesetzt sein!

## Vorbereitung

alle laufenden Vagrant Boxen loeschen:

    cd vagrant
    vagrant destroy -f

## Katello VM starten

    vagrant up katello.example42.training

Durch Änderungen an den Repositories (die Kernel liegen jetzt auf Vault) wird man eine Fehlermeldung bekommen:

    ==> katello.example42.training: Checking for guest additions in VM...
        katello.example42.training: No guest additions were detected on the base box for this VM! Guest
        katello.example42.training: additions are required for forwarded ports, shared folders, host only
        katello.example42.training: networking, and more. If SSH fails on this machine, please install
        katello.example42.training: the guest additions and repackage the box to continue.
        katello.example42.training:
        katello.example42.training: This is not an error message; everything may continue to work properly,
        katello.example42.training: in which case you may ignore this message.

In diesem Fall muss man manuell ein Update der VM durchführen:

    vagrant ssh katello.example42.training
    sudo yum update -y
    exit

Nun muss der Provisionierungsprozess neu gestartet werden:

    vagrant reload --provision katello.example42.training


## Einloggen und Installation

    vagrant ssh katello.example42.training
    sudo -i
    foreman-installer --scenario katello -i

Achtung:

Wenn hier eine Fehlermeldung kommt: `Forward DNS points to 127.0.1.1 which is not configured on this server`, dann in `/etc/hosts` sicherstellen, dass folgender Eintrag weg kommt `127.0.1.1 katello.example42.training katello` und folgender Eintrag hinzugefügt wird: `10.100.10.102 katello.example42.training katello`

Achtung 2:

Wenn eine Fehlermldung kommt invalid byte sequence in US-ASCII (ArgumentError), dann muss die Locale gesetzt werden: `export LANG=en_US.UTF-8`

Im Foreman Installer können einige Optionen direkt bei der Installation ausgewaehlt werden:

    4. [✓] Configure foreman\_cli\_ansible
    9. [✓] Configure foreman\_cli\_remote\_execution
    10. [✓] Configure foreman\_cli\_tasks
    19. [✓] Configure foreman\_plugin\_ansible
    35. [✓] Configure foreman\_plugin\_remote\_execution
    42. [✓] Configure foreman\_plugin\_tasks
    47. [✓] Configure foreman\_proxy\_plugin\_ansible
    56. [✓] Configure foreman\_proxy\_plugin\_remote\_execution\_ssh

Nun Punkt `61 Save and run` auswaehlen.

Die Installation dauert.
Nach einiger Zeit kommt eine Abschlussmeldung:

      Success!
      * Foreman is running at https://katello.example42.training
          Initial credentials are admin / sTExyUd2ThWVKWJP
      * To install an additional Foreman proxy on separate machine continue by running:

          foreman-proxy-certs-generate --foreman-proxy-fqdn "$FOREMAN_PROXY" --certs-tar "/root/$FOREMAN_PROXY-certs.tar"
      * Foreman Proxy is running at https://katello.example42.training:9090
      The full log is at /var/log/foreman-installer/katello.log

## Katello Dienste konfigurieren:

    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp
    # puppet apply /vagrant_foreman/scripts/04_selinux.pp
    puppet apply /vagrant_foreman/scripts/05_katello_services.pp
    puppet apply /vagrant_foreman/scripts/06_tftp.pp

Achtung: bei 01\_install\_service\_dhcp können Fehler auftreten.
Diese können ignoriert werden.

Als nächstes muss die Namensauflösung geprüft werden: `ping -c1 heise.de`

Wenn das Kommando keine IP zurückliefert, muss in `/etc/named.conf` der Forwarder Eintrag geprüft und passend gesetzt werden.

z.B.

    options {
      listen-on port 53 { any; };
      directory       "/var/named";
      allow-query     { any; };
      dnssec-enable   no;
      forwarders      { 8.8.8.8; };	<- Anpassen z.B. auf Google DNS Server
    };
    ...

Nach der Änderung an `/etc/named.conf`muss der DNS Service neu gestartet werden: `sysctl restart named`

## Login in Katello

Im Browser:

    https://katello.example42.training

## Repository erzeugen

### Yum

#### GPG Key einbinden

Katello Login -> Content -> Content Credentials -> Create Content Credential

Name: CentOS7

CentOS GPG Key kopieren vom mirror (http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7)

Save

Wiederholen fuer PostgreSQL GPG Key mit https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG-11

#### Repository anlegen

ACHTUNG: Das Anlegen von lokalen Repositories benoetigt viel Plattenplatz und viel Bandbreite.
Diese Schritte sollten nur gemacht werden, wenn man:

- eine schnelle Internetanbindung hat (min 50 MBit)
- genug Plattenplatz verfuegbar ist (min 20 GB)

#### Repository anlegen - klein (1 GB - Dauer: ca 5-10 Minuten)

Katello Login -> Content -> Products -> Repo Discovery

Repository Type: Yum Repositories

URL: https://yum.theforeman.org/client/2.3

Click Discover

`/el-7/x86_64` auswaehlen

#### Repository anlegen - gross (20 GB - Dauer: ca 1 Stunde)

Katello Login -> Content -> Products -> Repo Discovery

Repository Type: Yum Repositories

URL: http://mirror.centos.org/centos/7 (oder lokaler Mirror)

Click Discover

Das kann einige Zeit dauern (5 min und mehr).
Katello holt sich dabei die Metainformationen der gesamten CentOS 7 Repositories.

`os/x86_64` und `updates/x86_64` auswaehlen.

Klick: Create selected

Name: CentOS7

GPG Key: aus Liste auswaehlen

Verify SSL: nur aktivieren, wenn man eine eigen CA verwendet. Ansonsten muss die Self-signed CA und das Katello HTTPS Zertifikat allen Systemen bekannt gemacht werden.

Run Repository Creation

### Debian

Debian Repositories werden anders behandet.
Hier muss zuerst ein Produkt und beim Repository eine URL angegeben werden.

Zusätzlich muss die Distribution und Komponente sowie Architektur angegeben werden.

Content -> Producst -> Create Product

Name angeben -> Save

In der Uebersicht: "New Repository" auswaehlen.

Bei "Type" `deb` auswaehlen und die Repo Informationen eintragen:

Upstream URL: http://ftp.de.debian.org

Release: stable/unstable/buster, ...

Componentes: main, free, non-free, ...

Architectures: amd64, arm, i386, ...


### Repositories Syncen

Katello Login -> Content -> Sync Plans

Create Sync Plan

Name: daily

Interval: daily

Start Date: Datum von heute

Start Time: 1,5 Stunden vorher (UTC time auf System)

Save

Products Tab auswählen.

Add auswählen

CentOS7 auswählen und Klick auf "Add selected"


Katello Login -> Content -> Sync Status

`os x86_64` repo auswaehlen und sync starten (benoetigt temporaer waehrend des syncs ca. 20 GB und danach ca 11GB Festplattenplatz pro OS Version)

Achtung: Sync kann bis zu 1h dauern! Die Dauer haengt von der Bandbreite des Internetzugangs ab.

`updates x86_64`benötigt ca 8 GB RAM waehrend des Syncs und 5 GB danach. Dauer des Sync ca 30 min.

#### Initiales Syncen

Katello Login -> Content -> Products -> CentOS7 -> os x86\_64

Download Policy: Immediate

Select Action -> Sync Now

## Content Views

Mit content views koennen verschiedene Konstellationen und Versionen von Repos verwaltet werden.

z.B. Basis OS Repo + Monitoring + eigenes Repo

Katello Login -> Content -> Content Views

Content Views koennen versioniert werden und man kann neue Versionen ueber das Webinterface erzeugen.

## Lifecycle Environments

Mit Lifecycle Environments verwaltet man Content Views (hinzufuegen, promoten, entfernen).
Das Default Lifecycle Environment nennt sich Library. Innerhalb dieser Library koennen weitere Environments angeegt werden.

z.B. Production, Testing, Pre-Prod

Ueber die Content Views kann man nun Content an ein Lifecycle Environment "promoten".

## Alles zusammen bringen

Wenn man einen Host oder eine Hostegruppe anlegt, kann man das Liefecycle Environment mit angeben.
Damit kann man festlegen, welche Hosts oder Hostgruppen, welche Repositories zugeweisen bekommen sollen.

## Content Hosts

Katello Login -> Hosts -> Content Hosts

Hier wird bei "Subscription Status" ein Rotes Kreuz stehen.

Auf dem Katello Server (als Root User):

    curl --insecure --output katello-ca-consumer-latest.noarch.rpm https://katello.example42.training/pub/katello-ca-consumer-latest.noarch.rpm
    yum localinstall katello-ca-consumer-latest.noarch.rpm
    subscription-manager register --org="Default_Organization" --activationkey="Productoin Activation Key"
    yum install -y katello-agent

ACHTUNG: in Katello 4 wird von katello-agent auf Remote Execution gewechselt!!

## Docker (optional)

Katello Login -> Content -> Products -> Create Product

Name: Fedora

Rest leer lassen

Save

Repository -> New Repository

Name: Fedora SSH

Type: Docker

URL: https://registry.hub.docker.com

Upstream Repository Name: fedora/ssh

Save

# Nun geht es mit dem Foreman Teil weiter:

## Smart Proxies

Katello Login -> Infrastructure -> Smart Proxies -> Actions -> Pfeil -> Refresh

## DNS

### Domain

Katello Login -> Infrastructure -> Domains -> example42.training

- DNS Proxy: katello.example42.training

Submit

### Subnetz

Katello Login -> Infrastructure -> Subnets -> Create Subnet

- Tab Subnet: Name: example42.training
- Tab Subnet: Network Address: 10.100.10.0
- Tab Subnet: Network prefix: 24
- Tab Subnet: Gateway address: 10.100.10.102
- Tab Subnet: Primary DNS server: 10.100.10.102
- Tab Subnet: IPAM: DHCP
- Tab Subnet: Start IP range: 10.100.10.120
- Tab Subnet: End IP range: 10.100.10.240

- Tab Remote Execution: den Proxy auswaehlen

- Tab Domain: example42.training
- Tab Proxies: all auswaehlen
- Tab Locations: Default Location auswaehlen


Submit

## lokalen Repo Mirror bekannt machen

Katello Login -> Hosts -> Installation Media -> Create Installation Medium

- Name: CentOS Katello
- Path: http://katello.example42.training/pulp/repos/Default_Organization/Library/custom/CentOS7/os_x86_64/
- Operating System Family: RedHat

Submit


## Einrichten der Organisation

Bug in altem Katello (< 1.20)

Katello Login -> Default Organization -> Manage Organizations -> Edit Pfeil -> Assign the 1 host with no organization to Default Organization

Default Organization anklicken

Pruefen:

  - Smart Proxies
  - Subnets
  - Media
  - Provisioning Templates
  - Partition Tables
  - Domains
  - Environments
  - Location

Submit

## Provisionierung

Katello Login -> Hosts -> Provisioning Templates

Teil 1: Templates an OS binden

  - kind = PXELinux -> Kickstart default PXELinux -> Association pruefen
  - kind = provision -> Kickstart Default -> Association pruefen
  - kind = finish -> Kickstart Default finish -> Association pruefen

Katello Login -> Hosts -> Operating System

Teil 2: OS an Templates binden

- Installation Media -> CentOS Katello hinzufuegen

## Host Groups anlegen

Katello Login -> Configure -> Host Groups -> Create Host Group

- Tab Host Group: Name: Katello Hostgroup
- Tab Host Group: Lifecycle Environment: Production
- Tab Host Group: Content View: Base OS + Monitoring
- Tab Host Group: Content Source: katello.example42.training
- Tab Host Group: Puppet Environment: production (optional)
- Tab Host Group: Puppet Master: katello.example42.training (optional)
- Tab Host Group: Puppet CA: katello.example42.training (optional)

- Tab Ansible Roles: (optional)
- Tab Puppet Classes: (optional)

- Tab Network: Domain: example42.training
- Tab Network: IPv4 Subnet: example42.training

Katello Bug!!!! Erst "All media" auswaehlen und speichern, danach kann man auf "Synced COntent" wechseln!!!
- Tab Operatingsystem: Architecture: x86_64
- Tab Operatingsystem: Operating System: CentOS-7
- Tab Operatingsystem: Media Selection: All Media
- Tab Operatingsystem: Synced Content: CentOS Katello
- Tab Operatingsystem: Partition Table: Kickstart Default
- Tab Operatingsystem: PXE Loader: PXELinux BIOS
- Tab Operatingsystem: Root passwort: setzen

- Tab Location: Default Location auswaehlen

Submit
i
Hostgruppe auswaehlen und im Tab Operatingsystem Media Selection auf "Synced Content" und Synced Content auf "os_x86_64" aendern.


## Host erzeugen in VirtualBox

2 GB RAM !!!

Netzwerk wie katello.

Boot Reihenfolge einstellen

MAC Adresse notieren

## Host in Katello erzeugen

Katello Login -> Hosts -> Create host

- Tab Host: Name: test
- Tab Host: Location: Default Location
- Tab Host: Host Group: Katello Hostgroup

- Tab Interfaces: Edit: MAC adresse eintragen -> OK

Submit

Am Anfang der Webseite steht, welche Aktionen ausgefuehrt werden.


Nach Abschluss VirtualBox Host starten

## Host Collections

Innerhalb von Host Collections werden die folgenden Komponenten in Zusammenhang gesetzt:

- Products (Repositories)
- Nodes

Foreman Login -> Hosts -> Host Collections -> Create Host Collection

Name angeben (Host Collection 1) und den neu angelegten Host hinzufügen.

Für weitere Funktionalität wird eine subscription benötigt und der katello-agent muss installiert werden.

    curl  --insecure --output katello-ca-consumer-latest.noarch.rpm https://katello.example42.training/pub/katello-ca-consumer-latest.noarch.rpm
    yum localinstall katello-ca-consumer-latest.noarch.rpm

    subscription-manager register --org="Default_Organization" --environment="Library"

Wenn das Foreman Client Repo eingebunden ist, kann das katello-agent Paket installiert werden.

Weitere Informationen: https://theforeman.org/plugins/katello/3.14/installation/clients.html#manual


