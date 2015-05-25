" last modified 2015-05-25

func! s:troffRecognizeUrls()
    " evalwhen.com
    " -- check not preceded by @
    s#\%(@\)\@<!\<[[:alnum:].-]\+\.\%(com\|co\.[[:lower:]]\{2}\|edu\|net\|org\|[[:lower:]]\{2}\%(js\|ms\|on\|ps\|sh\)\@<!\)\>#FAKEHTTP://&#g

    " URL
    s#\<[[:alpha:]-]\+://[^[:space:]()<>\[\]]\+\%(([[:alnum:]]\+)\|/\|[^[:space:][:punct:]]\)#ÞtzpUrlBeginTzp&ÞtzpUrlEndTzp#g

    s#FAKEHTTP://##g

    " ./pathname
    s#\%([.]\)\@<!\./\([^[:space:]()<>&]\+\)\%([[:punct:]]\)\@<!#ÞtzpUrlBeginTzp\1ÞtzpUrlEndTzp#g

    s:\(ÞtzpUrlBeginTzp\)[^#]\{-}#\([^#]\{-}\)\(ÞtzpUrlEndTzp\):\1[\2]\3:g

endfunc

func! s:troffFindQvUrls()
  v/^ÞtzpPreformattedTzp/ s/ÞtzpDoubleBackslashTzp\(\*\[:\s\+.\{-}\s*\]\)/ÞtzpBackslashTzp\1/
  v/^ÞtzpPreformattedTzp/ s/\%(\[\)\@<!\s*:\s*ÞtzpUrlBeginTzp.\{-}ÞtzpUrlEndTzp//g
endfunc

func! s:troffFindUrlhs()
  g/\%(\%(-:\|[᛫‡]\).*\)\@<!ÞtzpUrlBeginTzp/ s/^/ÞtzpPossibleUrlhTzp/

  g/^ÞtzpPossibleUrlhTzp/ -1s/\%(-:\|[᛫‡]\).\{-}$/&ÞtzpUrlhContinuationLineTzp/

  %s/^ÞtzpPossibleUrlhTzp//

  g/^ÞtzpUrlhContinuationLineTzp$/ .,+1 j

  %s/ÞtzpUrlhContinuationLineTzp//

  " ***

    " a line that starts with ÞtzpUrlBeginTzp is a possible urlh
    %s/^ÞtzpUrlBeginTzp/ÞtzpPossibleUrlhTzp&/

    g/^ÞtzpPossibleUrlhTzp/ -1s/⋆$/&ÞtzpUrlhContinuationLineTzp/

    %s/^ÞtzpPossibleUrlhTzp//

    g/ÞtzpUrlhContinuationLineTzp$/ .,+1 j

    %s/ÞtzpUrlhContinuationLineTzp//

    " ***

    v/^ÞtzpPreformattedTzp/ s/^[^⋆*]\+[⋆*]\s\+ÞtzpUrlBeginTzp/ÞtzpPossibleUrlhTzp&/

    g/^ÞtzpPossibleUrlhTzp/ -1s/[⋆*][^⋆*]\+$/&ÞtzpUrlhContinuationLineTzp/

    %s/^ÞtzpPossibleUrlhTzp//

    g/ÞtzpUrlhContinuationLineTzp$/ .,+1 j

    %s/ÞtzpUrlhContinuationLineTzp//

    " ***

    v/^ÞtzpPreformattedTzp/ s/^[^\[]\+\](ÞtzpUrlBeginTzp/ÞtzpPossibleUrlhTzp&/

    g/^ÞtzpPossibleUrlhTzp/ -1s/\[[^\]]\{-}$/&ÞtzpUrlhContinuationLineTzp/

    %s/^ÞtzpPossibleUrlhTzp//

    g/ÞtzpUrlhContinuationLineTzp$/ .,+1 j

    %s/ÞtzpUrlhContinuationLineTzp//

    " ***

    v/^ÞtzpPreformattedTzp/ s/\%(-:\|[᛫‡]\)\S.\{-}ÞtzpUrlBeginTzp.\{-}ÞtzpUrlEndTzp//g

    v/^ÞtzpPreformattedTzp/ s/\%(-:\|[᛫‡]\)\s*\(.\{-}\)\s*ÞtzpUrlBeginTzp.\{-}ÞtzpUrlEndTzp/\1/g

    v/^ÞtzpPreformattedTzp/ s:[⋆*]\([^⋆*]\+\)[⋆*]\s\+ÞtzpUrlBeginTzp.\{-}ÞtzpUrlEndTzp:\1:g

    v/^ÞtzpPreformattedTzp/ s:\[\([^\]]\+\)\](ÞtzpUrlBeginTzp.\{-}ÞtzpUrlEndTzp:\1:g

    " rm Url markers
    v/^ÞtzpPreformattedTzp/ s:ÞtzpUrlBeginTzp\(.\{-}\)ÞtzpUrlEndTzp:\1:g
endfunc

func! s:troffPalatable()
    "s:\(.\)†\(\S\+\%([:punct:]\)\@<!\):\1\\\\*{\2\\\\*}:g

    s:\`\`\(.\{-1,}\)\`\`:\\fC\1\\fP:g

    s:\`\([^\`]\{-1,}\)\`:\\fC\1\\fP:g

    s:^\.[/]:\\\&\0:
endfunc

func! s:troffTables()
    g/^|\s/,/^[^|]/-1 s#|\s*$##

    g/^|\s/,/^[^|]/-1 s#^|\s# ÞtzpTableLineTzp#

    g/^ ÞtzpTableLineTzp/,/^\%($\|[^ ]\)/-1 j

    v/ÞtzpPreformattedTzp/ s/ \(ÞtzpTableLineTzp\)/\1/g

    %s#^ÞtzpTableLineTzp.*$#.TS\rtab(|),center,allbox;\rÞtzpTableFirstLineTzp&\r.TE#

    %s#^\(ÞtzpTableFirstLineTzp\)ÞtzpTableLineTzp#\1#

    v/ÞtzpPreformattedTzp/ s#ÞtzpTableLineTzp#\r#g

    %s#^ÞtzpTableFirstLineTzp\(.*\)#ÞtzpTablePreamble\1ÞtzpTableSpaceTzp.\r\1#

    g/^ÞtzpTablePreamble/ s/|/ÞtzpTableSpaceTzp/g

    g/ÞtzpTableSpaceTzp/ s/.\{-}\(ÞtzpTableSpaceTzp\)/c\1/g

    v/ÞtzpPreformattedTzp/ s/ÞtzpTableSpaceTzp/ /g

endfunc

func! Txt2pdf()

%s/⋆/*/g

%s/Þ/ÞtzpThornTzp/g

%s/\s\+$//

$a
ÞtzpBogusEndOfFileLineTzp
.

"code display

%s/^\s*\(\`\`\`\+\)/.\1/

%s/^\.\s*\`\`\`\`\+/.EE/

%s/^\.\s*\`\`\`/.EX /

g/^\.\s*EX/+1, /^\.\s*EE/-1 s/^/ÞtzpPreformattedTzp/

"comment

g/^\.\s*\\\"/d

"horiz bars

%s/^\s*-\{5,}$//

"%s:\\\\":ÞtzpBackslashTzpÞtzpDoubleQuoteTzp:g

"sections

%s/^#\s\+\(.\{-}\)\s\+#$/ÞtzpSectionTzp title \1/
%s/^#\s\+\(.\{-}\)\s\+##$/ÞtzpSectionTzp htmltitle \1/
%s/^###\s\+###$/ÞtzpSectionTzp dropcap x/

%s/^#\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 1 \1/
%s/^##\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 2 \1/
%s/^###\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 3 \1/
%s/^####\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 4 \1/
%s/^#####\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 5 \1/
%s/^######\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 6 \1/

"g/^ÞtzpSectionTzp/,/./-1 j!

g/^ÞtzpSectionTzp\s\+htmltitle\s/d

"

%s/^ÞtzpSectionTzp\s\+title\s\+\(.*\)$/.Title \1/

%s/^ÞtzpSectionTzp\s\+\([1-6]\)\s\+\(.*\)$/.Section \1 \2/

"drop cap

%s/^ÞtzpSectionTzp\s\+dropcap\s\+.*/ÞtzpDropCapTzp/

g/^ÞtzpDropCapTzp$/ , /./ j

%s/^ÞtzpDropCapTzp\s*\(.\{-}[[:alnum:]]\)\(\S*\)\s*/.DC \1 \2\r/

"

v/^ÞtzpPreformattedTzp/ s:\\\\:ÞtzpDoubleBackslashTzp:g

" footnotes

v/^ÞtzpPreformattedTzp/ s:(†\([^()[:space:]]\+\)):\\*{\1\\*}:g

v/^ÞtzpPreformattedTzp/ s:\(.\)\((†\|†)\):\1\r\2:g

%s:^\((†\s*\S\+\)\s\+\(\S\):\1\r\2:

%s:^\(†)\)\s*\(\S\):\1\r\2:

%s:^(†\s*\(\S\+\)\?\s*$:.FS \1:

%s:^†)\s*$:.FE:

" end footnotes

v/^ÞtzpPreformattedTzp/ s:\(.\)\(‡\)\s*$:\1\r\2:

%s/^\(†\s*\S\+\)\s\+\(\S\)/\1\r\2/

%s/^†\s*\(\S.*\)\?\s*$/.FS \1/

"%s:^※\s*\(.*\)$:.LP\r[\1]\r.br:

"%s:^\.\s*BB\s\+\(.*\)$:.LP\r[\1]\r.br:

"g/^⚓/d

"g/^\.\s*AN\s/d

"g/^\.\s*NAV\s/d

"bullet items

"g/^•\s\+.*/ -1s/^$/ÞtzpDeleteBlankLineTzp/

"g/^ÞtzpDeleteBlankLineTzp$/d

"%s/^•\s\+\(.*\)/.IP • 2\r.nr nextGrafWithoutIndent 1\r\1/

"

g/^ÞtzpPreformattedTzp/ s:\\\\:ÞtzpBackslashETzp:g

v/^ÞtzpPreformattedTzp/ call s:troffRecognizeUrls()

call s:troffTables()

call s:troffFindQvUrls()

call s:troffFindUrlhs()

v/^ÞtzpPreformattedTzp/ call s:troffPalatable()

%s:ÞtzpDoubleBackslashTzp:ÞtzpBackslashTzpÞtzpBackslashTzp:g

%s:ÞtzpBackslashTzp:\\\\:g

%s:ÞtzpBackslashETzp:\\e:g

%s:ÞtzpDoubleQuoteTzp:":g

"

      $ g/^$/ s/^/ÞtzpLastLineTzp/

v/./,/./-j

1 g/^$/d

      $ g/^ÞtzpLastLineTzp/ $-1,$d

"

%s:^ÞtzpPreformattedTzp\.:\\\&.:

%s:^ÞtzpPreformattedTzp::

g/^ÞtzpBogusEndOfFileLineTzp/d

%s/ÞtzpThornTzp/Þ/g

0i
.mso pca.tmac
.

endfunc
