# Katello

ACHTUNG: Katello benoetigt mindestens 8 GB RAM!

Es wird abgeraten katello auf einem existierenden Foreman Setup hinzuzufuegen.

Statt dessen soll katello vor der foreman installation vorbereitet werden:

WICHTIG: Vor der Installation muss die Uhrzeit bereits korrekt gesetzt sein!

Alternativ kann man vor der Installation das Answer File bearbeiten:
/etc/foreman-installer/scenarios.d/katello-answers.yaml

1. Vagrant

    vagrant up katello.example42.training

