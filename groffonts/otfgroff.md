# Adding OpenType Fonts to groff #

groff comes with a set of fonts in its
default font directory, which is something like
`/usr/share/groff/current/font`.  This contains
subdirectories `devps`, `devdvi` &c.  In order to add your own fonts,
it is best to create your own font directory on this model, e.g.,
create a directory `groffonts` somewhere in your space, and in it
make a
subdirectory `devps`.  To inform groff of this addition, set the
environment variable `GROFF_FONT_PATH`:

```
export GROFF_FONT_PATH=~/groffonts
```

Let us now add the Baskervald OpenType font (OTF) to groff.
Baskervald is a Baskerville-like free font available from
http://arkandis.tuxfamily.org/adffonts.html.  Unpack the provided zip
file and add four of the OTF files, viz.

```
BaskervaldADFStd.otf
BaskervaldADFStd-Italic.otf
BaskervaldADFStd-Bold.otf
BaskervaldADFStd-BoldItalic.otf
```

to your `groffonts/devps` directory.  These are now to be
transformed into a four-element *font family* that is suitable for groff.
To do this, copy the script [otf2groff.sh](./otf2groff.sh)
into your `groffonts/devps`.
`otf2groff.sh` takes two arguments, the
name of the OTF font and the name preferred for the corresponding
groff font.  E.g.,

```
otf2groff.sh BaskervaldADFStd.otf baskervaldR
```

This creates the groff font `baskervaldR` and adds a line to a file
`download.addition`, creating it if it doesn't exist.  Here, the
prefix `baskervald`
identifies the family name that will be used by groff, and the
suffix `R` denotes that it is the "regular" (default, normal,
upright) style.

Similarly, convert the other Baskervald OTFs, taking care to use
the same prefix (`baskervald`) and the suffixes `I`, `B`, and
`BI` for
the italic, bold and bold-italic styles.  The `download.addition`
file should now contain

```
BaskervaldADFStd BaskervaldADFStd.pfa
BaskervaldADFStd-Bold BaskervaldADFStd-Bold.pfa
BaskervaldADFStd-Italic BaskervaldADFStd-Italic.pfa
BaskervaldADFStd-BoldItalic BaskervaldADFStd-BoldItalic.pfa
```

Add these lines to `groffonts/devps/download`.  (Create an empty
`download` file if it doesn't already exist.)

You're now ready to use the `baskervald` font in groff.  Call groff
with the option `-f baskervald` on your document, say `doc.ms`.

```
groff -f baskervald -ms doc.ms > doc.ps
ps2pdf doc.ps doc.pdf
```

`doc.pdf` should now be in Baskervald rather than groff's default
Times.

It is also possible to set the font family within the groff
document, using the command

```
.fam baskervald
```

## Using single-style fonts

You may prefer to use just one style of an OTF, perhaps because
the OTF comes in only one style.  Let's say we want to set the
body text in EB Garamond, obtainable from
http://fontsquirrel.com/fonts/eb-garamond.  As above, copy the
`EBGaramond.otf` to `groffonts/devps` and convert it to the groff
font `ebgaramondR`:

```
otf2groff.sh EBGaramond.otf ebgaramondR
```

and add the `download.addition` line to `devps/download`

In your document, have

```
.fp 1 ebgaramondR
```

Sometimes, the single style you want is the bold, possibly for
section headers.  Thus, to use the bold from TeX Gyre Pagella,
(available at
http://www.gust.org.pl/projects/e-foundry/tex-gyre/pagella),
call

```
otf2groff.sh texgyrepagella-bold.otf pagellaB
```

add the corresponding line from `download.addition` to
`devps/download`, and in your
document, call

```
.ftr B pagellaB
```