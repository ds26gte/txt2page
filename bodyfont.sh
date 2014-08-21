# last modified 2011-11-24

fontname=$*

if test -z "$fontname"
then echo Error: needs a font name as specified in Google webfonts
    exit
fi

fontnamewithplus=$fontname

if $(echo $fontname | grep " " >/dev/null)
then
    fontnamewithplus=$(echo $fontname | sed -e 's/ /+/g')
fi

rm -f bodyfont.css

echo $fontnamewithplus |
sed -e "s/^/@import url('http:\/\/fonts.googleapis.com\/css?family=/" |
sed -e "s/$/');/" >> bodyfont.css

echo >> bodyfont.css

echo body { >> bodyfont.css

echo $fontname |
sed -e "s/^/    font-family: '/" |
sed -e "s/$/';/" >> bodyfont.css

echo } >> bodyfont.css
