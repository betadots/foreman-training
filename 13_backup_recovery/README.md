# Foreman Training - Teil 13 - Backup und Recovery (optional)

## Backup

Generell bestehen 2 Moeglichkeiten fuer ein Backup:

1. VM basiertes System:

Bei Vms kann man ueblicherweise mit Mitteln des Hypervisors Snapshots erueugen.
Empfohlen wir ein Snapshot im Offline Modus. Dadurch verhindert man Inkonsistenzen, wenn waehrend des Backups Aenderungen vorgenommen werden.

Bevor Foreman gestoppt wird, sollte man pruefen, ob aktuell Tasks laufen. Dafuer kann man die upgrade_check Task verwenden:

    foreman-rake katello:upgrade_check

Hier sollte folgendes Ergebnis angezeigt werden:

    Checking for running tasks...
    [SUCCESS] - There are 0 active tasks.
             You may proceed with the upgrade.

Nun kann Foreman gestoppt werden:

    systemctl stop foreman

Snapshot der VM erzeugen

    systemctl start foreman


2. Bare Metall:

Auf Bare Metall reichen Snapshots von einzelnen Filesystemen nicht aus.

Hier kann man foreman-maintain Erweiterung verwenden:

    foreman-maintain backup offline /tmp/backup

Weitere Informationen: https://theforeman.org/plugins/foreman_maintain/0.2/index.html

## Restore

1. VM Snapshot

Snapshot als neue VM hochfahren, dananch Foreman Servcies starten

    systemctl start foreman

2. Bare Metall

    foreman-maintain restore <pfad zum backup>

