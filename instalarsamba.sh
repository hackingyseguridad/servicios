#!/bin/bash

# edimtamos /etc/samba/smb.conf
#[web]
#path = /var/www/html
#guest ok = yes
#browseable = yes
#public = yes
#writable = yes
#create mask = 0777
#directory mask = 0777

echo "Instala servidor samba y configura arranque automatico al inicio"
echo "hacking y seguridad .com  2023" 
apt-get install samba
systemctl restart smbd
service smbd restart

