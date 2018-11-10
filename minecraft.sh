#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workfile='minecraft_workfile.txt'
workfile2='minecraft_last.txt'
source $dir/config/minecraft.config 
jsontmp="$sysuser.json.tmp"
$(cat $dir/json/minecraft.json > $jsontmp)

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
$($rcon -H localhost -P $port -p $password "list" > $dir/$workfile)

## NUMBER USERS
$(cut -c41- $dir/$workfile > $dir/$workfile2)
$(sed -i "s/, /\n/g"  $dir/$workfile2)
$(sed "s/\x1b\[[0-9;]*m//g" $dir/$workfile2 > $dir/$workfile)
$(rm -f "$dir/$workfile2")
for u in `cat $dir/$workfile`
do
    if [ -n "$client" ]
    then
        $(sed -i "s/#{LIST}#/\"$client\",\n        #{LIST}#/g" $jsontmp)
    fi
    client=$u
done
if [ -z "$client" ]
then
    $(sed -i "s/#{LIST}#//g" $jsontmp)
else
    $(sed -i "s/#{LIST}#/\"$client\"/g" $jsontmp)
fi
$(rm -f $dir/$workfile)

$(chown $user:$group $jsontmp)
$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)