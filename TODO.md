Vagrantfile:
- check for plugins
- check vagrant on Linux, eth1 missing
- iptables postrouting permanent machen

Preparation for Training:
- vagrant box install centos/7
- use internal mirror

TFTP:
- woher kommen die Images?

Training:
- start minimal, without Puppet server - not possible
- differentiate strictly between Puppet agent (foreman-installer) and Puppet Server (cfgmgmt)

BIND:
- zonefiles mit db.
- vagrant als DNS upstream
- all in one (named.conf)


Hammer CLI
Freestyle
RBAC + Self Service

Ordering:
Day 1: vormittag
0. installation
1. show provisioning (base os)

Day 1: nachmittag
2. provision for Debian/Ubuntu

3. show cfgmgmt (Apache/MySQL)
4. show deprovisioning

Day 2: vormittag
5. create compute resource (by participants)

Day 2: nachmittag
6. CLI
7. Plugins
8. Self Service / RBAC

x. Integration in bestehende Infrastruktur
  - DNS delegation
  - subnetting
  - AD/LDAP

y. Backup/Recovery


