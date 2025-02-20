#!/bin/bash
# (c) hackingyseguridad.com 2025

cat << "INFO"

▬▬▬.◙.▬▬▬
═▂▄▄▓▄▄▂
◢◤ █▀▀████▄▄▄▄◢◤
█▄ █ █▄ ███▀▀▀▀▀▀▀╬
◥█████◤
══╩══╩═
╬═╬
╬═╬
╬═╬
╬═╬
╬═╬    subrutina instalar postfix V.1.0 
╬═╬    hackingyseguridad.com
╬═╬⛑/
╬═╬/▌
╬═╬/  \

INFO
echo
echo "."
echo ".."
echo "..."
echo "instalando postfix ... "
echo "...."
echo "servidor de correo SMTP "
echo "....."
echo
echo "......"
echo

apt-get install mailutils -y
apt-get install postfix -y
sudo update-rc.d postfix enable
sudo systemctl enable postfix
sudo systemctl restart postfix
