#!/bin/bash

while IFS=';' read  a b c; do
      echo $a $b $c
done < file

while IFS=';' read -a Array; do
      echo "${Arrray[@]}"
done < file

cat fichier.csv | while read Ligne
do IFS=';'
   set -- $Ligne
   echo "$@"
done