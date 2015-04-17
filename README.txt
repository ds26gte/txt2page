.= txt2page

txt2page is a bash/vim/groff script that converts
free-form plain text into HTML or PDF. groff is needed only for PDF.

  % txt2page filename.txt

creates ‘filename.html’.  Here, txt2page is assumed already placed
in your PATH, and ‘%’ is your Un⋆x command-line prompt. The
source-file extension doesn’t have to be ‘.txt’: it can be
anything or nothing.

You can supply groff-like options to txt2page. For HTML, the only
relevant one is ‘-s’.

For PDF, use the option ‘-Tpdf’ and other usual groff options for
fonts, layout, etc. E.g.

  % txt2page -Tpdf -r PS=14p -r PI=1.5m -r LL=6i -r PO=1.13i filename.txt

For HTML, if the ‘-s’ option is not used,

  .so filename Some Additional Description

merely *links* to (the HTML version of) ‘filename’ with
‘Some Additional Description’ serving as link text.  In troff of
course, both syntaxes cause sourcing of filename.  I had it
this way because it’s a way to coax a Table of Contents into the
HTML without additional markup.

If txt2page is called with the ‘-s’ option, however, all ‘.so’
calls cause interpolation (recursively).  This allows you to
create one single all-encompassing HTML page for the document,
chasing down all subfiles.
