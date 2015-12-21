" last modified 2015-11-27
" ds26gte@yahoo.com

func! s:troffRecognizeUrls()
    " evalwhen.com
    " -- check not preceded by @
    s#\%(@\)\@<!\<[[:alnum:].-]\+\.\%(com\|co\.[[:lower:]]\{2}\|edu\|net\|org\|[[:lower:]]\{2}\%(js\|ms\|on\|ps\|sh\)\@<!\)\>#FAKEHTTP://&#g

    " URL
    s#\<[[:alpha:]-]\+://[^[:space:]()<>\[\]]\+\%(([[:alnum:]]\+)\|/\|[^[:space:][:punct:]]\)#ÞtzpUrlBeginTzp&ÞtzpUrlEndTzp#g

    s#FAKEHTTP://##g

    " ./pathname
    s#\%([.]\)\@<!\./\([^[:space:]()<>&]\+\)\%([[:punct:]]\)\@<!#ÞtzpUrlBeginTzp\1ÞtzpUrlEndTzp#g

    s;link:\(.\{-}\)\[\];\1;g

    s;link:.\{-}\[\(.\{-}\)\];\1;g

    s:\(ÞtzpUrlBeginTzp\)[^#]\{-}#\([^#]\{-}\)\(ÞtzpUrlEndTzp\):\1[\2]\3:g

    " rm Url markers
    "s:ÞtzpUrlBeginTzp\(.\{-}\)ÞtzpUrlEndTzp:\1:g
endfunc

func! s:troffFindQvUrls()
  v/^ÞtzpPreformattedTzp/ s/ÞtzpDoubleBackslashTzp\(\*\[:\s\+.\{-}\s*\]\)/ÞtzpBackslashTzp\1/
  "v/^ÞtzpPreformattedTzp/ s/\%(\[\)\@<!\s*:\s*ÞtzpUrlBeginTzp.\{-}ÞtzpUrlEndTzp//g
endfunc

func! s:troffFindUrlhs()

  v:^ÞtzpPreformattedTzp: s:ÞtzpUrlEndTzp\[[^\]]*$:&ÞtzpUrlhFirstLineTzp:

  g:ÞtzpUrlhFirstLineTzp$: +1s:^[^\]]*$:&ÞtzpUrlhContinuationLineTzp:
  g:ÞtzpUrlhFirstLineTzp$: +2s:^[^\]]*$:&ÞtzpUrlhContinuationLineTzp:

  g:ÞtzpUrlhContinuationLineTzp: +1s:ÞtzpUrlhContinuationLineTzp$::

  g:ÞtzpUrlhFirstLineTzp: .,/ÞtzpUrlhContinuationLineTzp$/ j

  %s:ÞtzpUrlh\%(First\|Continuation\)LineTzp::

    " rm Url markers
    v:^ÞtzpPreformattedTzp: s:ÞtzpUrlBeginTzp\%(.\{-}\)ÞtzpUrlEndTzp\[\(.\{-}\)\]:\1:g

    v:^ÞtzpPreformattedTzp: s:ÞtzpUrl\%(Begin\|End\)Tzp::g
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

  setl fo-=j

%s/⋆/*/g

%s/Þ/ÞtzpThornTzp/g

%s/\s\+$//

$a
ÞtzpBogusEndOfFileLineTzp
.

"code display

func! Toggle01(...)
  if a:0
    let b:toggle01Value = 1
  else
    let b:toggle01Value = !b:toggle01Value
    return b:toggle01Value
  endif
endfunc

%s:^----$:ÞtzpListingTzp:

call Toggle01(0)

g:^ÞtzpListingTzp: s:^ÞtzpListingTzp:\=submatch(0) . Toggle01():

%s:^ÞtzpListingTzp0:.EX:

%s:^ÞtzpListingTzp1:.EE:

g/^\.\s*EX/+1, /^\.\s*EE/-1 s/^/ÞtzpPreformattedTzp/

"comment

g/^\.\s*\\\"/d

"horiz bars

%s/^\s*-\{5,}$//

"%s:\\\\":ÞtzpBackslashTzpÞtzpDoubleQuoteTzp:g

"bullet items

%s;^-\s;\r• ;

"sections

"%s/^#\s\+\(.\{-}\)\s\+#$/ÞtzpSectionTzp title \1/
"%s/^#\s\+\(.\{-}\)\s\+##$/ÞtzpSectionTzp htmltitle \1/
"%s/^###\s\+###$/ÞtzpSectionTzp dropcap x/

%s/^=\s\+\(.\{-}\)\s*=*$/ÞtzpSectionTzp 1 \1/
%s/^==\s\+\(.\{-}\)\s*=*$/ÞtzpSectionTzp 2 \1/
%s/^===\s\+\(.\{-}\)\s*=*$/ÞtzpSectionTzp 3 \1/
%s/^====\s\+\(.\{-}\)\s*=*$/ÞtzpSectionTzp 4 \1/
%s/^=====\s\+\(.\{-}\)\s*=*$/ÞtzpSectionTzp 5 \1/
%s/^======\s\+\(.\{-}\)\s*=*$/ÞtzpSectionTzp 6 \1/

"g/^ÞtzpSectionTzp/,/./-1 j!

g/^ÞtzpSectionTzp\s\+htmltitle\s/d

"

%s/^ÞtzpSectionTzp\s\+title\s\+\(.*\)$/.Title \1/

%s/^ÞtzpSectionTzp\s\+\([1-6]\)\s\+\(.*\)$/.SH \1\r\2/

"drop cap

%s/^ÞtzpSectionTzp\s\+dropcap\s\+.*/ÞtzpDropCapTzp/

g/^ÞtzpDropCapTzp$/ , /./ j

%s/^ÞtzpDropCapTzp\s*\(.\{-}[[:alnum:]]\)\(\S*\)\s*/.DC \1 \2\r/

"

v/^ÞtzpPreformattedTzp/ s:\\\\:ÞtzpDoubleBackslashTzp:g

" footnotes

v/^ÞtzpPreformattedTzp/ s:(†\([^()[:space:]]\+\)):\\*{\1\\*}:g

"

g/^ÞtzpPreformattedTzp/ s:\\\\:ÞtzpBackslashETzp:g

v/^ÞtzpPreformattedTzp/ call s:troffRecognizeUrls()

call s:troffTables()

"call s:troffFindQvUrls()

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
.mso pca-so.tmac
.

endfunc
