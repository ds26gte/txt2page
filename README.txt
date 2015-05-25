.= txt2page

txt2page is a bash/vim/groff script that converts
free-form plain text into HTML or PDF. groff is needed only for PDF.

Installation: Place the scripts txt2page and txt2page_pdf in your
PATH, and the Vim files txt2page.vim and tx2page_pdf.vim in your
‘runtimepath’ (typically ~/.vim or ~/.nvim).

  % txt2page filename.txt

creates ‘filename.html’.

Here, ‘%’ is your Un*x command-line prompt. The source-file
extension doesn’t have to be ‘.txt’: it can be anything or
nothing.

You can supply groff-like options to txt2page. For HTML, the only
relevant one is ‘-s’.

For PDF, use the option ‘-Tpdf’ and other usual groff options for
fonts, layout, &c. E.g.,

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
