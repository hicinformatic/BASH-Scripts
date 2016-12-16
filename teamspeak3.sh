#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workfile='teamspeak3_workfile.txt'
workfile2='teamspeak3_last.txt'
jsontmp='teamspeak3.json.tmp'
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
nbr=$(grep -cv $ts3user $dir/$workfile2)

$(cat $dir/json/teamspeak3.json > $jsontmp)
$(sed -i "s/#{CPU}#/$cpu/g" $jsontmp)
$(sed -i "s/#{MEM}#/$mem/g" $jsontmp)
$(sed -i "s/#{UPTIME}#/$upt/g" $jsontmp)
$(sed -i "s/#{USERS}#/$nbr/g" $jsontmp)

for u in `grep -Po '(?<=client_nickname=).*(?=\ client_type)' $dir/$workfile2 | grep -v $ts3user`
do
    $(sed -i "s/#{LIST}#/'$u',\n        #{LIST}#/g" $jsontmp)
done
$(rm -f $dir/$workfile2)
$(sed -i '/        #{LIST}#/d' $jsontmp)

if [ $cpu -gt 90 ] || [ $mem -gt 90 ] ; then
    $(sed -i "s/#{STATUS}#/off/g" $jsontmp)
elif [ $cpu -gt 60 ] || [ $mem -gt 60 ] ; then
    $(sed -i "s/#{STATUS}#/warning/g" $jsontmp)
else
    $(sed -i "s/#{STATUS}#/on/g" $jsontmp)
fi

$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)