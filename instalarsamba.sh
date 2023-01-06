#!/bin/bash
echo "Instala servidor samba y configura arranque automatico al inicio"
echo "hacking y seguridad .com  2023" 
apt-get install samba
systemctl restart smbd
service samba restart
