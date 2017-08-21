# Foreman Training - Teil 1 - Smart Proxies

Smart-Proxy ist ein Service, der auf einem System laeuft, welches Infrastruktur Komponenenten bereitstellt.
Dazu gehoeren zum Beispiel:

  - Puppet Server
  - DHCP Server
  - TFTP Server
  - DNS Server


## Smart proxies

Foreman Login -> Infrastructure -> Smart proxies

Actions -> Refresh

Klick auf 'foreman.example42.training'

Auf aktive Services und Fehler pruefen.

### Puppet Environments

    puppet module install garethr-docker
    puppet module install puppetlabs-ntp

Foreman Login -> Configure -> Puppet Environments -> 'Import environments from foreman.example42.training'

Haken setzen -> Update

### Netzwerk

Foreman Login -> Infrastructure -> Subnets -> Create Subnet

Tab Subnet: Name: example42.training
Tab Subnet: Network Address: 10.100.10.0
Tab Subnet: Network Prefix: 24
Tab Subnet: Primary DNS Server: 10.100.10.101
Tab Subnet: IPAM: DHCP
Tab Subnet: Start of IP Range: 10.100.10.120
Tab Subnet: End of IP Range: 10.100.10.240

Tab Domains: Auswaehlen 'example42.training'

Tab Proxies: DHCP, TFTP und DNS Proxy (Smart Proxy): foreman.example42.training

Submit

### Domain

Foreman Login -> Infrastructure -> Domains

DNS Proxy -> 'foreman.example42.training' -> Submit


