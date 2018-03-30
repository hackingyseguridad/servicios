#!/bin/bash
echo Script instalar/habilitar sshd y configurar inicio automatico

sudo apt-get install ssh
sudo service ssh start
sudo update-rc.d ssh enable
sudo systemctl enable ssh.service
