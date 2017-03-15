#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config/server.config 
jsontmp='server.json.tmp'
$(cat $dir/json/server.json > $jsontmp)

# UPTIME
uptime=($(cat /proc/uptime))
uptime=${uptime[1]}
$(sed -i "s/#{UPTIME}#/$uptime/g" $jsontmp)

# CPU
for c in `ps -axo %cpu --no-headers`
do
    if [ -n "$pscpu" ]
    then
        $(sed -i "s/#{CPU}#/\"$pscpu\",\n        #{CPU}#/g" $jsontmp)
    fi
    pscpu=$c
done
$(sed -i "s/#{CPU}#/\"$pscpu\"/g" $jsontmp)

# MEM
for m in `ps -axo %mem --no-headers`
do
    if [ -n "$psmem" ]
    then
        $(sed -i "s/#{MEM}#/\"$psmem\",\n        #{MEM}#/g" $jsontmp)
    fi
    psmem=$m
done
$(sed -i "s/#{MEM}#/\"$psmem\"/g" $jsontmp)

$(chown $user:$group $jsontmp)
$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)