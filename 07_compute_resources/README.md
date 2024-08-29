# Foreman Training - Teil 6 - Compute Resources

Hier geht es um VMware, AWS, GCE, ....

## Plugins

Einige Erweiterungen sind nicht Bestandteil der allgemeinen Installation.

### Plugins als Paket

YUM Repositoriy fuer Plugins aktivieren (wurde durch den Installer bereits erledigt:

    # /etc/yum.repos.d/foreman-plugins.repo
    [foreman-plugins]
    name=Foreman plugins
    baseurl=http://yum.theforeman.org/plugins/<version>/el9/x86_64/
    enabled=1
    gpgcheck=0

Vorhandene Plugins anschauen:

    foreman-installer --full-help | grep compute

Erweiterungen installieren:

#### libvirt

Im Linuxhotel:

Auf dem Laptop KVM/QEMU installieren. Am Foreman Server als User foreman einen SSH Key erzeugen:

    su - foreman -s /bin/bash
    ssh-keygen -t ed25519
    cat .ssh/id_ed25519.pub

SSH Key notieren.

Am Linuxhotel Laptop den Key als **root** User hinterlegen

    sudo vi ~/.ssh/authorized_keys
    # Key hinzufügen
    sudo systemctl enable libvirtd-tcp.socket

Auf dem Foreman Server:

    foreman-installer --enable-foreman-compute-* # Auslesen mit --full-help

Im Webinterface

    Foreman
    -> Infrastructure
      -> Compute
        -> Add

KVM auswählen. URL: `qemu+ssh:root@<fqdn linuxhotel laptop>/system`. Verbindung testen.

Auf dem Linuxhotel Laptop eine KVM Instanz erzeugen. In der Foreman Compute WebUI erscheint diese.

#### Docker - deprecated

Deprecated! Aktuell gibt es kein Docker Plugin fuer Foreman/Katello!

    yum install -y tfm-rubygem-foreman_docker

Nach jeder Plugin Installation die Datenbank Updates einspielen und den Foreman service neu starten:

    foreman-rake db:migrate
    foreman-maintain service restart --only foreman

### Plugins als GEM

Achtung: dies sollte man nur machen, wenn man an Foreman Erweiterungen mit-programmieren möchte.

    scl enable tfm bash
    gem install <foreman plugin>

## Compute Resource

    Foreman Login
      -> Infrastructure
        -> Compute Resource
          -> Create Compute Resource

- Name: docker from foreman
- Provider: docker
- URL: <http://docker.betadots.training:4243>

Weiter mit Teil 8 [Integration in Infrastruktur](../08_integration_in_infrastruktur)
