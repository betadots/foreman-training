# Foreman Training - Teil 6 - Compute Resources

Hier geht es um VMware, AWS, GCE, ....

## Plugins

Einige Erweiterungen sind nicht Bestandteil der allgemeinen Installation.

### Plugins als Paket

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

NEIN! Deprecated! Aktuell gibt es kein Docker Plugin fuer Foreman/Katello!

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
