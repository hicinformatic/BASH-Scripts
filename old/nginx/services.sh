#!/bin/bash

# Dossier d'exposition NGINX
static="/static"
# Chemin du svg off
off="off.svg"
# Chemin du svg on
on="on.svg"
# List des services a vérifier
service=("nginx" "iptables")

###########################
######## STOP CONF ########
###########################

for i in "${service[@]}"
do
    :
    img="$static$i.svg"
    systemctl status $i
    if [ $? -ne 0 ]; then
        $(cp $off $img)
    else
        $(cp $on $img)
    fi
done
