
# Foreman Training - Teil 1 - Installation

In diesem Dokument wird eine Installation unter CentOS 8 Stream mit Hilfe von VirtualBox und vagrant beschrieben.
CentOS 8 Stream oder RHEL 8 sind die einzigen unterstuetzten Betriebssysteme fuer eine Katello4.6/Foreman3.4 Installation (<https://docs.theforeman.org/release/3.4/>).

Eine Foreman Installation ohne Katello kann auch auf Debian 11 oder Ubuntu 20 erfolgen.

Fuer eine Installation auf einer existierenden VM bitte das Dokument [../01_installation_vm](../01_installation_vm) verwenden.
Achtung: eine so erzeugt VM kann nicht fuer das Training verwendet werden!

## Vagrant Installation

Bitte eine aktuelle Version von Vagrant installieren: [https://developer.hashicorp.com/vagrant/downloads](https://developer.hashicorp.com/vagrant/downloads)
Achtung: wenn Vagrant schon installiert ist, dann unbedingt pruefen, ob die Version aktuell ist!

    which vagrant
    vagrant --version

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
- vagrant-disksize

Das Hostmanager Plugin erzeugt auf dem Trainings Laptop Einträge in /etc/hosts, so dass man mit dem Browser direkt auf die VM zugreiffen kann.

Das VBGuest Plugin installiert automatisch die VirtualBox Guest Extensions in einer VM, damit wir dieses GIT Repository als ein Volume in die VM mounten können.

Das Disksize Plugin passt die Standardgröße (10 GB) an die Bedürfnisse an. In unserem Fall bekommt der Foreman Server eine root-Disk mit 50 GB.

    vagrant plugin install vagrant-hostmanager
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-disksize

Falls die Plugins schon installiert waren, kann man prüfen, ob Aktualisierungen vorliegen:

    vagrant plugin update

## Vagrant Box

Vagrant arbeitet mit vorbereiteten VM Images. Wir muessen das CentOS/8 Image lokal ablegen:

    vagrant box add centos/stream8 --provider virtualbox

    ==> box: Loading metadata for box 'centos/stream8'
        box: URL: https://vagrantcloud.com/centos/stream8
    ==> box: Adding box 'stream8' (vxxx.y) for provider: virtualbox
        box: Downloading: https://vagrantcloud.com/centos/boxes/stream8/versions/xxxx.y/providers/virtualbox.box
        box: Download redirected to host: cloud.centos.org
    ==> box: Successfully added box 'centos/stream8' (vxxxx.y) for 'virtualbox'!

## VirtualBox Vorbereitung

Unbedingt pruefen, ob die Host-only Netzwerke einen DHCP Server aktiviert haben !!

VirtualBox -> Datei -> Host-Only Netzwerk -> DHCP Server

Wenn der Host-Only DHCP Server aktiv ist: deaktivieren.
Wenn im DHCP Server Daten hinterlegt sind, diese bitte durch '0.0.0.0' ersetzen (auch wenn man DHCP danach ausschaltet.

Wenn man den DHCP Server deaktivieren musste, muss das Linux System neu gestartet werden! Unbedingt neu starten!

## Virtualbox

Als Virtualisierungsbackend wird [Virtualbox](https://virtualbox.org) genutzt.
Bitte prüfen, ob Virtualbox installiert ist, notfalls nachinstallieren.
Ausserdem werden die VirtualBox Guest Extensoins benötigt.

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

In `/etc/hosts` sicherstellen, dass folgender Eintrag entfernt wird:

    127.0.1.1 foreman.betadots.training foreman

Der folgender Eintrag muss vorhanden sein:

    10.100.10.101 foreman.betadots.training foreman

Achtung 2:

Der Foreman Installer erwartet eine sauber konfigurierte locale: `export LANG=en_US.UTF-8`

Wenn man sich von einem Apple System aus eingeloggt hat, muss man eine Umgebungsvariable löschen: `unset LC_CTYPE`

## Foreman Installer

Achtung ab Version Foreman 3.4 and Katello 4.6! Tuning parameter!

<https://github.com/theforeman/foreman-installer/blob/develop/hooks/pre_commit/13-tuning.rb#L3>

| Tuning Policy     | min CPU Cores | min RAM | wie viele Hosts? |
|-------------------|--------------:|--------:|-----------------:|
| development       | 1             | 6       | ein paar         |
| default           | 4             | 20      | bis 5.000        |
| medium            | 8             | 32      | bis 10.000       |
| large             | 16            | 64      | bis 20.000       |
| extra-large       | 32            | 128     | bis 60.000       |
| extra-extra-large | 48+           | 256     | mehr als 60.000  |

Jetzt kann der Foreman Installer gestartet werden:

    foreman-installer --scenario katello -i # --tuning default

Im interaktiven Modus können Komponenten hinzugefügt oder entfernt werden:

    63. [✓] Configure foreman_proxy_plugin_remote_execution_script

Dann Punkt `70. Save and run` auswaehlen.

Die Installation dauert.
Nach einiger Zeit kommt eine Abschlussmeldung:

    * Foreman is running at <https://foreman.betadots.training>
        Initial credentials are admin / iwhECcnoGS4sqGDc
    * To install an additional Foreman proxy on separate machine continue by running:

        foreman-proxy-certs-generate --foreman-proxy-fqdn "$FOREMAN_PROXY" --certs-tar "/root/$FOREMAN_PROXY-certs.tar"
    * Foreman Proxy is running at <https://foreman.betadots.training:9090>

    The full log is at /var/log/foreman-installer/katello.log

Falls man diese Ausgabe nicht gesichert hat und das Passwort verloren hat, kann man das initiale Passwort aus der Answer-Datei auslesen:

    grep initial_admin_password /etc/foreman-installer/scenarios.d/katello-answers.yaml
      initial_admin_password: <hier steht das initiale passwort>

Falls diese Datei nicht mehr vorhanden ist, kann man ein neues Admin Passwort setzen:

    foreman-rake permissions:reset

## Greenfield <-> Brownfield

Im Training gehen wir davon aus, dass Infrastruktur Komponentne, wie DHCP, DNS, TFTP bereits vorhanden sind.
Die Integration erfolgt üblicherweise über Parameter für den `foreman-installer`.

    foreman-installer --help

Im Training nehmen wir die Integration erst nach der Installation vor.

## Foreman

Einloggen als Admin mit dem Browser: [https://foreman.betadots.training](https://foreman.betadots.training)

## Trainings Erweiterungen

### Foreman/Ansible

    foreman-installer --enable-foreman-plugin-ansible \
      --enable-foreman-proxy-plugin-ansible

Auf einem Smart-Proxy:

    foreman-installer --scenario foreman-proxy-content \
      --enable-foreman-proxy-plugin-ansible

### Foreman/Puppet

Aktivierung von Puppet auf dem Foreman Server mit Hilfe von installer Optionen:

    foreman-installer --enable-foreman-plugin-puppet \
      --enable-foreman-cli-puppet \
      --foreman-proxy-puppet true \
      --foreman-proxy-puppetca true \
      --foreman-proxy-content-puppet true \
      --enable-puppet \
      --puppet-server true \
      --puppet-server-foreman-ssl-ca /etc/pki/katello/puppet/puppet_client_ca.crt \
      --puppet-server-foreman-ssl-cert /etc/pki/katello/puppet/puppet_client.crt \
      --puppet-server-foreman-ssl-key /etc/pki/katello/puppet/puppet_client.key

Aktivierung von Puppet auf einem Smart-Proxy:

    foreman-installer --scenario foreman-proxy-content \
      --foreman-proxy-puppet true \
      --foreman-proxy-puppetca true \
      --foreman-proxy-content-puppet true \
      --enable-puppet \
      --puppet-server true \
      --puppet-server-foreman-ssl-ca /etc/pki/katello/puppet/puppet_client_ca.crt \
      --puppet-server-foreman-ssl-cert /etc/pki/katello/puppet/puppet_client.crt \
      --puppet-server-foreman-ssl-key /etc/pki/katello/puppet/puppet_client.key \
      --puppet-server-foreman-url "foreman.example.com"

## SSH Remote Execution

Die Remote Execution erfolgt über Smart Proxy.

Dazu muss der Foreman-Proxy User einen SSH Key haben, der in der Infrastruktur vertile wurde.

1. manuelles kopieren vom Smart-Proxy

    su - foreman-proxy
    ssh-copy-id -i ~foreman-proxy/.ssh/id_rsa_foreman_proxy.pub root@target.example.com
    exit

Prüfen der Verbindung:

    su - foreman-proxy
    ssh -i ~foreman-proxy/.ssh/id_rsa_foreman_proxy root@target.example.com
    exit

2. Foreman API

Auf dem Ziel System:

    su -
    mkdir ~/.ssh
    curl <https://foreman.betadots.training:9090/ssh/pubkey> >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
    exit

3. Kickstart Template

Bei einer Neuinstallation über Netzwerk (PXE Boot) kann man das hinterlegen des SSH Keys automatisieren.

Das machen wir, wenn wir zum Thema 'Provisioning' kommen.

## Installation Foreman Smart-Proxy

Für die Installation eines Systems als Foreman Smart-Proxy benötigen wir Content und einen Activation Key.

Dies wird unter Punkt 02_content durchgeführt.

Generelle Anleitung:

Im Foreman Web UI:

    Hosts
      -> Register Host
        -> Generate

Hier wird ein Kommando erzeugt, welches kopiert und auf dem Smart-Proxy ausgeführt wird.

Danach muss die Subscription konfiguriert werden:

    subscription-manager config \
      --rhsm.baseurl=<https://loadbalancer.example.com/pulp/content> \
      --server.hostname=loadbalancer.example.com

## Konfiguration von Diensten

Nun muessen die Infrastruktur-Dienste konfiguriert werden.
Wir nutzen im Training dafuer Puppet Manifeste, die lokal deployed werden:

    puppet apply /vagrant_foreman/scripts/foreman_config.pp

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

Einloggen als Admin mit dem Browser: [https://foreman.betadots.training](https://foreman.betadots.training)

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

    Foreman Login
      -> Infrastructure
        -> Smart proxies

Im Menu rechts oben finde macn Actions:

    Actions
      -> Refresh

Klick auf 'foreman.betadots.training'

Auf aktive Services und Fehler pruefen.

Weiter geht es mit [Teil 2 Content](../02_content)
