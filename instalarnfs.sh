#!/bin/bash
#Instación en KaLi Linux NFS Server, puertos, 111/tcp, 2049/tcp!
#vim /etc/export
#/tmp 192.168.1.0/24(rw,sync)
#/var/www/html 192.168.1.0/24(rw,sync)

echo "instalando NFS .."

# Instación 
sudo apt-get install -y nfs-kernel-server
sudo systemctl enable nfs-kernel-server


# Proceso automatico
systemctl start rpcbind nfs-server
systemctl enable rpcbind nfs-server
systemctl status nfs-server

# Ver proceso 
ss -a|grep nfs

# Ver consultas NFS por version
nfsstat -c

nmap -Pn --script=nfs-ls.nse,nfs-showmount.nse,nfs-statfs.nse -p 2049,111  -sVC -O localhost

# Actualizar 
exportfs 

# mount -t nfs4 server:/ /mnt/tmp



