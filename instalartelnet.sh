#!/bin/bash
echo Script instalar/habilitar telnet y configurar inicio automatico

sudo apt-get install telnetd
sudo /etc/init.d/openbsd-inetd restart
