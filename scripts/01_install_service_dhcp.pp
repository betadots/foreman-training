$cfg_base_dir = '/vagrant_foreman/vagrant/config_files'

# dhcp
package { 'dhcp':
  ensure => present,
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

