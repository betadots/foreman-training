$cfg_base_dir = '/vagrant_foreman/vagrant/config_files'
file { '/etc/dhcp/dhcpd.conf':
  ensure => file,
  source => "${cfg_base_dir}/dhcpd.conf.katello",
  notify => Service['dhcpd'],
}
service { 'dhcpd':
  ensure => running,
  enable => true,
}

$foreman_proxy = [ 'dhcp', 'tftp' ]
$foreman_proxy.each |$proxy| {
  file { "/etc/foreman-proxy/settings.d/${proxy}.yml":
    ensure => file,
    source => "${cfg_base_dir}/foreman-proxy/${proxy}.yml.katello",
    notify => Service['foreman-proxy'],
  }
}
service { 'foreman-proxy':
  ensure => running,
  enable => true,
}

file { '/etc/named.conf':
  ensure => file,
  source => "${cfg_base_dir}/named.conf.katello",
  notify => Service['named'],
}
file { '/etc/named.foreman.zones':
  ensure => file,
  source => "${cfg_base_dir}/named.foreman.zones.katello",
  notify => Service['named'],
}
$zones = [ 'domain', 'ip', 'provision_domain']
$zones.each |$zone| {
  file { "/var/named/foreman_${zone}":
    ensure => file,
    source => "${cfg_base_dir}/foreman_${zone}.katello",
    notify => Service['named'],
  }
}
service { 'named':
  ensure => running,
  enable => true,
}

file { '/etc/resolv.conf':
  ensure   => file,
  source => "${cfg_base_dir}/resolv.conf.katello",
}
