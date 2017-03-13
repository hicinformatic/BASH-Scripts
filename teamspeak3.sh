#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workfile='teamspeak3_workfile.txt'
workfile2='teamspeak3_last.txt'
jsontmp='teamspeak3.json.tmp'
source $dir/config/teamspeak3.config 

$(cat $dir/json/teamspeak3.json > $jsontmp)

# DATAS
datas=($(ps -u teamspeak3 -o %cpu,%mem,etimes --no-headers))

# UPTIME
uptime=${datas[2]}
$(sed -i "s/#{UPTIME}#/$uptime/g" $jsontmp)

# CPU
cpu=($(echo ${datas[0]} | grep -Eo '[0-9]{1,3}'))
cpu=${cpu[0]}
$(sed -i "s/#{CPU}#/$cpu/g" $jsontmp)

# MEMORY
mem=($(echo ${datas[1]}  | grep -Eo '[0-9]{1,3}'))
mem=${mem[0]}
$(sed -i "s/#{MEM}#/$mem/g" $jsontmp)



# WORKFILE
SLEEP=1

{
        sleep $SLEEP
        echo "login $ts3user $password"
        sleep $SLEEP
        echo "use sid=1"
        sleep $SLEEP
        echo "clientlist"
        sleep $SLEEP
        echo "quit"
} | nc  localhost $port > $dir/$workfile

# NUMBER USERS
$(sed ':a;N;$!ba;s/|/\n/g' $dir/$workfile | grep "client_nickname" > $dir/$workfile2)
$(rm -f "$dir/$workfile")
for u in `grep -Po '(?<=client_nickname=).*(?=\ client_type)' $dir/$workfile2 | grep -v $ts3user`
do
    if [ -n "$client" ]
    then
        $(sed -i "s/#{LIST}#/\"$client\",\n        #{LIST}#/g" $jsontmp)
    fi
    client=$u
done
$(sed -i "s/#{LIST}#/\"$client\"/g" $jsontmp)
$(rm -f $dir/$workfile2)

$(chown $user:$group $jsontmp)
$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)