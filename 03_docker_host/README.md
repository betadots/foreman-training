# Foreman Training - Teil 3 - Docker Host

## Docker Setup

    vagrant up docker.example42.training

### Puppet Zertifikat signieren:

Foreman Login -> Infrastructure -> Smart Proxies -> foreman.example42.training

Puppet CA -> Orange Klicken -> Sign

### Initialer Puppet Lauf

    vagrant ssh docker.example42.training
    sudo -i
    puppet agent --test 

## Host Klassifizieren

Foreman Login -> Hosts -> All Hosts -> docker.example42.training -> Edit -> Puppet CLasses -> Docker auswaehlen

## Puppet Klassen Parameter aendern

### Globale Defaults (Smart Class Variables)

Foreman Login -> Configure -> Smart Class Parameters

search:  ```puppetclass =  docker and  parameter =  tcp_bind```

Klick auf tcp_bind

Default behavior:
-  Override: OK
-  Key type: string
-  Default value: ```tcp://0.0.0.0:4243```

Submit

Jetzt noch ein Puppet Lauf auf docker.example42.training

