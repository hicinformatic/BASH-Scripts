#!/bin/bash

# Dossier d'exposition NGINX
static="/static"
# Port d'administration teamspeak3
port="10011"
# Utilisateur admin teamspeak3
user="serveradmin"
# Mot de passe admin teamspeak3
password=""
# Fichier exposé 
file="teamspeak3_nbruser.txt"

###########################
######## STOP CONF ########
###########################

basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SLEEP=1

{
        sleep $SLEEP
        echo "login $user $password"
        sleep $SLEEP
        echo "use sid=1"
        sleep $SLEEP
        echo "clientlist"
        sleep $SLEEP
        echo "quit"
} | nc  localhost $port > "$basedir/$file"

grep -o "client_nickname" "$basedir/$file" | tail -n +2 | wc -l > "$static/$file"
rm -f "$basedir/$file"
