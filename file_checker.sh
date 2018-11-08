#!/usr/bin/env bash

#### Funciones
actualizar_archivos()
{
    # Esta función se ejecuta al pasar al script el parámetro -a
    echo "Reconstruyendo la lista de archivos en $directorio" >> /dev/tty

    # Se reconstruye la lista de archivos
    if [ -f ./archivos ] ; then
        rm ./archivos
    fi
    touch ./archivos

    # Se recorren todos los archivos del directorio. Se omiten subdirectorios
    for archivo in $directorio/*; do
    if [ -f "$archivo" ] ; then
        t="$(wc -c <"$archivo")"
        echo $archivo $t >> ./archivos
        echo $archivo $t >> /dev/tty
    fi
    done

    echo "Hecho" >> /dev/tty
}


introduce_directorio()
{
    # Esta función se usará para introducir el directorio de trabajo cuando se vaya a actualizar la lista
    # de ficheros y cuando se vaya a realizar las comprobaciones

    # Si no se introduce ningún directorio, se toma el directorio por defecto en el script
    default=~/prueba
    echo "Directorio en el que se va a trabajar (ENTER para $default):" >>/dev/tty
    read dir
    if [ -z "$dir" ] ; then
        dir=$default
    fi
    echo $dir
}


comprobar_archivos()
{
    IFS=$'\n'
    set -f

    for linea in $(cat < "./archivos"); do
        #echo "$linea" >> /dev/tty
        IFS=$" " read -r -a arch <<< "$linea"
        echo "${arch[0]}" >> /dev/tty
        if [ -f "${arch[0]}" ] ; then
            if [ "$(wc -c <"${arch[0]}")" -eq "${arch[1]}" ] ; then
                echo "GUAY" >> /dev/tty
            fi
        fi

        IFS=$'\n'
    done < ./archivos
}


ayuda()
{
    # La función de ayuda se ejecuta al pasar el parámetro -h al script
    echo "AYUDA DE file_check.sh" >> /dev/tty
    echo "" >> /dev/tty
    echo "Sin parámetros realiza la comprobación" >> /dev/tty
    echo "" >> /dev/tty
    echo "-a        Actualizar directorios" >> /dev/tty
    echo "-h        Ayuda de file_checker" >> /dev/tty
}


#### Función principal

if [ $# -ge 1 ] ; then
    if [ $1 = "-a" ] ; then
        directorio=$(introduce_directorio)
        $(actualizar_archivos)
    elif [ $1 = "-h" ] ;  then
        $(ayuda)
    else
        echo "Parámetro no válido '$1'" >> /dev/tty
    fi
else
    directorio=$(introduce_directorio)
    $(comprobar_archivos)
fi

#### Fin de la función principal
