# Foreman Training - Teil 12 - Plugins

## Plugins

Einige Erweiterungen sind nicht Bestandteil der allgemeinen Installation.

Eine Uebersicht ueber vorhandene Plugins findet man auf der Webseite von Foreman: https://projects.theforeman.org/projects/foreman/wiki/List_of_Plugins

### Plugins als Paket:

YUM Repositoriy fuer Plugins aktivieren (wurde durch den Installer bereits erledigt:

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
    systemctl restart foreman

Auf allen anderen Systemen:

    yum install -y cockpit
    systemctl start cockpit

Einmal auf Cockpit zugreifen (vorher root passwort in der vagrantbox setzen):

https://foreman.example42.training:9090

Dann in Foreman cockpit verwenden:

Foreman-Login -> Hosts -> All Hosts -> foreman.example42.training

## DHCP Browser

    yum install -y tfm-rubygem-foreman_dhcp_browser
    systemctl restart foreman

## Remote execution

    foreman-installer --enable-foreman-plugin-remote-execution\
                      --enable-foreman-proxy-plugin-remote-execution-ssh

    systemctl restart foreman
    systemctl restart foreman-proxy

    ssh-copy-id -i ~foreman-proxy/.ssh/id_rsa_foreman_proxy.pub root@<target>
