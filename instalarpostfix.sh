#!/bin/bash
echo "Script instalar postfix"

apt-get install mailutils
apt-get install postfix
sudo update-rc.d postfix enable
sudo systemctl enable postfix
sudo systemctl restart postfix
