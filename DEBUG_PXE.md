# Debug PXE

Meistens gibt es Fehler im Kickstart File.

Kickstart Datei holen:

curl 'http://foreman.example42.training/unattended/provision/?token=cd1e1fc5-1881-4c47-8513-405acebe1a1e'

Beispiel:

    install
    url --url http://mirror.centos.org/centos/7.3.1611/os/x86_64
    lang en_US.UTF-8
    selinux --enforcing
    keyboard us
    skipx

    network --bootproto dhcp --hostname docker.example42.training --device=08:00:27:62:6a:19
    rootpw --iscrypted $5$WqZcimGL$ZdHoU3.WMENAnxSb3RbNRL2RovmpXYWum1U9jn61u68
    firewall --service=ssh
    authconfig --useshadow --passalgo=SHA256 --kickstart
    timezone --utc UTC
    services --disabled gpm,sendmail,cups,pcmcia,isdn,rawdevices,hpoj,bluetooth,openibd,avahi-daemon,avahi-dnsconfd,hidd,hplip,pcscd

    bootloader --location=mbr --append="nofb quiet splash=quiet"

    zerombr
    clearpart --all --initlabel
    autopart

    text
    reboot

    %packages
    yum
    dhclient
    ntp
    wget
    @Core
    redhat-lsb-core
    %end

    %post --nochroot
    exec < /dev/tty3 > /dev/tty3
    #changing to VT 3 so that we can see whats going on....
    /usr/bin/chvt 3
    (
    cp -va /etc/resolv.conf /mnt/sysimage/etc/resolv.conf
    /usr/bin/chvt 1
    ) 2>&1 | tee /mnt/sysimage/root/install.postnochroot.log
    %end
    %post
    logger "Starting anaconda docker.example42.training postinstall"
    exec < /dev/tty3 > /dev/tty3
    #changing to VT 3 so that we can see whats going on....
    /usr/bin/chvt 3
    (

    #  interface
    real=`ip -o link | awk '/08:00:27:62:6a:19/ {print $2;}' | sed s/:$//`
    sanitized_real=`echo $real | sed s/:/_/`

    cat << EOF > /etc/sysconfig/network-scripts/ifcfg-$sanitized_real
    BOOTPROTO="dhcp"
    DEVICE=$real
    HWADDR="08:00:27:62:6a:19"
    ONBOOT=yes
    PEERDNS=yes
    PEERROUTES=yes
    DEFROUTE=yes
    EOF

    #update local time
    echo "updating system time"
    /usr/sbin/ntpdate -sub 0.fedora.pool.ntp.org
    /usr/sbin/hwclock --systohc

    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

    # update all the base packages from the updates repository
    if [ -f /usr/bin/dnf ]; then
      dnf -y update
    else
      yum -t -y update
    fi

    # SSH keys setup snippet for Remote Execution plugin
    #
    # Parameters:
    #
    # remote_execution_ssh_keys: public keys to be put in ~/.ssh/authorized_keys
    #
    # remote_execution_ssh_user: user for which remote_execution_ssh_keys will be
    #                            authorized
    #
    # remote_execution_create_user: create user if it not already existing
    #
    # remote_execution_effective_user_method: method to switch from ssh user to
    #                                         effective user
    #
    # This template sets up SSH keys in any host so that as long as your public
    # SSH key is in remote_execution_ssh_keys, you can SSH into a host. This only
    # works in combination with Remote Execution plugin.
    # The Remote Execution plugin queries smart proxies to build the
    # remote_execution_ssh_keys array which is then made available to this template
    # via the host's parameters. There is currently no way of supplying this
    # parameter manually.
    # See http://projects.theforeman.org/issues/16107 for details.

    if [ -f /usr/bin/dnf ]; then
      dnf -y install puppet
    else
      yum -t -y install puppet
    fi

    cat > /etc/puppet/puppet.conf << EOF

    [main]
    vardir = /var/lib/puppet
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = \$vardir/ssl

    [agent]
    pluginsync      = true
    report          = true
    ignoreschedules = true
    ca_server       = foreman.example42.training
    certname        = docker.example42.training
    environment     = production
    server          = foreman.example42.training

    EOF

    puppet_unit=puppet
    /usr/bin/systemctl list-unit-files | grep -q puppetagent && puppet_unit=puppetagent
    /usr/bin/systemctl enable ${puppet_unit}
    /sbin/chkconfig --level 345 puppet on

    # export a custom fact called 'is_installer' to allow detection of the installer environment in Puppet modules
    export FACTER_is_installer=true
    # passing a non-existent tag like "no_such_tag" to the puppet agent only initializes the node
    /usr/bin/puppet agent --config /etc/puppet/puppet.conf --onetime --tags no_such_tag --server foreman.example42.training --no-daemonize

    sync

    # Inform the build system that we are done.
    echo "Informing Foreman that we are built"
    wget -q -O /dev/null --no-check-certificate http://foreman.example42.training/unattended/built?token=cd1e1fc5-1881-4c47-8513-405acebe1a1e
    ) 2>&1 | tee /root/install.post.log
    exit 0
