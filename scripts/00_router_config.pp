file { '/etc/sysctl.d/99-router.conf':
  content => "net.ipv4.ip_forward=1\n",
  notify  => Exec['sysctl reload'],
}
exec { 'sysctl reload':
  command     => '/sbin/sysctl -p /etc/sysctl.d/99-router.conf',
  refreshonly => true,
}

file { '/etc/gateway_config':
  ensure => file,
  notify => [
    Exec['iptables postrouting'],
    Exec['iptables forward'],
    Exec['iptables forward established'],
  ],
}

exec { 'iptables postrouting':
  command     => '/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE',
  refreshonly => true,
}

exec { 'iptables forward':
  command     => '/sbin/iptables -A FORWARD -i eth1 -j ACCEPT',
  refreshonly => true,
}

exec { 'iptables forward established':
  command     => '/sbin/iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT',
  refreshonly => true,
}
