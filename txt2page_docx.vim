" last modified 2015-05-25

func! s:txt2page_docx_delete_qv_urls()
  v/^ÞtzpPreformattedTzp/ s/\(\\\*\[:\)\s*\%(\\\)$/\1ÞtzpQvUrlContinuedTzp/
  g/ÞtzpQvUrlContinuedTzp$/ .,+1 j!
  %s/ÞtzpQvUrlContinuedTzp/ /
  v/^ÞtzpPreformattedTzp/ s/\\\*\[:\s*.\{-}\]//g
endfunc

func! Txt2docx()
  "remove so spoors
  g/^\.lf\s\d\+\s.*$/d

  "remember original big thorns
  %s/Þ/ÞtzpThornTzp/g

  "code display

  g/^\.\s*EX/+1, /^\.\s*EE/-1 s/^/ÞtzpPreformattedTzp/

  %s/^\.\s*E[XE].*/```/

  "comment

  g/^\.\s*\\\*/d

  "sections

  %s/^\.\s*======\s\+/###### /
  %s/^\.\s*=====\s\+/##### /
  %s/^\.\s*====\s\+/#### /
  %s/^\.\s*===\s\+/### /
  %s/^\.\s*==\s\+/## /
  %s/^\.\s*=\s\+/# /

  "italics

  v/^ÞtzpPreformattedTzp/ s/\\fI\(.\{-}\)\\fP/*\1*/g

  "qv-type URLs

  call s:txt2page_docx_delete_qv_urls()

  "inline code

  v/^ÞtzpPreformattedTzp/ s/\\fC\([^`]\{-1}\)\\fP/`\1`/g
  v/^ÞtzpPreformattedTzp/ s/\\fC\(.\{-}\)\\fP/``\1``/g

  %s/^ÞtzpPreformattedTzp//

  %s/ÞtzpThornTzp/Þ/g
endfunc
