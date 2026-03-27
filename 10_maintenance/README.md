# Foreman Training - Teil 10 - Backup und Recovery (optional)

## Upgrade

Prüfen, welche Versionen zur Verfügung stehen

    foreman-maintain upgrade list-versions

Upgrade checks ausführen

    foreman-maintain upgrade check --target-version TARGET_VERSION

Upgrade starten

1. Aktuelle Repos einbinden

z.B.

```shell
dnf upgrade https://yum.theforeman.org/releases/3.18/el9/x86_64/foreman-release.rpm \
https://yum.theforeman.org/katello/4.20/katello/el9/x86_64/katello-repos-latest.rpm
```

2. Upgrade check ausführen

```shell
foreman-rake katello:upgrade_check
```

3. Foreman stoppen

```shell
foreman-maintain service stop
```

4. Pakete aktualisieren

```shell
dnf upgrade
```

Wenn hier ein Fehler kommt, z.B. `package foreman-redis-3.18.1-1.el9.noarch from foreman requires (rubygem(redis) >= 4.5.0 with rubygem(redis) < 4.6.0), but none of the providers can be installed` dann müssen die EPEL Repositories entfernt werden!

```shell
rm -f /etc/yum.repos.d/epel*
dnf clean all
dnf makecache
```

Danach nochmals das `dnf  upgrade` starten.

5. Foreman Setup aktualisieren

```shell
formean-installer
```

siehe auch https://docs.theforeman.org/3.18/Upgrading_Project/index-katello.html

## Backup

Generell bestehen 2 Möglichkeiten fuer ein Backup:

1. VM basiertes System:

Bei Vms kann man üblicherweise mit Mitteln des Hypervisors Snapshots erzeugen.
Empfohlen wird ein Snapshot im Offline Modus. Dadurch verhindert man Inkonsistenzen, wenn während des Backups Änderungen vorgenommen werden.

Bevor Foreman gestoppt wird, sollte man pruefen, ob aktuell Tasks laufen. Dafür kann man die upgrade_check Task verwenden:

    foreman-rake katello:upgrade_check

Hier sollte folgendes Ergebnis angezeigt werden:

    Checking for running tasks...
    [SUCCESS] - There are 0 active tasks.
             You may proceed with the upgrade.

Nun kann Foreman gestoppt werden:

    formain-maintain service stop

Snapshot der VM erzeugen, danach kann Foreman wieder gestartet werden:

    foremain-maintain service start

2. Bare Metall:

Auf Bare Metall reichen Snapshots von einzelnen Filesystemen nicht aus.

Hier kann man foreman-maintain Erweiterung verwenden:

    foreman-maintain backup offline /tmp/backup

Weitere Informationen: [https://theforeman.org/plugins/foreman_maintain/0.2/index.html](https://theforeman.org/plugins/foreman_maintain/0.2/index.html)

## Restore

1. VM Snapshot

Snapshot als neue VM hochfahren, dananch Foreman Servcies starten

    systemctl start foreman

2. Bare Metall

Fuer Bare Metal kann foremain-maintain verwendet werden.

Installation `yum install rubygem-foreman_maintain`

Danach kann Foreman Maintain fuer verschiedene Tasks verwendet werden:

    foreman-maintain
    Usage:
        foreman-maintain [OPTIONS] SUBCOMMAND [ARG] ...

    Parameters:
        SUBCOMMAND                    subcommand
        [ARG] ...                     subcommand arguments

    Subcommands:
        health                        Health related commands
        upgrade                       Upgrade related commands
        service                       Control applicable services
        backup                        Backup server
        restore                       Restore a backup
        packages                      Lock/Unlock package protection, install, update
        advanced                      Advanced tools for server maintenance
        content                       Content related commands
        maintenance-mode              Control maintenance-mode for application

    Options:
        -h, --help                    print help

Starten des Backup:

    foreman-maintain backup offline /tmp/backups

Wiederherstellen aus einem Backup:

    foreman-maintain restore <pfad zum backup>

Weiter mit Teil 11 [Mandaten, Lokationen, User, Gruppen](../11_mandanten)
