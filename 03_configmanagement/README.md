# Foreman Training - Teil 3 - Configuration Management

Mit Foreman kann man Konfigurationsmanagement verwalten.
Es werden die folgenden CfgMgmt unterstuetzt:
- Puppet
- Ansible
- Chef
- Salt

Im Training gehen wir auf Ansible und Puppet ein.

## Puppet Environments

Zuerst installieren wir 2 Puppet Module:

    puppet module install puppetlabs-docker
    puppet module install puppetlabs-apache
    puppet module install puppetlabs-ntp

Jetzt werden die Module in Foreman bekannt gemacht:

Foreman Login -> Configure -> Puppet -> Environments -> 'Import environments from foreman.example42.training'

Haken setzen -> Update

## Ansible Roles

Zuerst installieren wir 3 Ansible Rollen:

    ansible-galaxy install geerlingguy.docker -p /etc/ansible/roles
    ansible-galaxy install geerlingguy.apache -p /etc/ansible/roles
    ansible-galaxy install frzk.chrony -p /etc/ansible/roles

Danach werden die Rollen Foreman bekannt gemacht:

Foreman Login -> Configure -> Ansible -> Roles -> 'Import from foreman.example42.training'

Haken setzen -> Update

## Hosts Konfigurieren

Mit Puppet oder Ansible koennen Systeme eingerichtet werden.
Dazu gehoeren zu Beispiel die Installation und Konfiruation von Paketen und Diensten.

Foreman Login -> Hosts -> All Hosts -> Edit

### Ansible

Im Tab "Ansible Roles" die Ansible Rollen auswaehlen, die der Host bekommen soll (hier: frzk.chrony)

Im Tab "Parameter" koennen Rollenspezifische Daten gesetzt werden.

Host Parameter -> Add Parameter

Name: chrony_ntp_servers
Type: Array
Value: ['pool.ntp.org']

Submit

### Puppet

Im Tab "Host" muss das gewuenschte Puppet Environment (Produktion), der Puppet Proxy und Puppet CA Proxy ausgewaehlt werden.
Im Tab "Puppet Classes" koennen dann Puppet Klassen ausgewaehlt werden (Docker Baum oeffnen, Docker auswaehlen).

Submit

### Globale Defaults (Smart Class Variables)

Foreman Login -> Configure -> Smart Class Parameters

search:  `puppetclass =  docker and  parameter =  tcp_bind`

Klick auf tcp_bind

Default behavior:
-  Override: OK
-  Key type: string
-  Default value: `'tcp://0.0.0.0:4243'`

Submit

### Config Management starten

In der Host Ansicht (Foreman Login -> All Hosts -> Edit) kann man unter "Schedule Remote Job" wahlweise das Starten des Puppet Agent ("Run Puppet Once") oder das Abarbeiten des Ansible Codes ("Run Ansible Roles") starten.

## Host Groups

Wenn man viele Systeme hat, die eventuell gleiche Funktionalitaet haben, kann man Hostgruppen anlegen:

Foreman Login -> Configure -> Host Groups -> Create Host Group

Hierbei ist es wichtig, dass man sich erst eine Uebersicht ueber die eigene Infrastruktur erstellt hat, bevor man mit Hostgruppen anfaengt.
Ein Host kann nur in eine Hostgruppe aufgenommen werden!!

Generell gibt es 4 grobe Ansaetze zum Erzeugen von Hostgruppen:

- Flache Sturktur
- Lifecycle Environment basierte Struktur
- Applikationsbasierte Struktur
- Lokationsbasierte Struktur

| Flach               | Environment              | Applikation                   | Lokation                     |
|---------------------|--------------------------|-------------------------------|------------------------------|
| dev-infra-git-rhel7 | **dev**                  | **acmeweb**                   | **Munich**                       |
| qa-infra-git-rhel7  | *dev*/**rhel7**          | *acmeweb*/**frontend**        | *Munich*/**web-dev**             |
| prod-infra-git-rhel7| *dev/rhel7*/**git**      | *acmeweb/frontend*/**web-dev**| *Munich/web-dev*/**web-frontend**|
|                     | *dev/rhel7*/**container**| *acmeweb/frontend*/**web-qa** | *Munich/web-dev*/**web-backend** |
|                     | *dev*/**rhel6**          | *acmeweb*/**backend**         | *Munich*/**web-qa**              |
|                     | *dev/rhel6*/**loghost**  | *acmeweb/backend*/**web-dev** | *Munich/web-qa*/**web-frontend** |
|                     | **qa**                   | **infra**                     | **Boston**                       |

(Quelle: https://access.redhat.com/documentation/en-us/red_hat_satellite/6.7/html/planning_for_red_hat_satellite/chap-red_hat_satellite-architecture_guide-host_grouping_concepts)

Alternativ kann man auch die Foreman Locations nutzen. Aktuell haben wir nur eine Default Location

Jeder Hostgruppe koennen dann Ansible Rollen, Puppet Klassen und die dazugeoerigen Parameter hinterlegen.
Daten in uebergeordneten Gruppen werden an untergeordnete Gruppen vererbt und koennen auf der Ebene von untergeordneten Gruppen ueberschrieben werden.

Generell kann man Ansible UND Puppet gleichzeitg verwenden.
Hier sollte sichergestellt sein, dass sich Einstellungen nicht überschneiden oder inkompatibel zueinander sind.

## Automatisch Nodes in Hostgruppen hinterlegen

Damit Nodes autoatmisch in eine Hostgruppe aufgenommen werden, benoetigen wir ein Plugin: default hostgroup

Installation:

    foreman-installer --scenario katello -i

Auswaehlen des Plugins:

    24. [✗] Configure foreman_plugin_default_hostgroup

`61. Save and run` aswaehlen.

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
        "Produktion":
          "stage": "prod"
        "Default":
          "hostname": ".*"

Wichtig: nach Änderungen an der Datei muss der Foreman Service neu gestartet werden: `systemctl restart foreman`.

## Facts auf Hosts setzen

### Puppet

Puppet Facts koennen als YAML oder JSON Datei angegeben werden:

    # /etc/puppetlabs/facter/facts.d/foreman_default_hostgroup.yaml
    stage: 'prod'

### Ansible

Ansible Facts koennen als JSON oder INI Datei angegeben werden:

    # /etc/ansible/facts.d/foreman_default_hostgroup.fact
    {
        stage: 'prod'
    }

### RedHat Subscription Manager

Um mit dem Subscription Manager Facts zu setzen, muss eine Datei angelegt werden:

    # /etc/rhsm/facts/<dateiname>.facts

Beispiel:

    # /etc/rhsm/facts/hostgroup_name.facts
    {  
      "stage": "prod"
    }

## Puppet Zertifikat signieren:

Foreman Login -> Infrastructure -> Smart Proxies -> foreman.example42.training

Puppet CA -> Orange Klicken -> Sign

## Initialer Puppet Lauf

    vagrant ssh docker.example42.training
    sudo -i
    puppet agent --test 


## Apache

    vagrant up apache.example42.training

Schritte von vorher wiederholen.

Weiter geht es mit [Teil 4 Provisionierung CentOS](../04_provisioning_centos)