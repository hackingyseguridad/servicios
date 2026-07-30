# Instalar la versión GNU de inetd
apt-get install -y inetutils-inetd telnetd

# Verificar configuración
echo "telnet stream tcp nowait root /usr/sbin/tcpd /usr/sbin/in.telnetd" >> /etc/inetd.conf

# Iniciar servicio
systemctl restart inetutils-inetd
systemctl enable inetutils-inetd

# Verificar
netstat -tlnp | grep 23
