# convert any eligible .txt files in the cwd
# last change 2013-03-30
# prev change 2012-10-07

force=0

if test "$1" = "-f"
then force=1
fi

for f in *.txt
do
    if ! test $(grep -c "^# " $f) -gt 0
    then continue
    fi
    h=${f%.txt}.html
    if test ! -f $h -o $f -nt $h -o $force -eq 1
    then 
        echo converting $f ...
        txt2page $f
    fi
done
