#!/bin/bash
# hackingyseguriad.com 2025


# persisntencia.sh es como hacer que un Script se haga persistente en un sistema
# hacer que se inicie un Script al inicio del sistema
# guardar nuestro script en la caroeta /etc/init.d
# se requiere privilegios SuperUser
# nuestro script le vamos a llamar implante.sh


cd /etc/init.d

# vi implannte.sh   - nuestro script 

sudo chmod +x /etc/init.d/implante.sh
sudo update-rc.d implante.sh defaults
