# Foreman Training - Teil 12 - Integration in bestehende Infrastruktur (optional)

## Zusaetzliche Foreman Smart Proxies

### Ohne Content Proxy

siehe [Installing an External Smart Proxy Server 3.4](https://docs.theforeman.org/3.4/Installing_Proxy/index-foreman-el.html)

ACHTUNG! LOCALE!

    export LANG=en_US.UTF-8
    dnf install https://yum.theforeman.org/releases/3.4/el8/x86_64/foreman-release.rpm
    dnf install https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
    dnf module enable foreman:el8
    dnf install foreman-installer
    foreman-installer \
      --no-enable-foreman \
      --no-enable-foreman-cli \
      --enable-puppet \
      --puppet-server-ca=false \
      --puppet-server-foreman-url=https://foreman.betadots.training \
      --enable-foreman-proxy \
      --foreman-proxy-puppetca=false \
      --foreman-proxy-tftp=false \
      --foreman-proxy-foreman-base-url=https://foreman.betadots.training \
      --foreman-proxy-trusted-hosts=foreman.betadots.training \
      --foreman-proxy-oauth-consumer-key=oAuth_Consumer_Key \
      --foreman-proxy-oauth-consumer-secret=oAuth_Consumer_Secret

Die Werte für `oAuth_Consumer_Key` und `oAuth_Consumer_Secret` können am Foreman Server aus der Dateei `/etc/foreman-installer/scenarios.d/katello-answers.yaml` ausgelesen werden.

### Mit Content Proxy

Siehe [Installing an External Smart Proxy Server 3.4](https://docs.theforeman.org/3.4/Installing_Proxy/index-katello.html)

Bitte unbedingt eine 2. Festapltte einhängen!! Im Training: 100 GB
Mount nach `/var/lib/pulp`

Optional kann der neue Smart Proxy am Katello als Content Host registriert werden.

Installation:
ACHTUNG: LOCALE

    export LANG=en_US.UTF-8
    dnf install https://yum.theforeman.org/releases/3.4/el8/x86_64/foreman-release.rpm
    dnf -y localinstall https://yum.theforeman.org/katello/4.6/katello/el8/x86_64/katello-repos-latest.rpm
    dnf install https://yum.puppet.com/puppet7-release-el-8.noarch.rpm
    dnf config-manager --set-enabled powertools
    dnf -y module enable katello:el8 pulpcore:el8
    dnf install foreman-proxy-content

Jetzt muss man am Foreman/Katello Server die Zertifikate erzeugen:

    foreman-proxy-certs-generate \
      --foreman-proxy-fqdn <FQDN> \
      --certs-tar /root/<FQDN>-certs.tar

Dieses Kommando zeigt danach an, was man als nächste machen muss:

1. Cert Tar Archiv uf Ziel System kopieren
2. foreman-installer aufrufen

Commands:

    scp /root/<FQDN>-certs.tar root@<FQDN>:/root/<FQDN>-certs.tar
    foreman-installer --scenario foreman-proxy-content \
      --certs-tar-file "/root/<FQDN>-certs.tar" \
      --foreman-proxy-register-in-foreman "true" \
      --foreman-proxy-foreman-base-url "https://foreman.betadots.training" \
      --foreman-proxy-trusted-hosts "foreman.betadots.training" \
      --foreman-proxy-trusted-hosts "<FQDN>" \
      --foreman-proxy-oauth-consumer-key "s97QxvUAgFNAQZNGg4F9zLq2biDsxM7f" \
      --foreman-proxy-oauth-consumer-secret "6bpzAdMpRAfYaVZtaepYetomgBVQ6ehY" \
      --puppet-server-foreman-url "https://foreman.betadots.training"

Achtung: das Cert Tar Archive auf dem System belassen, damit man Upgrades machen kann!!

## Netzwerk

## Provisionierung

## existierende Systeme

## DNS delegation

Weiter mit Teil 9 [Hammer CLI/API](../09_hammer_cli)
