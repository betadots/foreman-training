# Foreman Training

## Initialisieren:

Es werden zwei Vagrant Plugins eingesetzt:

    vagrant plugin install vagrant-hostmanager
    vagrnat plugin install vagrant-vbguest

Jetzt kann die VM instantiiert werden:

    cd vagrant
    vagrant up foreman.example42.training

Danach Login:

    vagrant ssh foreman.example42.training
    sudo -i
    foreman-installer -i

Den Output sichern. z.B.:

      Success!
      * Foreman is running at https://foreman.example42.training
          Initial credentials are admin / DhXNVncksVCTxSrF
      * Foreman Proxy is running at https://foreman.example42.training:8443
      * Puppetmaster is running at port 8140
      The full log is at /var/log/foreman-installer/foreman.log

Nun muessen die Dienste konfiguriert werden:

    puppet apply /vagrant_foreman/scripts/01_install_service_dhcp.pp
    puppet apply /vagrant_foreman/scripts/02_install_service_bind.pp
    puppet apply /vagrant_foreman/scripts/03_foreman_proxy.pp


## Foreman Einrichtung fertigstellen


