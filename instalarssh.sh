#!/bin/bash
echo Script instalar/habilitar sshd y configurar inicio automatico

sudo apt-get install sshd
sudo service sshd start
sudo update-rc.d sshd enable
sudo systemctl enable sshd.service
