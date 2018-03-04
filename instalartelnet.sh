#!/bin/bash
echo Script instalar/habilitar telnet y configurar inicio automatico

sudo apt-get install telnetd
sudo service telnetd start
sudo update-rc.d telnetd enable
sudo systemctl enable telnetd.service
