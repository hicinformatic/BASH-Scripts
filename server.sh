#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config/server.config 
jsontmp='server.json.tmp'

# CPU
for i in `top -b -n1 | grep Cpu | awk '{print $4}' | grep -Eo '[0-9]{1,3}'`
do
    cpu=$(( $cpu + 1 ))
    load=$(( $load + $i ))
done
load=$(( $load / $cpu ))

# MEMORY
mem=$(awk '/^Mem/ {printf("%u", 100*$3/$2);}' <(free -m))

# UPTIME
upt=($(cat /proc/uptime))
upt=${upt[0]}

# JSON FORMAT

$(cat $dir/json/server.json > $jsontmp)
$(sed -i "s/#{CPU}#/$load/g" $jsontmp)
$(sed -i "s/#{MEM}#/$mem/g" $jsontmp)
$(sed -i "s/#{UPTIME}#/$upt/g" $jsontmp)

if [ $load -gt 90 ] || [ $mem -gt 90 ] ; then
    $(sed -i "s/#{STATUS}#/off/g" $jsontmp)
elif [ $load -gt 60 ] || [ $mem -gt 60 ] ; then
    $(sed -i "s/#{STATUS}#/warning/g" $jsontmp)
else
    $(sed -i "s/#{STATUS}#/on/g" $jsontmp)
fi

$(chmod $chmod $jsontmp)
$(mv $jsontmp $json)