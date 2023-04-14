#!/bin/bash
#Instación en KaLi Linux NFS Server, puertos, 111/tcp, 2049/tcp!
#vim /etc/export
#
# /var/www/html (rw,sync)
# /tmp 192.168.1.250(sync,rw) 192.168.1.252(sync,ro,no_root_squash)
#
# Opciones de exportación en el fichero /etc/exports ro
# El sistema de archivos exportado sólo es de lectura, por lo que los hosts remotos no pueden modificar los datos compartidos. rw
# Para permitir la edición a través de los hosts remotos (leer y escribir), es necesario especificar la opción de ‘rw’. sync
# La sincronización por defecto significa que el servidor NFS no responderá a las solicitudes antes de que los cambios se escriban en el disco. Para permitir las escrituras asíncronas en su lugar, es necesario especificar la opción ‘async‘. root_squash
# Para evitar que los usuarios root conectados remotamente tengan privilegios de root, se puede usar la opción ‘root_squash’. Si queremos que el usuario root del servidor remoto tenga privilegios de root, usaremos no_root_squash.  wdelay
# .

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
 exportfs -ra
 sudo service nfs-kernel-server restart

# Desde el lado cliente:
# sudo showmount --exports 192.168.1.200
# mount -t nfs4 server:/ /mnt/tmp
# sudo mount -t nfs4 192.168.1.200:/tmp /tmp 
# nmap -Pn --script=nfs-ls.nse,nfs-showmount.nse,nfs-statfs.nse -p 2049,111  -sVC -O 192.168.1.200



