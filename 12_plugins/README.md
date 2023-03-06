# Foreman Training - Teil 12 - Plugins

## Plugins

Einige Erweiterungen sind nicht Bestandteil der allgemeinen Installation.

Eine Uebersicht ueber vorhandene Plugins findet man auf der Webseite von Foreman: [https://projects.theforeman.org/projects/foreman/wiki/List_of_Plugins](https://projects.theforeman.org/projects/foreman/wiki/List_of_Plugins)

### Plugins als Paket

YUM Repositoriy für Plugins aktivieren (wurde durch den Installer bereits erledigt:

    # /etc/yum.repos.d/foreman-plugins.repo
    [foreman-plugins]
    name=Foreman plugins
    baseurl=http://yum.theforeman.org/plugins/1.15/el7/x86_64/
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
