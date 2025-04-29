#!/bin/bash
# apt-get install finger
cat << "INFO"

INFO
if [ -z "$1" ]; then
        echo
        echo "tcp79/Finger."
        echo
        echo "Uso.: ./finger.sh <ip>"
        echo
        exit 0
fi
echo
echo
for i in {0..9};do finger -l $i@$1;done|sort -u
