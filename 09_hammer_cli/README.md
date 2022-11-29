# Foreman Training - Teil 9 - Hammer CLI/API

Foreman Config von der Kommandozeile

## Hammer CLI

### Konfiguration

Die Konfiruration wird pro User hinterlegt.

`.hammer/cli.modules.d/foreman.yml`
    :foreman:
      # Credentials. You'll be asked for the interactively if you leave them blank here
      :username: 'admin'
      :password: '12345678'

      # Check API documentation cache status on each request
      :refresh_cache: false

      # API request timeout in seconds, set -1 for infinity
      :request_timeout: 120

### hammer Kommando

`hammer`

Beispiel:

    hammer host list
    ---|----------------------------|------------------|------------|---------------|-------------------|---------------|----------------|----------------------
    ID | NAME                       | OPERATING SYSTEM | HOST GROUP | IP            | MAC               | GLOBAL STATUS | CONTENT VIEW   | LIFECYCLE ENVIRONMENT
    ---|----------------------------|------------------|------------|---------------|-------------------|---------------|----------------|----------------------
    2  | apache.betadots.training  | CentOS 7.9       |            | 10.100.10.104 | 08:00:27:75:19:a8 |  Warning       | Composite View | Produktion
    1  | foreman.betadots.training | CentOS 7.9.2009  |            | 10.0.2.15     | 52:54:00:4d:77:d3 | OK            | Composite View | Produktion
    ---|----------------------------|------------------|------------|---------------|-------------------|---------------|----------------|----------------------

## API

https://apidocs.theforeman.org/foreman/3.4/apidoc/v2.html

    curl --user admin:changeme -H "Content-Type:application/json" -H "Accept:application/json" -k -X GET -d '{"search":"build = true and os = CentOS"}' https://foreman.betadots.training/api/v2/hosts

Die 'search' Argumente am Besten aus dem Foreman Webinterface erzeugen.

Weiter mit Teil 10 [Maintenance](../10_maintenance)
