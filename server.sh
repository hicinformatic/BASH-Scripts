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
for c in `top -b -n1 | grep Cpu | awk '{print $4}' | grep -Eo '[0-9]{1,3}'`
do
    if [ -n "$pscpu" ]
    then
        $(sed -i "s/#{CPU}#/\"$pscpu\",\n        #{CPU}#/g" $jsontmp)
    fi
    pscpu=$c
done
$(sed -i "s/#{CPU}#/\"$pscpu\"/g" $jsontmp)

# MEM
mem=$(awk '/^Mem/ {printf("%u", 100*$3/$2);}' <(free -m))
$(sed -i "s/#{MEM}#/$mem/g" $jsontmp)

$(chown $user:$group $jsontmp)
$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)