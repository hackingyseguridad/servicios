#!/bin/bash
echo Script instalar/habilitar XRDP y configurar inicio automatico
echo Para acceder al escritorio remoto desde Windows ejecutar mstsc.exe
sudo apt-get install xrdp
sudo service xrdp start
sudo update-rc.d xrdp enable
sudo systemctl enable xrdp.service
