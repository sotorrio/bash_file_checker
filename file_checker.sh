#!/usr/bin/env bash

directorio=~/prueba/
echo Directorio a comprobar:$directorio
#read directorio

for archivo in $directorio/*; do
    t="$(wc -c <"$archivo")"
    echo $t
done
