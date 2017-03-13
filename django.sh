#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config/django.config 
jsontmp="$user.json.tmp"

echo $user
$(cat $dir/json/django.json > $jsontmp)

# UPTIME
uptime=$(ps -u $user -o etimes,cmd | grep "$bind" | awk '{print $1}' | head -n1)
$(sed -i "s/#{UPTIME}#/\"$uptime\"/g" $jsontmp)

# CPU
for c in `ps -u $user -o %cpu --no-headers`
do
    if [ -n "$pscpu" ]
    then
        $(sed -i "s/#{CPU}#/\"$pscpu\",\n        #{CPU}#/g" $jsontmp)
    fi
    pscpu=$c
done
$(sed -i "s/#{CPU}#/\"$pscpu\"/g" $jsontmp)

# MEM
for m in `ps -u $user -o %mem --no-headers`
do
    if [ -n "$psmem" ]
    then
        $(sed -i "s/#{MEM}#/\"$psmem\",\n        #{MEM}#/g" $jsontmp)
    fi
    psmem=$m
done
$(sed -i "s/#{MEM}#/\"$psmem\"/g" $jsontmp)

# USERS
$(sed -i "s/#{LIST}#/\"Gyn\"/g" $jsontmp)