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

runuser -u postgres -- /usr/share/gvm/create-postgresql-database

chmod 777 /var/log/gvm/gvmd.log
runuser -u _gvm -- gvmd --create-user=admin --password=Passwd00

chown -R _gvm:_gvm /var/lib/openvas/
chmod -R 755 /var/lib/openvas/

sudo systemctl restart gvmd

sudo gvm-check-setup

sudo gvm-start

echo
echo "https://localhost:9392"
