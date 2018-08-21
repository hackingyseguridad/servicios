!/bin/bash
echo Instala y ejecuta VNC y X11
sudo apt install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
sudo apt install tigervnc-standalone-server tigervnc-common

vncserver
