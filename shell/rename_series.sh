#!/bin/bash

#for file in `ls`; do mv $file `echo $file` | sed 's/.*S\([0-9][0-9]\)E\([0-9][0-9]\).*\.\([avi|srt]\)/S\1E\2.\3/'`; done

#pour les noms avec des espaces (mais pas de virgules)
#todo: ne fait pas le dernier
m="";

function rename_file() {
    m=$(echo "$1" | sed 's/,//');
    ext=$(echo "$m" | rev | cut -d'.' -f1 | rev);    
    nm=$(echo "$m" | sed 's/.*\([0-9]\)[eExX]\([0-9]*\).*/0\1E\2.'$ext'/');
    #echo $nm
    mv "$m" "$nm";
}

for f in `ls -m`; do
    if [ -z "$m" ]; then
        m=$f;
    else
        m="$m $f";
    fi;

    if [ `echo $m|grep -c ','` -eq 1 ]; then
        rename_file "$m"
        m="";
    fi;
done
rename_file "$m"
