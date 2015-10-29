" last modified 2015-10-29
" ds26gte@yahoo.com

func! s:txt2page_docx_delete_qv_urls()
  v/^ÞtzpPreformattedTzp/ s/\(\\\*\[:\)\s*\%(\\\)$/\1ÞtzpQvUrlContinuedTzp/
  g/ÞtzpQvUrlContinuedTzp$/ .,+1 j!
  %s/ÞtzpQvUrlContinuedTzp/ /
  v/^ÞtzpPreformattedTzp/ s/\\\*\[:\s*.\{-}\]//g
endfunc

func! s:troffRecognizeUrls()
  v/^ÞtzpPreformattedTzp/ s_\(\\\*\[url\)\s*\%(\\\)\s*$_\1ÞtzpQvUrlContinuedTzp_
  g/ÞtzpQvUrlContinuedTzp$/ .,+1 j!
  %s/ÞtzpQvUrlContinuedTzp/ /

  g/\%(\\\*\[url\s\+.*\)\@<!\\Æ/ s/^\%(ÞtzpPreformattedTzp\)\@!/ÞtzpPossibleUrlhTzp/

  g/^ÞtzpPossibleUrlhTzp/ -1s/\\\*\[url\s.*$/&ÞtzpUrlhContinuationLineTzp/
  g/^ÞtzpPossibleUrlhTzp/ -2s/\\\*\[url\s.*$/&ÞtzpUrlhContinuationLineTzp/

  g/ÞtzpUrlhContinuationLineTzp$/ -1s/ÞtzpUrlhContinuationLineTzp$//

  g/ÞtzpUrlhContinuationLineTzp$/ .,/^ÞtzpPossibleUrlhTzp/ j

  %s/ÞtzpPossibleUrlhTzp//

  %s/ÞtzpUrlhContinuationLineTzp//

  v/ÞtzpPreformattedTzp/ s_\\\*\[url\s\+\(.\{-}\)\]\(.\{-}\)\\Æ_[\2](\1)_g

endfunc

func! Txt2docx()
  setl fo-=j
  setl bh=wipe

  "remove so spoors
  g/^\.lf\s\d\+\s.*$/d

  "remember original big thorns
  %s/Þ/ÞtzpThornTzp/g
  %s/Æ/ÞtzpAEligTzp/g

  %s/&/Æ/g

  "code display

  g/^\.\s*EX/+1, /^\.\s*EE/-1 s/^/ÞtzpPreformattedTzp/

  %s/^\.\s*E[XE].*/```/

  "remove trailing spaces (incl u+00a0)

  %s/[  ]*$//

  "for nonflushleft lines, add 2 trailing spaces

  g/^[  ]/ s/$/  /

  "for blank lines, remove all spaces

  %s/^[  ]\+$//

  "convert all leading spaces to u+00a0

  %s/\%(^[  ]*\)\@<= / /g

  "convert all internal u+00a0s to regular spaces

  %s/\%(^[^  ].*\)\@<= / /g

  "comment

  g/^\.\s*\\\*/d

  "troff sections

  %s/^\.\s*TL$/ÞtzpTroffSectionTzp 1/

  %s/^\.\s*TH\s\+"\(.\{-}\)".*/ÞtzpTroffSectionTzp 1 \1/

  %s/^\.\s*SH$/ÞtzpTroffSectionTzp 3/
  %s/^\.\s*SH\s\+\([0-9]\+\)$/ÞtzpTroffSectionTzp \1/
  %s/^\.\s*SH\s\+\(.*\)$/ÞtzpSectionTzp 1 \1/
  %s/^\.\s*SS\s\+\(.*\)$/ÞtzpSectionTzp 2 \1/

  g/^ÞtzpTroffSectionTzp/,/^$/-1 j

  %s/^ÞtzpTroffSectionTzp/ÞtzpSectionTzp/

  "sections

  %s/^ÞtzpSectionTzp\s\+1\s\+/# /
  %s/^ÞtzpSectionTzp\s\+2\s\+/## /
  %s/^ÞtzpSectionTzp\s\+3\s\+/### /
  %s/^ÞtzpSectionTzp\s\+4\s\+/#### /
  %s/^ÞtzpSectionTzp\s\+5\s\+/##### /
  %s/^ÞtzpSectionTzp\s\+6\s\+/###### /

  "italics

  v/^ÞtzpPreformattedTzp/ s/\\fI\(.\{-}\)\\fP/*\1*/g
  v/^ÞtzpPreformattedTzp/ s/\\fB\(.\{-}\)\\fP/**\1**/g

  "qv-type URLs

  call s:txt2page_docx_delete_qv_urls()

  "inline code

  v/^ÞtzpPreformattedTzp/ s/\\fC\([^`]\{-1}\)\\fP/`\1`/g
  v/^ÞtzpPreformattedTzp/ s/\\fC\(.\{-}\)\\fP/``\1``/g

  "footnotes

  %s:^\.FS\s*\(\S*\):/* (†\1):
  %s:^\.FS:/*:
  %s:^\.FE:*/:

  call s:troffRecognizeUrls()

  %s/^ÞtzpPreformattedTzp//

  %s/\\Æ//g
  %s/Æ/\&/g

  %s/ÞtzpThornTzp/Þ/g
  %s/ÞtzpAEligTzp/Æ/g
endfunc
