$cfg_base_dir = '/vagrant_foreman/vagrant/config_files'

file { '/etc/sysctl.d/99-router.conf':
  ensure  => file,
  content => "net.ipv4.ip_forward=1\n",
  notify  => Exec['sysctl reload'],
}
exec { 'sysctl reload':
  command     => '/sbin/sysctl -p /etc/sysctl.d/99-router.conf',
  refreshonly => true,
}

file { '/etc/sysconfig/iptables':
  ensure => file,
  source => "${cfg_base_dir}/iptables.sysconfig",
  notify => Exec['restore iptables'],
}

exec { 'restore iptables':
  command     => '/bin/cat /etc/sysconfig/iptables | /sbin/iptables-restore',
  refreshonly => true,
}
