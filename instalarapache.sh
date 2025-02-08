#!/bin/bash
echo Instala servidor web apache y configura arranque automatico al inicio
sudo apt-get install apache2
sudo apt-get install apache2-utils
sudo update-rc.d apache2 enable
