#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config/server.config 
jsontmp='django.json.tmp'


$(cat $dir/json/django.json > $jsontmp)

# CPU
for i in `ps -u django -o %cpu --no-headers`
do
    $(sed -i "s/#{CPU}#/\"$i\",\n        #{CPU}#/g" $jsontmp)
done
 $(sed -i "s/#{CPU}#//g" $jsontmp)

# MEM
for i in `ps -u django -o %mem --no-headers`
do
    $(sed -i "s/#{MEM}#/\"$i\",\n        #{MEM}#/g" $jsontmp)
done
 $(sed -i "s/#{MEM}#//g" $jsontmp)