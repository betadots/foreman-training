# Foreman Training - Teil 4 - Plugins

## Plugins

Einige Erweiterungen sind nicht Bestandteil der allgemeinen Installation.


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

Erweiterungen installieren:

    yum install -y tfm-rubygem-foreman_docker
    yum install -y tfm-rubygem-foreman_docker-doc


### Plugins als GEM

    scl enable tfm bash
    gem install <foreman plugin>


## Compute Resource

Foreman Login -> Infrastructure -> Compute Resource -> Create Compute Resource

Name: docker from foreman
Provider: docker
URL: http://docker.example42.training:4243

## Cockpit

Auf der foreman instanz:

    yum install -y tfm-rubygem-foreman_cockpit

Auf allen anderen Systemen:

    yum install -y cockpit
    systemctl start cockpit

Einmal auf Cockpit zugreifen (vorher root passwort in der vagrantbox setzen):

https://foreman.example42.training:9090

Dann in Foreman cockpit verwenden:

Foreman-Login -> Hosts -> All Hosts -> foreman.example42.training

## DHCP Browser

    yum install -y tfm-rubygem-foreman_dhcp_browser


## Remote execution

    yum install -y tfm-rubygem-foreman_remote_execution

