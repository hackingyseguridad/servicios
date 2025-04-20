


# persisntencia.sh es como hacer que un Script se haga persistente en un sistema
# hacer que se inicie un Script al inicio del sistema
# se requiere privilegios SuperUser
# nuestro script le vamos a llamar implante.sh


sudo chmod +x /etc/init.d/implante.sh
sudo update-rc.d implante.sh defaults
