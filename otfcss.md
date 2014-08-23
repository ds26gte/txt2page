# Using OpenType Fonts in CSS #

Keep the directory containing the OTF inside your public_html.

In the CSS file, have:

```
@font-face {
    font-family: baskervald;
    src: url('../groffonts/devps/BaskervaldADFStd.otf');
}

body {
    font-family: baskervald, serif;
}
```
