#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workfile='teamspeak3_workfile.txt'
workfile2='teamspeak3_last.txt'
source $dir/config/teamspeak3.config 
jsontmp="$sysuser.json.tmp"
$(cat $dir/json/teamspeak3.json > $jsontmp)

# UPTIME
uptime=$(ps -u $sysuser -o etimes,cmd | grep "$bind" | awk '{print $1}' | head -n1)
$(sed -i "s/#{UPTIME}#/\"$uptime\"/g" $jsontmp)

# CPU
for c in `ps -u $sysuser -o %cpu --no-headers`
do
    if [ -n "$pscpu" ]
    then
        $(sed -i "s/#{CPU}#/\"$pscpu\",\n        #{CPU}#/g" $jsontmp)
    fi
    pscpu=$c
done
$(sed -i "s/#{CPU}#/\"$pscpu\"/g" $jsontmp)

# MEM
for m in `ps -u $sysuser -o %mem --no-headers`
do
    if [ -n "$psmem" ]
    then
        $(sed -i "s/#{MEM}#/\"$psmem\",\n        #{MEM}#/g" $jsontmp)
    fi
    psmem=$m
done
$(sed -i "s/#{MEM}#/\"$psmem\"/g" $jsontmp)

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
$(sed -e '1,15d' < $dir/$workfile > $dir/$workfile2)
$(rm -f "$dir/$workfile")
#for u in `grep -Po '(?<=client_nickname=).*(?=\ client_type)' $dir/$workfile2 | grep -v $ts3user`
#do
#    if [ -n "$client" ]
#    then
#        $(sed -i "s/#{LIST}#/\"$client\",\n        #{LIST}#/g" $jsontmp)
#    fi
#    client=$u
#done
#if [ -z "$client" ]
#then
#    $(sed -i "s/#{LIST}#//g" $jsontmp)
#else
#    $(sed -i "s/#{LIST}#/\"$client\"/g" $jsontmp)
#fi
#$(rm -f $dir/$workfile2)

$(chown $user:$group $jsontmp)
$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)