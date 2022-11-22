# ToDo List

Vagrantfile:

- check vagrant on Linux, eth1 missing
- iptables postrouting permanent machen

Puppet Code:

- provision subdomain wird nicht mehr benoetigt

PDF Dokument:

- technischer Aufbau Katello (Aufbau und Funktion)
- welche Technologien stehen hinter Katello
- Foreman Puppet 7?
- Content: Uebersicht ueber die einzelnen Bestandteile (product, lifecycle env, content view, activation key) als grafik, ablauf plan
- Provisioning: Erklaerung der einzelen Bestandteile (DOmain, Subnet, Provisioning Templates, Installation media -> Hostgroups)

00 code anleitungen

- host und katello aus vagrant config raus

01 Formean installer

- running: gehort in den code block
- locale anpassen Oben rechts -> Einstellungen -> Browser Sprache -> English (oder hammer cli)

02 content:

- docker product/repo?

03 Configmanagement:

- Initialer Puppet Lauf an neue umgebung anpassen
 vorher vagrant up docker.betadots.training
 und integration in Katello/Foreman

04 provisioning

- Erklaerung der einzelen Bestandteile (DOmain, Subnet, Provisioning Templates, Installation media -> Hostgroups)

07 Compute Resources:

- Docker raus und erklaerung
- kubevirt aufnehmen
- aws demo?
- libvirt/kvm?

09 hammer cli

- mehr Beispiele mit wehcsle shell -> browser

10 maintenance

- upgrade to katello 4

    yum localinstall https://yum.theforeman.org/releases/2.4/el7/x86_64/foreman-release.rpm
    yum localinstall https://yum.theforeman.org/katello/4.0/katello/el7/x86_64/katello-repos-latest.rpm
    yum localinstall https://yum.puppet.com/puppet6-release-el-7.noarch.rpm

Foreman Client Repo aktualisieren!

    yum clean all
    yum update -y

    foreman-installer --scenario katello -i

11 mandanten

- vor maintenance

12 plugins

- vorziehen
- erklären foreman-installer und reset foreman-proxy einstellungen
- foreman-proxy config aus puppet raus in den installer uebernehmen

