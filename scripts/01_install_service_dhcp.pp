$cfg_base_dir = '/vagrant_foreman/vagrant/config_files'

# dhcp
package { 'dhcp':
  ensure => present,
}
file { '/etc/dhcp':
  ensure => directory,
  mode   => '0755',
}
file { '/etc/dhcp/Komapi_key.+157+24472.key':
  ensure => file,
  source => "${cfg_base_dir}/Komapi_key.key",
}
file { '/etc/dhcp/Komapi_key.+157+24472.private':
  ensure => file,
  source => "${cfg_base_dir}/Komapi_key.private",
}
file { '/etc/dhcp/dhcpd.conf':
  ensure => file,
  source => "${cfg_base_dir}/dhcpd.conf",
  notify => Service['dhcpd'],
}
service { 'dhcpd':
  enable => true,
  ensure => running,
}

