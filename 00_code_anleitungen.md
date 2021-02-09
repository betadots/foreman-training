# Anleitungen

## Vagrant

WICHTIG: vagrant Kommandos muessen aus dem vagrant Verzeichnis heraus gestartet werden!

    cd vagrant

1. Status: `vagrant status`

Beispiel Ausgabe:

    Current machine states:

    foreman.example42.training running (virtualbox)
    docker.example42.training  not created (virtualbox)
    apache.example42.training  not created (virtualbox)
    host.example42.training    not created (virtualbox)
    
    This environment represents multiple VMs. The VMs are all listed
    above with their current state. For more information about a specific
    VM, run `vagrant status NAME`.

2. Starten: `vagrant up <vm name>`

3. Suspend: `vagrant suspend <vm name>`

4. Resume: `vagrant resume <vm name>`

5. Loeschen: `vagrant destroy -f <vm name>`

6. Login: `vagrant ssh <vm name>`

7. Reprovisionieren: `vagrant reload --provision <vm name>`
