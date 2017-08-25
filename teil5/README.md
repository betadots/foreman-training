# Katello

Es wird abgeraten katello auf einem existierenden Foreman Setup hinzuzufuegen.

Statt dessen soll katello vor der foreman installation vorbereitet werden:

1. Yum Pakete

    yum -y localinstall http://fedorapeople.org/groups/katello/releases/yum/3.4/katello/el7/x86_64/katello-repos-latest.rpm
    yum -y localinstall http://yum.theforeman.org/releases/1.15/el7/x86_64/foreman-release.rpm
    yum -y localinstall https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm # will install with Puppet 4
    yum -y localinstall http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum -y install foreman-release-scl

    yum -y update

    yum -y install katello

2. Foreman installer

    foreman-installer --scenario katello --help

WICHTIG: Vor der Installation muss die Uhrzeit bereits korrekt gesetzt sein!

Alternativ kann man vor der Installation das Answer File bearbeiten:
/etc/foreman-installer/scenarios.d/katello-answers.yaml

3. Vagrant

    vagrant up katello.example42.training

