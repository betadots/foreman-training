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
file { '/etc/named/Kforeman.training.example42.com.+157+55347.key':
  ensure  => file,
  content => 'foreman.training.example42.com. IN KEY 512 3 157 9KC4RZuKpIvs+HAtGOFp4vSjD1z+GleFoj6H8Exft04c5geo/U/ppYLC 1I3NME5qmlnXLcvNElvUAFTtWtUsTw==',
  mode    => '0600',
  notify  => Service['named'],
}
file { '/etc/named/Kforeman.training.example42.com.+157+55347.private':
  ensure => file,
  source => "${cfg_base_dir}/Kforeman.training.example42.com.private",
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
