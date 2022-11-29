
# Foreman Training - Teil 1 - Installation VM

In diesem Dokument wird eine Installation unter CentOS 8 beschrieben.
CentOS oder RHEL sind die einzigen unterstuetzten Betriebssysteme fuer eine Katello/Foreman Installation!

## VM pruefen

Achtung:

Der Foreman Installer erwartet eine Namensauflösung innerhalb der VM.
Es muss sichergesteltl sein, dass die VM ihren eigenen FQDN korrekt aufloesen kann.

    ping -c 1 [VM FQDN]

Der Foreman Installer erwartet eine sauber konfigurierte locale: `export LANG=en_US.UTF-8`

Wenn man sich von einem Apple System aus eingeloggt hat, muss man eine Umgebungsvariable löschen: `unset LC_CTYPE`

## Vorbereitung

Am einfaschsten ist es, wenn man das foreman-trainign Repository auf die VM kopiert (clont):

    git clone https://github.com/betadots/foreman-training
    cd foreman-training

Danach kann man das bootstrap script ausfuehren:

    scripts/bootstrap_foreman.sh

Dieses Script nimmt die im folgenden aufgelisteten Konfiguration vor:

### Repositories

Fuer ein Katello/Foreman System werden die folgenden Repositories benoetigt:

#### Foreman

    sudo dnf -y localinstall https://yum.theforeman.org/releases/3.4/el8/x86_64/foreman-release.rpm

#### Katello

    sudo dnf -y localinstall https://yum.theforeman.org/katello/4.6/katello/el8/x86_64/katello-repos-latest.rpm

#### Puppet 7 (auch wenn man nur Ansble machen moechte!)

    sudo dnf -y localinstall https://yum.puppet.com/puppet7-release-el-8.noarch.rpm

#### Powertools und Modules

    sudo dnf config-manager --set-enabled powertools
    sudo dnf module enable katello:el8 pulpcore:el8
    sudo dnf -y update

## Basis Installation

    sudo dnf -y install foreman-installer-katello

## Foreman Installer

Jetzt kann der Foreman Installer gestartet werden:

    sudo foreman-installer --scenario katello

Die Installation dauert.
Nach einiger Zeit kommt eine Abschlussmeldung:

      Success!
      * Foreman is running at https://[VM FQDN]
          Initial credentials are admin / <hier steht das initiale passwort>
      * To install an additional Foreman proxy on separate machine continue by running:

          foreman-proxy-certs-generate --foreman-proxy-fqdn "$FOREMAN_PROXY" --certs-tar "/root/$FOREMAN_PROXY-certs.tar"
      * Foreman Proxy is running at https://[VM FQDN]]:9090
      The full log is at /var/log/foreman-installer/katello.log

Falls man diese Ausgabe nicht gesichert hat und das Passwort verloren hat, kann man das initiale Passwort aus der Answer-Datei auslesen:

    grep initial_admin_password /etc/foreman-installer/scenarios.d/katello-answers.yaml
      initial_admin_password: <hier steht das initiale passwort>

Falls diese Datei nicht mehr vorhanden ist, kann man ein neues Admin Passwort setzen:

    foreman-rake permissions:reset

## Foreman Web Interface

Einloggen als Admin mit dem Browser: [https://[VM FQDN]](https://[VM FQDN])
