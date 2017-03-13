#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $dir/config/server.config 
gunicorntmp='server.json.tmp'


# CPU
for i in `ps -u django -o %cpu --no-headers`
do
    cpu=$(( $cpu + $i ))
done
echo $cpu

# MEM
for i in `ps -u django -o %mem --no-headers`
do
    mem=$(( $cpu + $i ))
done
echo $mem