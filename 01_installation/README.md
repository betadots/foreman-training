# Foreman Training - Teil 1 - Installation

## Vagrant Installation

Bitte eine aktuelle Version von Vagrant installieren: https://www.vagrantup.com/downloads
Achtung: wenn Vagrant schon installiert ist, dann unbedingt pruefen, ob die Version aktuell ist!

Debian: deb Paket runterladen und installieren: `sudo dpkg -i ~/Downloads/vagrant*.deb`
CentOS: RPM Paket herunterladen und installieren: `sudo rpm-ihv ~/Downloads/vagrant*.rpm`

Falls Vargant vorher schon installiert war, muss man die Plugins reaktivieren: `vagrant plugin expunge --reinstall`

## Vagrant Erweiterungen:

Es werden zwei Vagrant Plugins eingesetzt:

- vagrant-hostmanager
- vagrant-vbguest

Das Hostmanager Plugin erzeugt auf dem Trainings Laptop Einträge in /etc/hosts, so dass man mit dem Browser direkt auf die VM zugreiffen kann.
Das VBGuest Plugin installiert automatisch die VirtualBox Guest Extensions in einer VM, damit wir Inhalte als ein Volume in die VM mounten können.

    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-vbguest

Falls die Plugins schon installiert waren, kann man prüfen, ob Aktualisierungen vorliegen:

    vagrant plugin update

## Vagrant Box

Vagrant arbeitet mit vorbereiteten VM Images. Wir muessen das CentOS/7 Image lokal ablegen:

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

## VirtualBox Vorbereitung

Unbedingt pruefen, ob die Host-only Netzwerke einen DHCP Server aktiviert haben !!

VirtualBox -> Datei -> Host-Only Netzwerk -> DHCP Server

Wenn der Host-Only DHCP Server aktiv ist: deaktivieren.
Wenn im DHCP Server Daten hinterlegt sind, diese bitte durch '0.0.0.0' ersetzen (auch wenn man DHCP danach ausschaltet.

Wenn man den DHCP Server deaktivieren musste, muss das Linux System neu gestartet werden! Don't ask.
## VM starten

Jetzt kann die VM instantiiert werden:

    cd vagrant
    vagrant up foreman.example42.training --provider virtualbox

Danach Login:

    vagrant ssh foreman.example42.training
    sudo -i

Wenn man am Abend das Laptop auschalten will, muss man die VM vorher sichern (nicht runterfahren!):

    vagrant suspend foreman.example42.training

Am naechsten Tag kann die VM wieder geladen werden:

    vagrant resume foreman.example42.training
## VM pruefen

Pruefen, ob eth1 Interface eine IP hat, ```ip a```. Wenn nein: ```ifup eth1```

Achtung:

Der Foreman Installer erwartet eine Namensauflösung innerhalb der VM.

In `/etc/hosts` sicherstellen, dass folgender Eintrag weg kommt `127.0.1.1 foreman.example42.training foreman` und folgender Eintrag hinzugefügt wird: `10.100.10.101 foreman.example42.training foreman`

Achtung 2: 

Der Foreman Installer erwartet eine sauber konfigurierte locale: `export LANG=en_US.UTF-8`

Wenn man sich von einem Apple System aus eingeloggt hat, muss man eine Umgebungsvariable löschen: `unset LC_CTYPE`

## Foreman Installer

Jetzt kann der Foreman Installer gestartet werden:

    foreman-installer --scenario katello -i

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
      * Foreman is running at https://foreman.example42.training
          Initial credentials are admin / <hier steht das initiale passwort>
      * To install an additional Foreman proxy on separate machine continue by running:

          foreman-proxy-certs-generate --foreman-proxy-fqdn "$FOREMAN_PROXY" --certs-tar "/root/$FOREMAN_PROXY-certs.tar"
      * Foreman Proxy is running at https://foreman.example42.training:9090
      The full log is at /var/log/foreman-installer/katello.log

Falls man diese Ausgabe nicht gesichert hat und das Passwort verloren hat, kann man das initiale Passwort aus der Answer-Datei auslesen:

    grep initial_admin_password /etc/foreman-installer/scenarios.d/katello-answers.yaml
      initial_admin_password: <hier steht das initiale passwort>

Falls diese Datei nicht mehr vorhanden ist, kann man ein neues Admin Passwort setzen:

    foreman-rake permissions:reset

## Konfiguration von Diensten

Nun muessen die Dienste konfiguriert werden.
Wir nutzen im Training dafuer Puppet Manifeste, die lokal deployed werden:

    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp
    puppet apply /vagrant_foreman/scripts/05_katello_services.pp
    puppet apply /vagrant_foreman/scripts/06_tftp.pp

Achtung: bei 01\_install\_service\_dhcp können Fehler auftreten.
Diese können ignoriert werden.

Achtung! Dieses Setup kann nur einmal durchgefuehrt werden.
Spaetestens das Provisionierungs Setup aendert diese Einstellungen grundlegend.

Wenn man die Vargant Instanz neu starten muss, muss die Router config und die resolv.conf neu gesetzt werden. Dazu muss erst das Flagfile geloescht werden, dann muss die Konfiguration wieder hergestellt werden:

    rm -f /etc/gateway_config
    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp

## Konfiguration Namensaufloesung

Namensauflösung prüfen: `ping -c1 heise.de`

Wenn das Kommando keine IP zurückliefert, muss in `/etc/named.conf` der Forwarder Eintrag geprüft und passend gesetzt werden.

z.B. (Auszug)

    ...
    options {
      listen-on port 53 { any; };
      directory       "/var/named";
      allow-query     { any; };
      dnssec-enable   no;
      forwarders      { 8.8.8.8; };	<- Anpassen z.B. auf Google DNS Server
    };
    ...

Nach der Änderung an `/etc/named.conf` muss der DNS Service neu gestartet werden: `systemctl restart named`

Weitermachen, wenn die Namensauflösung funktioniert.

## Foreman Web Interface

Einloggen als Admin mit dem Brwoser: https://foreman.example42.training

# Foreman Smart Proxies

Smart-Proxy ist ein Service, der auf einem System laeuft, welches Infrastruktur Komponenenten bereitstellt.
Dazu gehoeren zum Beispiel:

  - Repository Server
  - Puppet Server
  - Ansible Executor
  - DHCP Server
  - TFTP Server
  - DNS Server

Die Einstellungen für Smart Proxies koennen im Webinterface analysiert werden:

Foreman Login -> Infrastructure -> Smart proxies

Actions -> Refresh

Klick auf 'foreman.example42.training'

Auf aktive Services und Fehler pruefen.

Weiter geht es mit [Teil 2 Content](../02_content)
