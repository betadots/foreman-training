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

Nach jeder Plugin Installation httpd service neu starten:

    service httpd restart

### Plugins als GEM

    scl enable tfm bash
    gem install <foreman plugin>


## Compute Resource

Foreman Login -> Infrastructure -> Compute Resource -> Create Compute Resource

- Name: docker from foreman
- Provider: docker
- URL: http://docker.example42.training:4243

Bei Fehlermeldung bitte seboolean fuer passenger aktivieren (siehe SETUP.md) 

### Container anlegen

Foreman Login -> Containers -> Create Container

Compute Resource:
- Docker -> Next Step

Image:
- Search: centos (Fehler im Browser koennen ignoriert werden)
- Tag: latest -> Next Step

Basic Options:
- Name: ping_heise (keine Leerzeichen! Keine Grossbuchstaben!)
- Command: ping -c 20 heise.de -> Next Step

Environment:
- Shell TTY aktivieren -> Submit

Jetzt Container starten

Auf docker.example42.training:

    watch docker ps



