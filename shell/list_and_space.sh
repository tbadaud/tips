#!/bin/bash

f1="typescript"
f2="communes/villes.csv"

list=$(grep ')' $f1 | cut -d"'" -f2 | sed 's/^\(.*\)$/;\1;/')

echo $list

len=-1 #taille restante
while [ $len -ne ${#list} ]; do
    w=$(echo $list | sed 's/;\([^;]*\).*/\1/')
    len=${#list} #taille avant cut
    list=$(echo $list | sed 's/;[^;]*; \(.*\)/\1/')
    #taille avant "retrecicement" = apres > FIN (cdt while)

    echo -n "$w: "
    grep ";$w;" $f2 | wc -l

done
