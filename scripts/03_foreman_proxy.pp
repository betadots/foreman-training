$cfg_base_dir = '/vagrant_foreman/vagrant/config_files'

file { '/etc/rndc_foreman.key':
  ensure => file,
  source => '/etc/rndc.key',
  mode   => '0644',
  notify => Service['foreman-proxy'],
}

$foreman_proxy_files = [
  'dhcp.yml',
  'dhcp_isc.yml',
  'dns.yml',
  'dns_nsupdate.yml',
  'tftp.yml',
]

$foreman_proxy_files.each |$foreman_proxy| {
  file { "/etc/foreman-proxy/settings.d/${foreman_proxy}":
    ensure => file,
    source => "${cfg_base_dir}/foreman-proxy/${foreman_proxy}",
    notify => Service['foreman-proxy'],
  }
}

service { 'foreman-proxy':
  ensure => running,
  enable => true,
}
