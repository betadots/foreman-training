
# Foreman Training - Teil 1 - Installation

In diesem Dokument wird eine Installation unter CentOS 8 mit Hilfe von VirtualBox und vagrant beschrieben.
CentOS oder RHEL sind die einzigen unterstuetzten Betriebssysteme fuer eine Katello/Foreman Installation!

Eine Foreman Installation ohne Katello kann auch auf Debian 11 oder Ubuntu 20 erfolgen.

Fuer eine Installation auf einer existierenden VM bitte das Dokument [../01_installation_vm](../01_installation_vm) verwenden.
Achtung: eine so erzeugt VM kann nicht fuer das Training verwendet werden!

## Vagrant Installation

Bitte eine aktuelle Version von Vagrant installieren: [https://developer.hashicorp.com/vagrant/downloads](https://developer.hashicorp.com/vagrant/downloads)
Achtung: wenn Vagrant schon installiert ist, dann unbedingt pruefen, ob die Version aktuell ist!

Debian:

    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install vagrant

CentOS:

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install vagrant

Windows:

    choco install vagrant

Falls Vargant vorher schon installiert war, muss man die Plugins reaktivieren: `vagrant plugin expunge --reinstall`

## Vagrant Erweiterungen

Es werden zwei Vagrant Plugins eingesetzt:

- vagrant-hostmanager
- vagrant-vbguest

Das Hostmanager Plugin erzeugt auf dem Trainings Laptop Einträge in /etc/hosts, so dass man mit dem Browser direkt auf die VM zugreiffen kann.
Das VBGuest Plugin installiert automatisch die VirtualBox Guest Extensions in einer VM, damit wir dieses GIT Repository als ein Volume in die VM mounten können.

    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-vbguest

Falls die Plugins schon installiert waren, kann man prüfen, ob Aktualisierungen vorliegen:

    vagrant plugin update

## Vagrant Box

Vagrant arbeitet mit vorbereiteten VM Images. Wir muessen das CentOS/8 Image lokal ablegen:

    vagrant box add centos/8

    ==> box: Loading metadata for box 'centos/8'
        box: URL: https://vagrantcloud.com/centos/8
    This box can work with multiple providers! The providers that it
    can work with are listed below. Please review the list and choose
    the provider you will be working with.
    
    1) hyperv
    2) libvirt
    3) virtualbox
    4) vmware_desktop

    Enter your choice: 3
    ==> box: Adding box 'centos/8' (vxxx.y) for provider: virtualbox
        box: Downloading: https://vagrantcloud.com/centos/boxes/8/versions/xxxx.y/providers/virtualbox.box
        box: Download redirected to host: cloud.centos.org
    ==> box: Successfully added box 'centos/8' (vxxxx.y) for 'virtualbox'!

## VirtualBox Vorbereitung

Unbedingt pruefen, ob die Host-only Netzwerke einen DHCP Server aktiviert haben !!

VirtualBox -> Datei -> Host-Only Netzwerk -> DHCP Server

Wenn der Host-Only DHCP Server aktiv ist: deaktivieren.
Wenn im DHCP Server Daten hinterlegt sind, diese bitte durch '0.0.0.0' ersetzen (auch wenn man DHCP danach ausschaltet.

Wenn man den DHCP Server deaktivieren musste, muss das Linux System neu gestartet werden! Don't ask.

## VM starten

Jetzt kann die VM instantiiert werden:

    cd vagrant
    vagrant up foreman.betadots.training --provider virtualbox

Danach Login:

    vagrant ssh foreman.betadots.training
    sudo -i

Wenn man am Abend das Laptop auschalten will, muss man die VM vorher sichern (nicht runterfahren!):

    vagrant suspend foreman.betadots.training

Am naechsten Tag kann die VM wieder geladen werden:

    vagrant resume foreman.betadots.training

## VM pruefen

Pruefen, ob eth1 Interface eine IP hat, `ip a`. Wenn nein: `ifup eth1`

Achtung:

Der Foreman Installer erwartet eine Namensauflösung innerhalb der VM.

In `/etc/hosts` sicherstellen, dass folgender Eintrag weg kommt `127.0.1.1 foreman.betadots.training foreman` und folgender Eintrag hinzugefügt wird: `10.100.10.101 foreman.betadots.training foreman`

Achtung 2:

Der Foreman Installer erwartet eine sauber konfigurierte locale: `export LANG=en_US.UTF-8`

Wenn man sich von einem Apple System aus eingeloggt hat, muss man eine Umgebungsvariable löschen: `unset LC_CTYPE`

## Foreman Installer

Jetzt kann der Foreman Installer gestartet werden:

    foreman-installer --scenario katello -i

    4. [✓] Configure foreman_cli_ansible
    9. [✓] Configure foreman_cli_remote_execution
    10. [✓] Configure foreman_cli_tasks
    19. [✓] Configure foreman_plugin_ansible
    35. [✓] Configure foreman_plugin_remote_execution
    42. [✓] Configure foreman_plugin_tasks
    47. [✓] Configure foreman_proxy_plugin_ansible
    56. [✓] Configure foreman_proxy_plugin_remote_execution_ssh

Nun Punkt `61 Save and run` auswaehlen.

Die Installation dauert.
Nach einiger Zeit kommt eine Abschlussmeldung:

    Upgrade Step 15/15: katello:upgrades:3.18:add_cvv_export_history_metadata.   Success!
      * Foreman is running at https://foreman.betadots.training
          Initial credentials are admin / LpobAfv5XTW6pVx7
      * To install an additional Foreman proxy on separate machine continue by running:
    
          foreman-proxy-certs-generate --foreman-proxy-fqdn "$FOREMAN_PROXY"
    --certs-tar "/root/$FOREMAN_PROXY-certs.tar"
      * Foreman Proxy is running at https://foreman.betadots.training:9090
    
      The full log is at /var/log/foreman-installer/katello.log

Falls man diese Ausgabe nicht gesichert hat und das Passwort verloren hat, kann man das initiale Passwort aus der Answer-Datei auslesen:

    grep initial_admin_password /etc/foreman-installer/scenarios.d/katello-answers.yaml
      initial_admin_password: <hier steht das initiale passwort>

Falls diese Datei nicht mehr vorhanden ist, kann man ein neues Admin Passwort setzen:

    foreman-rake permissions:reset

## Konfiguration von Diensten

Nun muessen die Infrastruktur-Dienste konfiguriert werden.
Wir nutzen im Training dafuer Puppet Manifeste, die lokal deployed werden:

    puppet apply /vagrant_foreman/scripts/00_router_config.pp
    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp
    puppet apply /vagrant_foreman/scripts/05_katello_services.pp
    puppet apply /vagrant_foreman/scripts/06_tftp.pp

Achtung: bei 01\_install\_service\_bind können Fehler auftreten.
Diese können ignoriert werden.

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
      forwarders      { 8.8.8.8; }; <- Anpassen z.B. auf Google DNS Server
    };
    ...

Nach der Änderung an `/etc/named.conf` muss der DNS Service neu gestartet werden: `systemctl restart named`

Weitermachen, wenn die Namensauflösung funktioniert.

## Foreman Web Interface

Einloggen als Admin mit dem Brwoser: [https://foreman.betadots.training](https://foreman.betadots.training)

# Foreman Smart Proxies

Smart-Proxy ist ein Service, der auf einem System laeuft, welches Infrastruktur Komponenenten bereitstellt.
Dazu gehoeren zum Beispiel:

- Repository Server (pulp)
- Puppet Server
- Ansible Executor
- DHCP Server
- TFTP Server
- DNS Server
- Remote Execution

Die Einstellungen für Smart Proxies koennen im Webinterface analysiert werden:

Foreman Login -> Infrastructure -> Smart proxies

Actions -> Refresh

Klick auf 'foreman.betadots.training'

Auf aktive Services und Fehler pruefen.

Weiter geht es mit [Teil 2 Content](../02_content)
