#!/bin/bash

# Port d'administration teamspeak3
port="10011"
# Utilisateur associé teamspeak3
user="Bot"
# Mot de passe de l'utilisateur teamspeak3
password=""

###########################
######## STOP CONF ########
###########################

basedir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
file="$basedir/messages.txt"
msg=$(head -$((${RANDOM} % `wc -l < $file` + 1)) $file | tail -1)
SLEEP=1

{
    sleep $SLEEP
    echo "login $user $password"
    sleep $SLEEP
    echo "use sid=1"
    sleep $SLEEP
    echo "clientupdate client_nickname=$user"
    sleep $SLEEP
    echo "sendtextmessage targetmode=3 msg=$msg"
    sleep $SLEEP
    echo "quit"
} | nc  localhost $port
