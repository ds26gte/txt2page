.= txt2page

txt2page is a bash/vim script that converts
free-form plain text into HTML, PDF, or docx (LibreOffice).

The external program groff is needed for PDF; pandoc for docx.

Installation: Place the scripts txt2page, txt2page_pdf, and
txt2page_docx in your PATH, and the Vim files txt2page.vim,
tx2page_pdf.vim, and txt2page_docx.vim in your ‘runtimepath’
(typically ~/.vim or ~/.nvim).

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

creates ‘filename.pdf’.

For docx, use the option ‘-Tdocx’. E.g.,

  % txt2page -Tdocx filename.txt

creates ‘filename.docx’.

For HTML, if the ‘-s’ option is not used,

  .so filename Some Additional Description

merely *links* to (the HTML version of) ‘filename’ with ‘Some
Additional Description’ serving as link text.  In troff of
course, both syntaxes cause sourcing of filename, since troff
‘.so’ considers only its first argument.  I had it this way
because it’s a way to coax a Table of Contents into the HTML
without additional markup.

For HTML, if the ‘-s’ option is used, all ‘.so’ calls cause
interpolation (recursively).  This allows you to create one
single all-encompassing HTML page for the document, chasing down
all subfiles.
