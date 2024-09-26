#!/bin/bash
sed -i -e "/127.0.1.1 fore/d" /etc/hosts

    foreman-installer --scenario katello \
        --enable-foreman-plugin-remote-execution \
        --enable-foreman-proxy-plugin-remote-execution-script \
        --enable-foreman-cli-remote-execution \
        --enable-foreman-cli-tasks --enable-foreman-plugin-tasks \
        --tuning development \
        --enable-foreman-plugin-ansible \
      --enable-foreman-proxy-plugin-ansible \
      --enable-foreman-cli-ansible \
      --enable-foreman-plugin-puppet \
      --enable-foreman-cli-puppet \
      --foreman-proxy-puppet true \
      --foreman-proxy-puppetca true \
      --enable-puppet \
      --puppet-server true \
      --puppet-server-foreman-ssl-ca /etc/pki/katello/puppet/puppet_client_ca.crt \
      --puppet-server-foreman-ssl-cert /etc/pki/katello/puppet/puppet_client.crt \
      --puppet-server-foreman-ssl-key /etc/pki/katello/puppet/puppet_client.key

    exit 0

### DHCPD

    foreman-installer --foreman-proxy-dhcp true \
        --foreman-proxy-dhcp-config /etc/dhcp/dhcpd.conf \
        --foreman-proxy-dhcp-leases /var/lib/dhcpd/dhcpd.leases \
        --foreman-proxy-dhcp-omapi-port 7911 \
        --foreman-proxy-dhcp-server 10.100.10.101 \
        --foreman-proxy-dhcp-interface eth1 \
        --foreman-proxy-dhcp-managed false \
        --foreman-proxy-dhcp-provider isc

### DNS

    foreman-installer --foreman-proxy-dns true \
        --foreman-proxy-dns-provider nsupdate \
        --foreman-proxy-dns-ttl 86400 \
        --foreman-proxy-dns-managed false \
        --foreman-proxy-dns-server 127.0.0.1 \
        --foreman-proxy-keyfile /etc/rndc.key

### TFTP

    foreman-installer --foreman-proxy-tftp true \
        --foreman-proxy-tftp-managed false \
        --foreman-proxy-tftp-root /var/lib/tftpboot/ \
        --foreman-proxy-tftp-servername foreman.betadots.training
