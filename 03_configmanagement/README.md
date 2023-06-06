# Foreman Training - Teil 3 - Configuration Management

Mit Foreman kann man Konfigurationsmanagement verwalten.
Es werden die folgenden CfgMgmt Tools unterstützt:

- Puppet
- Ansible
- Chef
- Salt

Im Training gehen wir auf Ansible und Puppet ein.

## Puppet Environments

Zuerst installieren wir Puppet Module:

    puppet module install puppetlabs-docker
    puppet module install puppetlabs-apache
    puppet module install puppetlabs-ntp

Jetzt werden die Module in Foreman bekannt gemacht:

    Foreman Login
      -> Configure
        -> Puppet
          -> Environments
            -> 'Import environments from foreman.betadots.training'

Haken setzen -> Update

## Ansible Roles

Zuerst installieren wir Ansible Rollen:

    ansible-galaxy install geerlingguy.docker -p /etc/ansible/roles
    ansible-galaxy install geerlingguy.apache -p /etc/ansible/roles
    ansible-galaxy install frzk.chrony -p /etc/ansible/roles

Danach werden die Rollen Foreman bekannt gemacht:

    Foreman Login
      -> Configure
        -> Ansible
          -> Roles
            -> 'Import from foreman.betadots.training'

Haken setzen -> Update

## Hosts Konfigurieren

Mit Puppet oder Ansible können Systeme eingerichtet werden.
Dazu gehören zu Beispiel die Installation und Konfiruation von Paketen und Diensten.

    Foreman Login
      -> Hosts
        -> All Hosts
          -> Edit

### Ansible

Im Tab "Ansible Roles" die Ansible Rollen auswählen, die der Host bekommen soll (hier: frzk.chrony)

Im Tab "Parameter" koennen Rollenspezifische Daten gesetzt werden.

    Host Parameter
      -> Add Parameter

Name: `chrony_ntp_servers`
Type: `Array`
Value: `['pool.ntp.org']`

Submit

### Puppet

Im Tab "Host" muss das gewünschte Puppet Environment (Produktion), der Puppet Proxy und Puppet CA Proxy ausgewählt werden.
Im Tab "Puppet Classes" können dann Puppet Klassen ausgewählt werden (Docker Baum öffnen, Docker auswählen).

Submit

### Globale Defaults (Smart Class Variables)

    Foreman Login
      -> Configure
        -> Smart Class Parameters

search:  `puppetclass =  docker and  parameter =  tcp_bind`

Klick auf `tcp_bind`

Default behavior:

- Override: `OK`
- Key type: `string`
- Default value: `'tcp://0.0.0.0:4243'`

Submit

### Config Management starten

Achtung: SSH Zugang muss eingerichtet werden für die remote command execution:

    mkdir /root/.ssh
    cat /var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy.pub >> /root/.ssh/authorized_keys

In der Host Ansicht (Foreman Login -> All Hosts) den Host auswählen (Haken in der ersten Spalte) dann kann man unter "Select Action" den Punkt "Schedule Remote Job" auswählen.

In der Job Übersicht kann man den gewünschten Job auswählen.

z.B. das Starten des Puppet Agent (Job categrory "Puppet" -> Job template "Run Puppet Once")

Für Ansible geht der Weg direkt über den Host: Forman Login -> Hosts -> All hosts) den Host auswählen (Haken in der ersten Spalte, dann mann man unter "Select action" den Punkt "Run all Ansible roles" auswählen.

Bug in Ansible/Foreman: "ERROR! Unexpected Exception, this is probably a bug: No module named psutil"

[https://community.theforeman.org/t/error-unexpected-exception-this-is-probably-a-bug-no-module-named-psutil/16965](https://community.theforeman.org/t/error-unexpected-exception-this-is-probably-a-bug-no-module-named-psutil/16965)
[https://github.com/ansible/ansible-runner/issues/54](https://github.com/ansible/ansible-runner/issues/54)

Lösung:

    dnf install python3.11-pip
    python3.11 -m pip install psutil

Bug in Foreman: call back (Ansible Reporting)

Es fehlt die Python 'request' Erweiterung:

    python3.11 -m pip install requests

Ausserdem muss die Ansible Konfiguratoinsdatei bearbeitet werden:

    # /etc/ansible/ansible.cfg
    [defaults]
    roles_path = /etc/ansible/roles:/usr/share/ansible/roles
    collections_paths = /etc/ansible/collections:/usr/share/ansible/collections
    callback_whitelist = theforeman.foreman.foreman
    stdout_callback = theforeman.foreman.foreman
    bin_ansible_callbacks = true

    [callback_foreman]
    report_type = foreman
    proxy_url = https://foreman.betadots.training:9090
    url = https://foreman.betadots.training
    ssl_cert = /etc/foreman-proxy/foreman_ssl_cert.pem
    ssl_key = /etc/foreman-proxy/foreman_ssl_key.pem
    verify_certs = /etc/foreman-proxy/foreman_ssl_ca.pem

Achtung: wenn man Ansible UND Puppet verwendet, dann muss man Foreman mitteilen, welcher Job für Puppet Agent Lauf verwendet werden soll: Ansible oder SSH.

    Foreman Login
      -> Administer
        -> Remote Execution Features
          -> puppet_run_host auswaehlen

Job Template: Puppet Run Once - SSH Default auswählen.

## Host Groups

Wenn man viele Systeme hat, die eventuell gleiche Funktionalität haben, kann man Hostgruppen anlegen:

    Foreman Login
      -> Configure
        -> Host Groups
          -> Create Host Group

Hierbei ist es wichtig, dass man sich erst eine Übersicht über die eigene Infrastruktur erstellt hat, bevor man mit Hostgruppen anfängt.
Ein Host kann nur in eine Hostgruppe aufgenommen werden!!

Generell gibt es 4 grobe Ansätze zum Erzeugen von Hostgruppen:

- Flache Sturktur
- Lifecycle Environment basierte Struktur
- Applikationsbasierte Struktur
- Lokationsbasierte Struktur

| Flach               | Environment              | Applikation                   | Lokation                     |
|---------------------|--------------------------|-------------------------------|------------------------------|
| dev-infra-git-rhel7 | **dev**                  | **acmeweb**                   | **Munich**                       |
| qa-infra-git-rhel7  | *dev*/**rhel8**          | *acmeweb*/**frontend**        | *Munich*/**web-dev**             |
| prod-infra-git-rhel7| *dev/rhel8*/**git**      | *acmeweb/frontend*/**web-dev**| *Munich/web-dev*/**web-frontend**|
|                     | *dev/rhel8*/**container**| *acmeweb/frontend*/**web-qa** | *Munich/web-dev*/**web-backend** |
|                     | *dev*/**rhel7**          | *acmeweb*/**backend**         | *Munich*/**web-qa**              |
|                     | *dev/rhel7*/**loghost**  | *acmeweb/backend*/**web-dev** | *Munich/web-qa*/**web-frontend** |
|                     | **qa**                   | **infra**                     | **Boston**                       |

Quelle: [https://access.redhat.com/documentation/en-us/red_hat_satellite/6.7/html/planning_for_red_hat_satellite/chap-red_hat_satellite-architecture_guide-host_grouping_concepts](https://access.redhat.com/documentation/en-us/red_hat_satellite/6.7/html/planning_for_red_hat_satellite/chap-red_hat_satellite-architecture_guide-host_grouping_concepts)

Alternativ kann man auch die Foreman Locations nutzen. Aktuell haben wir nur eine Default Location

Jeder Hostgruppe können dann Ansible Rollen, Puppet Klassen und die dazugehörigen Parameter hinterlegen.
Daten in übergeordneten Gruppen werden an untergeordnete Gruppen vererbt und können auf der Ebene von untergeordneten Gruppen überschrieben werden.

Generell kann man Ansible UND Puppet gleichzeitg verwenden.
Hier sollte sichergestellt sein, dass sich Einstellungen nicht überschneiden oder inkompatibel zueinander sind.

Anlegen der Hostgroups "Development" und "Development/Container".

## Automatisch Nodes in Hostgruppen hinterlegen

Damit Nodes autoatmisch in eine Hostgruppe aufgenommen werden, benötigen wir ein Plugin: default hostgroup

Installation:

    foreman-installer --scenario katello -i

Auswaehlen des Plugins:

    24. [✗] Configure foreman_plugin_default_hostgroup

`61. Save and run` aswaehlen.

Wenn hier ein Fahler kommt:

    Error while evaluating a Method call, Class[Foreman::Plugin::Default_hostgroup]: parameter 'hostgroups' index 0 entry '[]' expects a Hash value, got Undef

Bug bei Foreman: <https://projects.theforeman.org/issues/31462>

Dann das RPM Paket installieren:

    yum install tfm-rubygem-foreman_default_hostgroup.noarch
    foreman-rake db:migrate
    foreman-maintain service restart --only foreman

Nach der Installation muss das Plugin konfiguriert werden:

In der Konfigurationsdatei wird folgende generelle Syntax erwartet:

    :default_hostgroup:
      :facts_map:
        <hostgroup>:
          <fact_name>: <regex>

Beispiel:

    # /etc/foreman/plugins/default_hostgroup.yaml
    ---
    :default_hostgroup:
      :facts_map:
        "Development/Container"
          "stage": "dev"
          "role": "docker"
        "Development":
          "stage": "dev"
        "Produktion":
          "stage": "prod"
        "Default":
          "hostname": ".*"

Wichtig: nach Änderungen an der Datei muss der Foreman Service neu gestartet werden: `foreman-maintain service restart --only foreman`.

## Facts auf Hosts setzen

### Puppet Facts

Puppet Facts können als YAML oder JSON Datei angegeben werden:

    # /etc/puppetlabs/facter/facts.d/foreman_default_hostgroup.yaml
    ---
    stage: 'dev'
    role: 'docker'

### Ansible Facts

Ansible Facts können als JSON oder INI Datei angegeben werden:

    # /etc/ansible/facts.d/foreman_default_hostgroup.fact
    {
        stage: "dev",
        role: "docker"
    }

### RedHat Subscription Manager

Um mit dem Subscription Manager Facts zu setzen, muss eine Datei angelegt werden:

    # /etc/rhsm/facts/<dateiname>.facts

Beispiel:

    # /etc/rhsm/facts/hostgroup_name.facts
    {  
      "stage": "dev",
      "role": "docker"
    }

## Initialer Puppet Lauf

    vagrant up docker.betadots.training
    vagrant ssh docker.betadots.training
    sudo -i
    puppet agent --test 

## Puppet Zertifikat signieren

    Foreman Login
      -> Infrastructure
        -> Smart Proxies
          -> foreman.betadots.training

    Puppet CA
      -> Orange Klicken
        -> Sign

## Apache

    vagrant up apache.betadots.training

Schritte von vorher wiederholen.

Weiter geht es mit [Teil 4 Provisionierung CentOS](../04_provisioning_centos)
