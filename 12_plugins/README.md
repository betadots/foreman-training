# Foreman Training - Teil 12 - Plugins

## Plugins

Einige Erweiterungen sind nicht Bestandteil der allgemeinen Installation.

Eine Uebersicht ueber vorhandene Plugins findet man auf der Webseite von Foreman: [https://projects.theforeman.org/projects/foreman/wiki/List_of_Plugins](https://projects.theforeman.org/projects/foreman/wiki/List_of_Plugins)

### Plugins als Paket

YUM Repositoriy für Plugins aktivieren (wurde durch den Installer bereits erledigt):

    # /etc/yum.repos.d/foreman-plugins.repo
    [foreman-plugins]
    name=Foreman plugins
    baseurl=http://yum.theforeman.org/plugins/3.8/el8/x86_64/
    enabled=1
    gpgcheck=0

Vorhandene Plugins anschauen:

    yum search tfm-rubygem-foreman

## Cockpit

Auf der foreman instanz:

    yum install -y tfm-rubygem-foreman_cockpit
    foreman-maintain servcie restart --only foreman

Auf allen anderen Systemen:

    yum install -y cockpit
    systemctl start cockpit

Einmal auf Cockpit zugreifen (vorher root passwort in der vagrantbox setzen):

<https://foreman.betadots.training:9090>

Dann in Foreman cockpit verwenden:

    Foreman-Login
      -> Hosts
        -> All Hosts
          -> foreman.betadots.training

## DHCP Browser

    yum install -y tfm-rubygem-foreman_dhcp_browser
    systemctl restart foreman

## Remote execution

Foreman 3.4:

    foreman-installer --enable-foreman-plugin-remote-execution\
                      --enable-foreman-proxy-plugin-remote-execution-ssh

Foreman 3.5:

Achtung: bei Foreman 3.5 und neuer muss es `enable-foreman-proxy-plugin-remote-execution-script` heissen.
Ausserdem muss zusätzlich foreman tasks installiert werden:

    foreman-installer --enable-foreman-plugin-remote-execution\
                      --enable-foreman-proxy-plugin-remote-execution-script\
                      --enable-foreman-plugin-task


    foreman-maintain service restart --only foreman
    systemctl restart foreman-proxy

    ssh-copy-id -i ~foreman-proxy/.ssh/id_rsa_foreman_proxy.pub root@<target>

## Forklift

Voraussetzungen: Vagrant, libvirt, Ansible

<https://github.com/theforeman/forklift>

## Puppet HDM - Hiera Data Manager

Web UI zum Analysieren und Bearbeiten von Hiera Daten.
Herunterladen der notwendigen Puppet Module,
erzeugen der notwendigen Daten Struktur:

```shell
puppet module install puppetlabs-puppetdb
puppet module install puppet-hdm
mkdir -p /etc/puppetlabs/code/environments/production/data/nodes
mkdir -p /etc/puppetlabs/code/environments/production/manifests
cat > /etc/puppetlabs/code/environments/production/manifests/site.pp << EOF
File {
  backup => false,
}
lookup('classes', Array, 'unique', []).contain
EOF
cat > /etc/puppetlabs/code/environments/production/data/nodes/foreman.betadots.training.yaml << EOF2
---
classes:
  - 'hdm'
  - 'puppetdb'
  - 'puppetdb::master::config'

hdm::version: 'v1.4.1'
postgresql::globals::manage_dnf_module: true
puppetdb::manage_firewall: false
puppetdb::postgres_version: '12'
EOF2

# Run puppet agent on foreman
puppet agent -t
```

HDB Web UI öffnen, Admin User anlegen, API User anlegen.
Passwörter merken!!!

http://foreman.betadots.training:3000

Installation des Foreman HDM Plugin und des Foreman HDM Smart-Proxy

```shell
dnf install -y rubygem-foreman_hdm rubygem-smart_proxy_hdm
foreman-rake db:migrate
systemctl restart foreman.service
# or
# foremain-maintain service restart
```

HDM Smart-Proxy Konfiguration:

```shell
cat > /etc/foreman-proxy/settings.d/hdm.yml << EOF3
# HDM Smart Proxy
:enabled: https
:hdm_url: 'http://foreman.betadots.training:3000'
:hdm_user: 'api@domain.tld'
:hdm_password: '1234567890'
EOF3

systemctl restart foreman-proxy
```

In Foreman `Infrastructure -> Smart Proxies -> foreman.betadots.training -> Refresh`.

Danach kann der HDM Smart Proxy aktiviert werden:  `Hosts -> All Hosts -> foreman.betadots.training -> Edit -> HDM Smart Proxy` den HDM Smart Proxy aktivieren.
