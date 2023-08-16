
#!/bin/bash
# Instalacion del escaner de vulnerabilidades Nessusd
echo
echo "Descargando ultima versión para Linux Debian ...  https://www.tenable.com/downloads "
echo
cd /tmp/
wget 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.5.2-ubuntu1404_amd64.deb' 
echo 
echo "Instalando .."
dpkg -i Nessus-10.5.2-ubuntu1404_amd64.deb
systemctl start nessusd
systemctl start nessusd.service
echo "abrir url https://localhost:8834/"
echo "Numero de licencia ZTZL-Z5P3-6KBX-PM4K"

# Desinstalar con: dpkg --purge  nessus
# rm /opt/nessus/lib/nessus -R
