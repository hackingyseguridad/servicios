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
╬═╬    subrutina para instalar OpenVas
╬═╬    http://www.hackingyseguridad.com
╬═╬⛑/
╬═╬/▌
╬═╬/  \

INFO
echo
echo "."
echo ".."
echo "..."
echo "instalando OpenVas ... "
echo "...."
echo "servicio  gvm  "
echo "....."
echo
echo "......"
echo


sudo apt-get update 
sudo apt install openvas
sudo apt install gvm

sudo pg_dropcluster 17 main --stop
sudo pg_upgradecluster 15 main 17

sudo gvm-setup
sudo gvmd --user=admin --new-password=Passwd00
sudo gvm-start

echo
echo "https://localhost:9392"
echo
