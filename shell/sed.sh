sed -i '/^$/d' * #supprime lignes vides

n=$(grep -n "<ul>" $f | cut -d':' -f1 | head -1)
n="1,"`expr $n - 1`"d"
sed -i $n $f

sed -i 's/.*<ul>\(.*\)<\/ul>.*/\1/' $f    
sed -i 's/<li[^>]*> <a href="\([^"]*\)[^>]*> <strong>\([AB0-9]*\) : <\/strong>\([^<]*\)<\/a> <\\
/li> /\2;\1;\3\n/g' $f

sed -i 's/<[\/]*strong>//g' $f
sed -i 's/<li[^>]*/<li/g' $f
sed -i 's/> />/g' $f



