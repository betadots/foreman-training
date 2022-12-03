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
  group   => 'foreman-proxy'
}
service { 'tftp.service':
  ensure => running,
  enable => true,
}
