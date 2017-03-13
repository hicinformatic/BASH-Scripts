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

# MEM
for i in `ps -u django -o %cpu --no-headers`
do
    $(sed -i "s/#{MEM}#/\"$i\",\n        #{MEM}#/g" $jsontmp)
done