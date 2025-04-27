#
# Servidor web basico con netcat
# Puerto 80 TCP
# Carpeta de la pagina web /var/www/html/index.html
# otro servidor web basico con Python python -m SimpleHTTPServer 80
# otro servidor web basico con PHP php -S 0.0.0.0:80
# www.hackingyseguridad.com
#

#!/bin/sh
while true; do echo -e "HTTP/1.1 200 OK\r\n $(cat /var/www/html/index.html)" | nc -lp 80 -q 1; sleep 1; done
