for file in `ls`; do mv $file `echo $file` | sed 's/.*S\([0-9][0-9]\)E\([0-9][0-9]\).*\.\([avi|srt]\)/S\1E\2.\3/'`; done

#pour les noms avec des espaces (mais pas de virgules)
#todo: ne fait pas le dernier
m=""; for f in `ls -m *srt`; do if [ -z "$m" ]; then m=$f; else m="$m $f"; fi; if [ `echo $m|grep -c ','` -eq 1 ]; then m=$(echo $m | sed 's/,//'); echo "$m" | sed 's/.*\([0-9]\)x\([0-9]*\).*/0\1E\2.srt/'; m=""; fi; done