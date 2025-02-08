
echo 
echo "Login Auth Basic Apache Server" 
echo "No explorar carpertas"
echo 

sudo apt-get update
sudo apt-get install apache2-utils
sudo htpasswd -c /etc/apache2/.htpasswd admin
cat /etc/apache2/.htpasswd

# editamos y añadimos al final:
# vim /etc/apache2/sites-enabled/000-default.conf
# 
#  <Directory "/var/www/html">
#      AuthType Basic
#      AuthName "Restricted Content"
#      AuthUserFile /etc/apache2/.htpasswd
#      Require valid-user
#  </Directory>
#

sudo apache2ctl configtest
sudo a2dismod --force autoindex
sudo systemctl restart apache2
sudo systemctl status apache2
