#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workfile="teamspeak3_workfile.txt"
source $dir/config/teamspeak3.config 

# DATAS
datas=($(ps -u teamspeak3 -o %cpu,%mem,etimes --no-headers))

# CPU
cpu=($(echo ${datas[0]} | grep -Eo '[0-9]{1,3}'))
cpu=${cpu[0]}

# MEMORY
mem=($(echo ${datas[1]}  | grep -Eo '[0-9]{1,3}'))
mem=${mem[0]}

# UPTIME
upt=${datas[2]}

# WORKFILE
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
} | nc  localhost $port > "$dir/$workfile"

# NUMBER USERS
nbr=$(grep -o "client_nickname" "$dir/$workfile" | tail -n +2 | wc -l)

echo $cpu
echo $mem
echo $upt
echo $nbr
