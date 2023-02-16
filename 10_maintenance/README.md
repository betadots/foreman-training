# Foreman Training - Teil 10 - Backup und Recovery (optional)

## Upgrade

Prüfen, welche Versionen zur Verfügug stehen

    foreman-maintain upgrade list-versions

Upgrade checks ausführen

    foreman-maintain upgrade check --target-version TARGET_VERSION

Upgrade starten

    foreman-maintain upgrade run --target-version TARGET_VERSION

Upgrade Schritte

1. pre-upgrade check
1. pre-migrations
1. migrations
1. post-migrations
1. post-upgrade checks

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
