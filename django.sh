#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config/server.config 
gunicorntmp='server.json.tmp'


# CPU
for i in `ps -u django -o %cpu --no-headers | grep -Eo '[0-9]{1,3}'`
do
    cpu=$(( $cpu + $i ))
done
echo $(($cpu/10))

# MEM
for i in `ps -u django -o %mem --no-headers | grep -Eo '[0-9]{1,3}'`
do
    mem=$(( $cpu + $i ))
done
echo $mem