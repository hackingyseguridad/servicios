#!/bin/bash
#Instación en KaLi Linux NFS Server, puertos, 111/tcp, 2049/tcp!
#vim /etc/export
echo "instalando NFS .."

# Instación 
sudo apt-get install -y nfs-kernel-server
sudo systemctl enable nfs-kernel-server
apt-get install exportfs 

# Proceso automatico
systemctl start rpcbind nfs-server
systemctl enable rpcbind nfs-server
systemctl status nfs-server

# Ver proceso 
ss -a|grep nfs

# Ver consultas NFS por version
nfsstat -c

nmap --script=nfs-ls.nse,nfs-showmount.nse,nfs-statfs.nse -p111,2049  -sVC -O localhost
