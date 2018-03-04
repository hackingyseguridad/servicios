!/bin/bash
echo Instala y ejecuta VNC y X11
apt-get install tightvncserver
tightvncserver :1 -desktop X -auth /root/.Xauthotity -geometry 1232x800 -depth 16
