$cfg_base_dir = '/vagrant_foreman/vagrant/config_files'

# Router config

file { '/etc/sysctl.d/99-router.conf':
  ensure  => file,
  content => "net.ipv4.ip_forward=1\n",
  notify  => Exec['sysctl reload'],
}
exec { 'sysctl reload':
  command     => '/sbin/sysctl -p /etc/sysctl.d/99-router.conf',
  refreshonly => true,
}

packge { 'dos2unix':
  ensure => present,
}
file { '/etc/sysconfig/iptables':
  ensure => file,
  source => "${cfg_base_dir}/iptables.sysconfig",
  notify => Exec['dos2unix iptables'],
}
exec { 'dos2unix iptables':
  command     => '/bin/dos2unix /etc/sysconfig/iptables',
  refreshonly => true,
  notify      => Exec['restore iptables'],
}
exec { 'restore iptables':
  command     => '/bin/cat /etc/sysconfig/iptables | /sbin/iptables-restore',
  refreshonly => true,
}

# DHCPD
package { 'dhcp-server':
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
  ensure => running,
  enable => true,
}

# BIND Named
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
file { '/etc/rndc.key':
  ensure => file,
  mode   => '0644',
}

# TFTP
$packages = [
  'tftp-server',
  'syslinux-tftpboot',
]
package { $packages:
  ensure => present,
}
$dirs = [
  '/var/lib/tftpboot/grub2',
  '/var/lib/tftpboot/grub',
  '/var/lib/tftpboot/boot',
  '/var/lib/tftpboot/pxelinux.cfg',
]
file { $dirs:
  ensure  => directory,
  recurse => true,
  owner   => 'foreman-proxy',
  group   => 'foreman-proxy',
}
service { 'tftp.service':
  ensure => running,
  enable => true,
}

# Foreman Smart-Proxy
file { '/etc/rndc_foreman.key':
  ensure => file,
  source => '/etc/rndc.key',
  mode   => '0644',
  #  notify => Service['foreman-proxy'],
}

#$foreman_proxy_files = [
#  'dhcp.yml',
#  'dhcp_isc.yml',
#  'dns.yml',
#  'dns_nsupdate.yml',
#  'tftp.yml',
#]

#$foreman_proxy_files.each |$foreman_proxy| {
#  file { "/etc/foreman-proxy/settings.d/${foreman_proxy}":
#    ensure => file,
#    source => "${cfg_base_dir}/foreman-proxy/${foreman_proxy}",
#    notify => Service['foreman-proxy'],
#  }
#}

#service { 'foreman-proxy':
#  ensure => running,
#  enable => true,
#}
