#!/bin/bash
echo Script instalar/habilitar bind9 y configurar inicio automatico
apt-get install bind9
service bind9 start
sudo update-rc.d bind9 enable
sudo systemctl enable bind9
