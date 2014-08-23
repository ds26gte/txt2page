# txt2page

txt2page is a bash/vim/groff script that converts
free-form plain text into HTML and PDF. groff is needed only for PDF.

```
% txt2page filename.txt
```

creates `filename.html`.  Here, txt2page is assumed already placed
in your `PATH`, and `%` is your Un*x command-line prompt.

[List of commands possible.](./cheatsheet.txt)

You can supply groff-like options to txt2page. For HTML, the only
relevant one is `-s`.

For PDF, use the option `-Tpdf` and other usual groff options for
[fonts](./otfgroff.txt), layout, &c. E.g.

```
% txt2page -Tpdf -f baskervald -r PS=31p -r LL=7i -r PO=.63i filename.txt
% txt2page -Tpdf -r PS=14p -r LL=6i -r PO=1.13i filename.txt
```

For HTML, if the `-s` option is not used,

```
 .so filename Some Additional Description
```

merely *links* to (the HTML version of) `filename` with
`Some Additional Description` serving as link text.  In troff of
course, both syntaxes cause sourcing of `filename`.  I had it
this way because it's a way to coax a Table of Contents into the
HTML without additional markup.

If txt2page is called with the `-s` option, however, all `.so`
calls cause interpolation (recursively).  In addition, the
navigation (`.NAV`) commands are ignored.  This allows you to
create one single all-encompassing HTML page for the document,
chasing down all subfiles.
