# last change 2011-11-10

fam=$1
reg=$2
ital=$3
bold=$4
boldital=$5

otf2groff.sh $reg ${fam}R
otf2groff.sh $ital ${fam}I
otf2groff.sh $bold ${fam}B
otf2groff.sh $boldital ${fam}BI
