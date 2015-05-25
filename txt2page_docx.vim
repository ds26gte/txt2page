" last modified 2015-05-25

func! Txt2docx()
  "remove so spoors
  g/^\.lf\s\d\+\s.*$/d

  "remember original big thorns
  %s/Þ/ÞtzpThornTzp/g

  "code display

  g/^\.\s*EX/+1, /^\.\s*EE/-1 s/^/ÞtzpPreformattedTzp/

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

  "inline code

  v/^ÞtzpPreformattedTzp/ s/\\fC\([^`]\{-1}\)\\fP/`\1`/g
  v/^ÞtzpPreformattedTzp/ s/\\fC\(.\{-}\)\\fP/``\1``/g

  %s/^ÞtzpPreformattedTzp//

  %s/ÞtzpThornTzp/Þ/g
endfunc
