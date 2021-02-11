
# Foreman Training - Teil 1 - Installation VM

In diesem Dokument wird eine Installation unter CentOS 7 beschrieben.
CwentOS 7 oder RHEL 7 sind die einzigen unterstuetzten Betriebssysteme fuer eine Katello/Foreman Installation!

## VM pruefen

Achtung:

Der Foreman Installer erwartet eine Namensauflösung innerhalb der VM.
Es muss sichergesteltl sein, dass die VM ihren eigenen FQDN korrekt aufloesen kann.

Der Foreman Installer erwartet eine sauber konfigurierte locale: `export LANG=en_US.UTF-8`

Wenn man sich von einem Apple System aus eingeloggt hat, muss man eine Umgebungsvariable löschen: `unset LC_CTYPE`

## Vorbereitung

Am einfaschsten ist es, wenn man das foreman-trainign Repository auf die VM kopiert (clont):

    git clone https://github.com/example42/foreman-training
    cd foreman-training

Danach kann man das bootstrap script ausfuehren:

    scripts/bootstrap_foreman.sh

Dieses Script nimmt die im folgenden aufgelisteten Konfiguration vor:

### Repositories

Fuer ein Katello/Foreman System werden die folgenden Repositories benoetigt:

#### Foreman

    sudo yum -y localinstall https://yum.theforeman.org/releases/2.3/el7/x86_64/foreman-release.rpm

#### Katello

    sudo yum -y localinstall https://fedorapeople.org/groups/katello/releases/yum/3.18/katello/el7/x86_64/katello-repos-latest.rpm

#### Katello-Client

    sudo yum -y localinstall https://yum.theforeman.org/client/2.3/el7/x86_64/foreman-client-release.rpm

#### Puppet 6 (auch wenn man nur Ansble machen moechte!)

    sudo yum -y localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm

### RH SCL

    sudo yum -y install epel-release centos-release-scl-rh

## Basis Installation

    sudo yum install katello

## Fixes

### python-qpid Fix (https://community.theforeman.org/t/katello-installation-broken/21374)

    sudo yum -y localinstall https://download-ib01.fedoraproject.org/pub/epel/7/aarch64/Packages/p/python2-qpid-1.37.0-4.el7.noarch.rpm

### TFTP Config Fix (https://github.com/theforeman/puppet-foreman/issues/580)

    sudo mkdir -p /var/lib/tftpboot/boot
 
## Foreman Installer

Jetzt kann der Foreman Installer gestartet werden:

    sudo foreman-installer --scenario katello -i

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

Wenn man lokal mit DNS, DHCP und TFTP auf der VM arbeiten moechte, kann man die Trainings Puppet Manifeste zum Einrichten verwenden.
Wichtig: die Puppet Manifeste gehen davon aus, dass die VM eine IP 10.100.10.101 hat!!

    sudo -i
    # puppet apply scripts/00_router_config.pp
    puppet apply scripts/01_install_service_dhcp.pp
    puppet apply scripts/02_install_service_bind.pp
    puppet apply scripts/03_foreman_proxy.pp
    puppet apply scripts/05_katello_services.pp
    puppet apply scripts/06_tftp.pp

Achtung: bei 01\_install\_service\_dhcp können Fehler auftreten.
Diese können ignoriert werden.

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

Einloggen als Admin mit dem Brwoser: [https://VM FQDN](https://VM FQDN)

