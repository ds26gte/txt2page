" last modified 2015-05-26
" ds26gte@yahoo.com

func! s:recognizeUrls()

    " someone@gmail.com becomes mailto:someone@gmail.com
    " -- check not already preceded by mailto:
    s#\%(mailto:\)\@<!\<[[:alnum:]]\+@[[:alnum:].]\+\.\%(ca\|com\|edu\|gov\|in\|net\|org\|us\)\>#mailto:&#g

    " evalwhen.com becomes FAKEHTTP://evalwhen.com
    " -- check not preceded by @ or ://
    s#\%(@\|://\)\@<!\<[[:alnum:].-]\+\.\%(com\|co\.[[:lower:]]\{2}\|edu\|net\|org\|[[:lower:]]\{2}\%(js\|ms\|on\|ps\|sh\)\@<!\)\>#FAKEHTTP://&#g

    " mailto:addr becomes <a href="mailto:addr">mailto:addr</a>
    s#\<mailto:\([[:alnum:]]\+@[[:alnum:].]\+[[:alpha:]]\)\>#<a href="&"><span class=url>\1</span></a>#g

    " @twitterhandles
    s#\%([[:alnum:]]\)\@<!@\([[:alnum:]_]\{1,15}\)#*<span class=url>@\1</span>* https://twitter.com/\1#g

    " URL becomes <a href="URL">URL</a>
    s#\<[[:alpha:]-]\+://[^[:space:]()<>\[\]]\+\%(([[:alnum:]]\+)\|/\|[^[:space:][:punct:]»]\)#<a\rÞtzpHrefTzphref="&"\r><span class=url>&</span></a>#g

    " “./sth” becomes <a href="sth">sth</a>
    s#“\./\(.\{-}\)”#<a href="\1"><span class=url>\1</span></a>#g

    " ./pathname becomes <a href="pathname">pathname</a>
    s#\%([.]\)\@<!\./\([^[:space:]()<>&]\+\)\%([[:punct:]]\)\@<!#<a href="\1"><span class=url>\1</span></a>#g

    " FAKEHTTP has done its job by now -- remove it
    "s#FAKEHTTP://##g

    " :emoji:
    s#:\([a-z0-9_\-]\{1,32}\):#<img class=emoji title=":\1:" alt=":\1:" src="https://assets.github.com/images/icons/emoji/\1.png" height=20 width=20 align=absmiddle/>#g

    "images

    s#^\.\s*IMG\s\+\([^-[:space:]]\)#.IMG -center \1#

    s#^\.\s*IMG\s\+-L\s#.IMG -left #
    s#^\.\s*IMG\s\+-C\s#.IMG -center #
    s#^\.\s*IMG\s\+-R\s#.IMG -right #

    s#^\.\s*\(IMG\s\+-[leftcnrigh]\+\s\+\S\+\)\s*$#.\1 50#

    s#^\.\s*IMG\s\+-\([leftcnrigh]\+\)\s\+\(\S\+\)\s\+\([0-9]\+\)#<div class=figure align=\1><img src="\2" width="\3%" border="0" alt=""></div>#

    exec 's:<a href="\(.\{-}\)\.' . g:fileExtension . '"><span class=url>\(.\{-}\)\.' . g:fileExtension . '</span></a>:<a href="\1.html"><span class=url>\2.html</span></a>:g'

    exec 's:<a href="\(.\{-}\)\.' . g:fileExtension . '">:<a href="\1.html">:g'

    exec 's:<a href="\(.\{-}\)\.' . g:fileExtension . '#\(.\{-}\)"><span class=url>\%(.\{-}\)\.' . g:fileExtension . '#\(.\{-}\)</span></a>:<a href="\1.html#\2">\3</a>:g'

    s:\(<a href="#.\{-}">\)<span class=url>#\(.\{-}\)</span>:\1\2:g

endfunc

func! s:cleanUpUrls()
    s/ÞtzpHrefTzphref/ href/
    s#href="FAKEHTTP://#href="http://#
    -1,+1 jo!
    s#FAKEHTTP://##g
    s:«\(<a href.\{-}/a>\)»:\1:g
endfunc

func! s:upcaseDigits(x)
  let l:y = a:x
  let l:y = substitute(l:y, '0', '⁰', 'g')
  let l:y = substitute(l:y, '1', '¹', 'g')
  let l:y = substitute(l:y, '2', '²', 'g')
  let l:y = substitute(l:y, '3', '³', 'g')
  let l:y = substitute(l:y, '4', '⁴', 'g')
  let l:y = substitute(l:y, '5', '⁵', 'g')
  let l:y = substitute(l:y, '6', '⁶', 'g')
  let l:y = substitute(l:y, '7', '⁷', 'g')
  let l:y = substitute(l:y, '8', '⁸', 'g')
  let l:y = substitute(l:y, '9', '⁹', 'g')
  return l:y
endfunc

func! s:findQvUrls()
  v/^ÞtzpPreformattedTzp/ s_\(\\\*\[:\)\s*\%(\\\)\?\s*$_\1ÞtzpQvUrlContinuedTzp_
  g/ÞtzpQvUrlContinuedTzp$/ .,+1 j!
  %s/ÞtzpQvUrlContinuedTzp/ /
  v/^ÞtzpPreformattedTzp/ s/\(\S\)\(\\\*\[:\)/\1 \2/

  v/^ÞtzpPreformattedTzp/ s_\\\*\[:\s\+\(.\{-}\)\s*\]_:\1_g
  v/^ÞtzpPreformattedTzp/ s_:\s*<a href="\(.\{-}\)">.\{-}</a>_<a href="\1">ÞtzpQvUrlTzp</a>_g
  %s/ÞtzpQvUrlTzp/(𝑞.𝑣.)/g
  "%s/ÞtzpQvUrlTzp/(q.v.)/g
  " 𝒒.𝒗. 𝓆.𝓋. 𝓺.𝓿. 𝔮.𝔳. 𝕢.𝕧. 𝖖.𝖛. 𝗾.𝘃.
endfunc

func! s:findUrlhs()
  g/\%(\%(-:\|[᛫‡]\).*\)\@<!<a href="/ s/^/ÞtzpPossibleUrlhTzp/

  g/^ÞtzpPossibleUrlhTzp/ -1s/\%(-:\|[᛫‡]\).\{-}$/&ÞtzpUrlhContinuationLineTzp/

  g/^ÞtzpPossibleUrlhTzp/ -2s/\%(-:\|[᛫‡]\).\{-}$/&ÞtzpUrlhContinuationLineTzp/

  g/ÞtzpUrlhContinuationLineTzp$/ -1s/ÞtzpUrlhContinuationLineTzp$//

  g/ÞtzpUrlhContinuationLineTzp$/ .,/^ÞtzpPossibleUrlhTzp/ j

  %s/ÞtzpPossibleUrlhTzp//

  "g/ÞtzpUrlhContinuationLineTzp$/ .,+1 j

  %s/ÞtzpUrlhContinuationLineTzp//

  v/^ÞtzpPreformattedTzp/ s#\%(-:\|[᛫‡]\)\s*\(.\{-}\)\s*<a href="\(.\{-}\)">.\{-}</a>#<a href="\2">\1</a>#g

endfunc

func! s:redirectIfNecessary()
  v/^ÞtzpPreformattedTzp/ s#<a href="\(.\{-}\)">=REDIRECT=</a>#ÞtzpRedirectTzp{\1}#
  let redirectFoundP = 0
  g/ÞtzpRedirectTzp{.\{-}}/ let redirectFoundP = 1
  if redirectFoundP
    /ÞtzpRedirectTzp/
    norm f{lyi}
    let g:redirectUrl = @0
    g/ÞtzpRedirectTzp{.\{-}}/ s#ÞtzpRedirectTzp{\(.\{-}\)}#If not redirected automatically, go to <a href="\1">\1</a>.#
  endif
endfunc

func! s:verbatimLineAsIsWithContinuation()
  s/\s/Ø/g
  s/^[^Ø]/ÞtzpVerbatimContinuationTzp&/
  s/^Ø//
  s/\([^Ø]\)Ø\([^Ø]\)/\1 \2/g
  s#$#ÞtzpBreakLineTzp#
endfunc

func! s:verbatimLineAsIs()
  s/^$/Ø/
  s/\s/Ø/g
  s/\([^Ø]\)Ø\([^Ø]\)/\1 \2/g
  s#$#<br/>#
endfunc

func! s:codeLineAsIs()
  call s:verbatimLineAsIs()
  s/^/ÞtzpPreformattedTzp/
endfunc

func! Txt2page()

  setl fo-=j

while 1
  if (!$soelim)
    %s/^\.\s*so\s\+\(\S\+\s\+\S\)/ÞtzpSoTOCtzp \1/
  endif
  0
  let m = search('^\.\s*so\s')
  if (m == 0)
    break
  endif
  s/^\.\s*so/ÞtzpSoDoneTzp/
  norm W
  r <cfile>
endwhile

g/^ÞtzpSoDoneTzp/d

"convert all setminuses (U+2216) to backslashes
"(setminus is used in troff source as a convenient nonactive stand-in for backslash)

%s/∖/\\\\/g

"use unabbreviations for these rare characters if they occur verbatim in the source,
"as we'll be using these characters as temporary symbols

%s/Þ/ÞtzpThornTzp/g
%s/^ÞtzpThornTzp\(tzpSoTOCtzp\)/Þ\1/  "! see above
%s/Ø/ÞtzpOslashTzp/g
%s/Æ/ÞtzpAEligTzp/g
%s/«/ÞtzpLangleLangleTzp/g
%s/»/ÞtzpRangleRangleTzp/g

$a
ÞtzpBogusEndOfFileLineTzp
.

"use temp symbols to stand for verbatim &<>; we'll convert them to appropriate HTML entities
"at the end

%s/&/Æ/g
%s/</«/g
%s/>/»/g

"remove all trailing spaces

%s/\s\+$//

let titleText = $g

let g:fileExtension = $ext
if g:fileExtension == ""
    let g:fileExtension = "tzpLetsNotMatchAnythingAgainstThis"
endif

0
let lastline = line('$')
while 1
    let linenum = line('.')
    if linenum > 100 || linenum == lastline
        break
    endif
    let linestr = getline('.')
    if match(linestr, '^\.\s*TH\s\+".\{-}"') > -1
        s/^\.\s*TH\s\+"\(.\{-}\)".*/.TH \1/
        break
    elseif match(linestr, '^\.\s*TH\s\+\(\S\+\)\s\+\S') > -1
        s/^\.\s*TH\s\+\(\S\+\).*/.TH \1/
        break
    endif
    norm j
endwhile

"calc titleText here?

"code display

" troff-friendly triple-backquote env

%s/^\s*\(\`\`\`\+\)/.\1/

%s/^\.\s*\`\`\`\`\+/.EE/

%s/^\.\s*\`\`\`/.EX/

%s/^\.\s*EX\s*[[:alpha:]]\+$/.EX scheme/

if executable('lisphilite')
  g/^\.\s*EX scheme/+1,/^\.\s*EE/-1 s/«/</g
  g/^\.\s*EX scheme/+1,/^\.\s*EE/-1 s/»/>/g
  g/^\.\s*EX scheme/+1,/^\.\s*EE/-1 s/Æ/\&/g
  g/^\.\s*EX scheme/+1,/^\.\s*EE/-1 !lisphilite
endif

g/^\.\s*EX/+1, /^\.\s*EE/-1 call s:codeLineAsIs()

%s#^\.\s*EX\(.*\)#</p>\rÞtzpPreformattedTzp<div class="listing\1"><code>#

%s#^\.\s*EE.*#ÞtzpPreformattedTzp</code></div>\r<p class=noindent>#

"

g/^\.\s*TOC$/d

"

      $a
ÞtzpFiTzp
.

%s/^\.\s*\(nf\|fi\)\(\s\+.*\)\?/.\1/

g/^\.\s*nf$/+1,/^\%(\.\s*fi\|ÞtzpFiTzp\)$/-1 call s:verbatimLineAsIs()

g/^\.\s*\%(nf\|fi\)$/d

g/^ÞtzpFiTzp/d

0
let lastline = line('$')
while 1
  " find the first line with a leading space
  let currline = line('.')
  if currline == 1 && match(getline('.'), '^\s') > -1
    let m = 1
  else
    let m = search('^\s')
  endif
  if m == 0
    break
  endif
  " and mark its end
  s/$/ÞtzpLeadingSpacesStartLineTzp/
  while 1
    " if blank line found, make it a parsep
    if match(getline('.'), '^$') > -1
      s:^$:</p>ÞtzpCarriageReturnTzp<p class=noindent>:
      . -1s:ÞtzpBreakLineTzp$::
      break
    endif
    " if not a blank line, verbatimize it
    call s:verbatimLineAsIsWithContinuation()
    " break on eof
    if line('.') == lastline
      break
    endif
    norm j
  endwhile
  " put a parsep before the start too
  g/ÞtzpLeadingSpacesStartLineTzp/ s#^#</p>ÞtzpCarriageReturnTzp<p class=noindent>ÞtzpCarriageReturnTzp#

  %s/ÞtzpLeadingSpacesStartLineTzp//

  g/^ÞtzpVerbatimContinuationTzp/-1 s:ÞtzpBreakLineTzp$::

  %s/^ÞtzpVerbatimContinuationTzp//
endwhile
" make the parseps neat
%s:ÞtzpCarriageReturnTzp:\r:g

%s:ÞtzpBreakLineTzp$:<br/>:

"v/\%(-:\|[᛫‡]\)/ s/^\.\s*\\\"/ÞtzpDeleteCommentTzp&/
"g/^ÞtzpDeleteCommentTzp/d

"%s/^\.\s*\\\"//

g/^\.\s*\\\"/d
"g/^\.\s*HTL/d
"g/^#\s\+.\{-}\s*##$/d

"bullet items

%s:^•\s\+:</p><p class=bulleted><span class=bullet>•Ø</span>:

"Tables

"for every line starting with |\s, replace it with <space>ÞtzpTableLineTzp

g/^|\s/,/^[^|]/-1 s#^|\s# ÞtzpTableLineTzp#

"collapse successive ÞtzpTableLineTzps together

g/^ ÞtzpTableLineTzp/,/^\%($\|[^ ]\)/-1 j

"remove single space before ÞtzpTableLineTzp

%s/ \(ÞtzpTableLineTzp\)/\1/g

"enclose the collapsed ÞtzpTableLineTzp with <table> tags

%s#^ÞtzpTableLineTzp.*$#</p>\r<div align=center>\r<table border="1" cellpadding="4">&\r</table>\r</div>\r<p>#

"precede each ÞtzpTableLineTzp with a CR

%s#ÞtzpTableLineTzp#\r&#g

"chomp the last | in each table line

g/^ÞtzpTableLineTzp/ s#\s|$##

"replace every other | with a table-cell separator

g/^ÞtzpTableLineTzp/ s#\s|\s#</td><td>#g

"wrap each table-line with a <tr>

%s#^ÞtzpTableLineTzp\(.*\)$#<tr><td>\1</td></tr>#

"g/^ÞtzpBogusEndOfFileLineTzp/d

"visible anchor
"%s:^※\s*\([^[:space:]()<>&#]\+\)$:<span class=anchor><a name="\1"></a>[\1]Ø</span>:
%s:^\.\s*BB\s\+\([^[:space:]()<>&#]\+\)$:<span class=anchor><a name="\1"></a>[\1]</span>:

"invisible anchor
"%s:^⚓\s*\([^[:space:]()<>&#]\+\)$:<a name="\1"></a>:
%s:^\.\s*AN\s\+\([^[:space:]()<>&#]\+\)$:<a name="\1"></a>:

"sections

" troff-friendly .#...

%s/^\.\s*\(#\+\)/\1/

%s/^\.\s*TH\s\+\(.*\)$/ÞtzpSectionTzp title \1/
%s/^\.\s*SH\s\+\(.*\)$/ÞtzpSectionTzp 1 \1/
%s/^\.\s*SS\s\+\(.*\)$/ÞtzpSectionTzp 2 \1/

%s/^#\s\+\(.\{-}\)\s\+#$/ÞtzpSectionTzp title \1/
%s/^#\s\+\(.\{-}\)\s\+##$/ÞtzpSectionTzp htmltitle \1/
%s/^###\s\+###$/ÞtzpSectionTzp dropcap x/

%s/^#\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 1 \1/
%s/^##\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 2 \1/
%s/^###\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 3 \1/
%s/^####\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 4 \1/
%s/^#####\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 5 \1/
%s/^######\s\+\(.\{-}\)\s*#*$/ÞtzpSectionTzp 6 \1/

%s/^\.\s*=\{1}\s\+\(\S\)/ÞtzpTroffSectionTzp 1 \1/
%s/^\.\s*=\{2}\s\+\(\S\)/ÞtzpTroffSectionTzp 2 \1/
%s/^\.\s*=\{3}\s\+\(\S\)/ÞtzpTroffSectionTzp 3 \1/
%s/^\.\s*=\{4}\s\+\(\S\)/ÞtzpTroffSectionTzp 4 \1/
%s/^\.\s*=\{5}\s\+\(\S\)/ÞtzpTroffSectionTzp 5 \1/
%s/^\.\s*=\{6}\s\+\(\S\)/ÞtzpTroffSectionTzp 6 \1/

g/^ÞtzpTroffSectionTzp/,/^$/-1 j

g/^ÞtzpSectionTzp/,/./-1 j!

%s/^ÞtzpTroffSectionTzp/ÞtzpSectionTzp/

g/^ÞtzpSectionTzp\s\+htmltitle\s\+/d

%s:^ÞtzpSectionTzp\s\+\(title\)\s\+\(.*\):</p>\r<h1 class=\1>\2</h1>\r<p class=noindent>:
%s:^ÞtzpSectionTzp\s\+\([1-6]\)\s\+\(.*\):</p>\r<h\1 class=section>\2</h\1>\r<p class=noindent>:

let lastline = line('$')
let ln = 0
while ln < 100 && ln < lastline
  let x = getline(ln)
  if match(x, '^<h[0-9]\+.\{-}>') > -1
    let titleText = substitute(x, '^<h[0-9]\+.\{-}>\(.\{-}\)<\/h[0-9]>', '\1', '')
    break
  endif
  let ln+=1
endwhile

"drop cap

%s/^ÞtzpSectionTzp\s\+dropcap\s\+.*/ÞtzpDropCapTzp/

g/^ÞtzpDropCapTzp$/ , +1 j

%s:^ÞtzpDropCapTzp\s*\(.\{-}[[:alnum:]]\):</p>\r<p class=noindent><span class=dropcap>\1</span>:

"

v/^ÞtzpPreformattedTzp/ s/^\([^@].\{-}\\\*\[\%(\^\|::\)\s*[^]]\{-}\)\\\$/\1 ÞtzpContinuationLineTzp/

g/\\\*\[\%(\^\|::\)\s*[^]]\{-}ÞtzpContinuationLineTzp$/ .,+1 j!

%s/ÞtzpContinuationLineTzp//

"footnotes

" (†sym) becomes call to footnote

v/^ÞtzpPreformattedTzp/ s:(†\([^()[:space:]]\+\)):<a name="callFootnote_\1" href="#footnote_\1">ÞtzpFootnoteMarkTzp\1ÞtzpFootnoteMarkEndTzp</a>:g

" ensure footnote text start/end is at bol

v/^ÞtzpPreformattedTzp/ s:\(.\)\((†\|†)\):\1\r\2:g

" put footnote text's symbol line on own line

%s:^(†\s*\(\S\+\)\s\+\(\S\):(†\1\r\2:

" move text following footnote text's end to a new line after

%s:^\(†)\)\s*\(\S\):\1\r\2:

" mark footnote text start line

%s:^(†\s*\(\S\+\)\?\s*$:ÞtzpFootnoteEnvTzp \10:

%s:^\.FS\s*\(\S\+\)\?\s*$:ÞtzpFootnoteEnvTzp \10:

" mark its end line

%s:^†)\s*$:ÞtzpFootnoteEnvTzp1:

%s:^\.FE\s*$:ÞtzpFootnoteEnvTzp1:

" if footnote text has no symbol, specify a dummy symbol

%s/^\(ÞtzpFootnoteEnvTzp\)0$/\1 ÞtzpUnmarkedFootnoteTzp0/

"put a ÞtzpFootnoteTzp before every footnote line
g/^ÞtzpFootnoteEnvTzp.*0$/,/^ÞtzpFootnoteEnvTzp.*1$/ s/^/ÞtzpFootnoteTzp/

"wrap all footnote lines from one footnote into one combined line
g/^ÞtzpFootnoteTzpÞtzpFootnoteEnvTzp.*0$/,/^ÞtzpFootnoteTzpÞtzpFootnoteEnvTzp.*1$/ j!

"move all the footnote combilines to the file's end
g/^ÞtzpFootnoteTzpÞtzpFootnoteEnvTzp/ m$

"put a ÞtzpStartFootnotesTzp ahead of the first footnote combiline
/^ÞtzpFootnoteTzpÞtzpFootnoteEnvTzp/ s/^/ÞtzpStartFootnotesTzp\r/

"put a ÞtzpEndFootnotesTzp after the last footnote combiline
$ s/^\(ÞtzpFootnoteTzpÞtzpFootnoteEnv.*\)/\1\rÞtzpEndFootnotesTzp/

"use Þtzp{Start,End}FootnotesTzp to wrap a <div>

/^ÞtzpStartFootnotesTzp/ s#^.*$#</p>\r<div class=footnotes>\r<hr align=left width="40%"/><p>#
/^ÞtzpEndFootnotesTzp/   s#^.*$#</p>\r</div><p>#

"use ÞtzpFootnoteTzp to un-combine the combilines into individual lines again
%s/\(.\)\(ÞtzpFootnoteTzp\)/\1\r\2/g

"do it once more to pick up adjacent ÞtzpFootnoteTzp's
%s/\(.\)\(ÞtzpFootnoteTzp\)/\1\r\2/g

"throw away each footnote's end marker: its job is done
%s/^ÞtzpFootnoteTzpÞtzpFootnoteEnv.*1$//

"use each footnote's start marker to typeset its symbol (if any)

%s:^ÞtzpFootnoteTzpÞtzpFootnoteEnvTzp ÞtzpUnmarkedFootnoteTzp0$:\r:

%s:^ÞtzpFootnoteTzpÞtzpFootnoteEnvTzp \(\S\+\)0$:\r<a name="footnote_\1" href="#callFootnote_\1">ÞtzpFootnoteMarkTzp\1ÞtzpFootnoteMarkEndTzp</a>:

%s:^ÞtzpFootnoteTzp::

%s/ÞtzpFootnoteMarkTzp\(.\{-}\)ÞtzpFootnoteMarkEndTzp/\=s:upcaseDigits(submatch(1))/g

"end footnotes

"%s#^:\([^:]\+\):#</p>\r<p class=noindent><span class=dropcap>\1</span>#

"%s#^:\s\+\(\%([0-9]\+\.\)*[0-9]\+\)\.\s#</p>\r<p class=beginsection><span class=dropcap>\1</span> #
"%s#^:\s\+\([^A-Z0-9]*[A-Z0-9]\)#</p>\r<p class=beginsection><span class=dropcap>\1</span>#

%s#^\s*-\{5,}$#<hr/>#
%s#^\.\s*--\(\s.*\)\?$#<hr noshade size="1"/>#
%s#^\.\s*==\(\s.*\)\?$#<hr noshade size="5"/>#

"

"if "$prevPage" != "" || "$nextPage" != ""
"  1s:^:ÞtzpNavbarTzp<a href="$prevPage">previous</a>, <a href="$nextPage">next</a> page\r:
"  $s:$:\rÞtzpNavbarTzp<a href="$prevPage">previous</a>, <a href="$nextPage">next</a> page:
"endif
"
"g/^ÞtzpNavbarTzp/ s:<a href="">\(.\{-}\)</a>:<span class=grayed>\1</span>:g
"
"%s:^ÞtzpNavbarTzp\(.*\)$:<div align=right><span class=navbar>[Go to \1]</span></div>:

/^\.NAV/ m $

      $ /^\.NAV/ co 0

%s:^\.NAV.*:\r\0\r:

%s:^\.NAV\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(\S\+\):ÞtzpNavbarTzp<a href="\1">previous</a>, <a href="\2">next</a> page; <a href="\3">contents</a>; <a href="\4">index</a>:
%s:^\.NAV\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(\S\+\):ÞtzpNavbarTzp<a href="\1">previous</a>, <a href="\2">next</a> page; <a href="\3">contents</a>:
%s:^\.NAV\s\+\(\S\+\)\s\+\(\S\+\):ÞtzpNavbarTzp<a href="\1">previous</a>, <a href="\2">next</a> page:
%s:^\.NAV\s\+\(\S\+\):ÞtzpNavbarTzp<a href="\1">next</a> page:

g/^ÞtzpNavbarTzp/ s:<a href="_">\(.\{-}\)</a>:<span class=grayed>\1</span>:g

%s:^ÞtzpNavbarTzp\(.*\)$:<div align=right><span class=navbar>[Go to \1]</span></div>:

%s:^ÞtzpSoTOCtzp\s\+\(\S\+\)\s\+\(.*\):<a href="\1">\2</a><br/>:

"empty lines are paragraph separators, but collapse adjacent empty lines first

v/./,/./-j

%s#^$#</p>\r\r<p>#

"g/^<p>$/,+1 j!

"%s#^<p>\(\%([A-Z0-9]\+\.\)\+\)\s#<p><b>\1</b> #

v/^ÞtzpPreformattedTzp/ s#\`\`\(.\{-1,}\)\`\`#<code>\1</code>#g

v/^ÞtzpPreformattedTzp/ s#\`\(.\{-1,}\)\`#<code>\1</code>#g

g/^ÞtzpBogusEndOfFileLineTzp/d

v/^ÞtzpPreformattedTzp/ call s:recognizeUrls()

g/^ÞtzpHrefTzphref=/ call s:cleanUpUrls()

call s:findQvUrls()

call s:findUrlhs()

call s:redirectIfNecessary()

%s/^ÞtzpPreformattedTzp//
%s/ÞtzpPreformattedTzp/\r/g

%s/«/\&lt;/g
%s/»/\&gt;/g
%s/Æ/\&amp;/g
%s/Ø/ /g "space is actually u+00a0

%s/ÞtzpThornTzp/Þ/g

%s/ÞtzpAEligTzp/Æ/g
%s/ÞtzpLangleLangleTzp/«/g
%s/ÞtzpOslashTzp/Ø/g
%s/ÞtzpRangleRangleTzp/»/g

"add html boilerplate and title

0i
<!DOCTYPE html>
<html lang="en">
<!--
Generated from MYSOURCEFILE by txt2page, version MYVERSION
Copyright (C) 2010-2015 Dorai Sitaram
-->
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="MYCSSFILE" />
<title>MYTITLE</title>
</head>
<body>
<p>
.

$a
</p>
</body>
</html>
.

exec '5,10s#MYTITLE#' . $g . '#'

exec '1,5s#MYSOURCEFILE#' . $f . '#'

exec '1,5s#MYVERSION#' . $ver . '#'

exec '5,10s#MYCSSFILE#' . $cssf . '#'

if exists('g:redirectUrl')
  5,15s#</head>#<meta http-equiv="refresh" content="1;ÞtzpRedirectUrlTzp">\r\0#
  let @0 = g:redirectUrl
  5,15s/ÞtzpRedirectUrlTzp/\=@0/
endif

endfunc
