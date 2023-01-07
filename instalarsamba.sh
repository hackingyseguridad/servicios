#!/bin/bash
echo
echo "Instala servidor samba y configura arranque automatico al inicio .."
echo 

# (c) hacking y seguridad .com  2023

apt-get install samba
systemctl restart smbd
update-rc.d smbd enable

# edimtamos /etc/samba/smb.conf
#[web]
#path = /var/www/html
#guest ok = yes
#browseable = yes
#public = yes
#writable = yes
#create mask = 0777
#directory mask = 0777

service smbd restart

