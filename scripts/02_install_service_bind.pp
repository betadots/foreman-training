$cfg_base_dir = '/vagrant_foreman/vagrant/config_files'

# bind
package { ['bind', 'bind-utils']:
  ensure => present,
}
file { '/etc/named.conf':
  ensure => file,
  source => "${cfg_base_dir}/named.conf",
  notify => Service['named'],
}
file { '/etc/named.foreman.zones':
  ensure => file,
  source => "${cfg_base_dir}/named.foreman.zones",
  notify => Service['named'],
}
file { '/var/named/Kforeman.training.+157+12851.key':
  ensure => file,
  source => "${cfg_base_dir}/Kforeman-training.key",
  mode   => '0600',
  notify => Service['named'],
}
file { '/var/named/Kforeman.training.+157+12851.private':
  ensure => file,
  source => "${cfg_base_dir}/Kforeman-training.private",
  mode   => '0600',
  notify => Service['named'],
}
file { '/var/named/foreman_domain':
  ensure => file,
  source => "${cfg_base_dir}/foreman_domain",
  owner  => 'named',
  group  => 'named',
  notify => Service['named'],
}
file { '/var/named/foreman_provision_domain':
  ensure => file,
  source => "${cfg_base_dir}/foreman_provision_domain",
  owner  => 'named',
  group  => 'named',
  notify => Service['named'],
}
file { '/var/named/foreman_ip':
  ensure => file,
  source => "${cfg_base_dir}/foreman_ip",
  owner  => 'named',
  group  => 'named',
  notify => Service['named'],
}
service { 'named':
  ensure => running,
  enable => true,
}

# resolv.conf
file { '/etc/resolv.conf':
  ensure => file,
  source => "${cfg_base_dir}/resolv.conf",
}
file { '/etc/rndc.key':
  ensure => file,
  mode   => '0644',
}
