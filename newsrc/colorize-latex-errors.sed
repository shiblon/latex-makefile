#(##defaults(driver_pattern="h\(dvi\)\{0,1\}pdf.*",
#             driver_error="Hyperref options don't match",
#             color_error="",
#             color_reset="") ##)
$ b para
/^$/b para
H
d
:para
x
/^$/d
s/^\n*//
/^! LaTeX Error: File /{
  s/^/::DOUBLE_PARAGRAPH::/
  h
  d
}
s/^::DOUBLE_PARAGRAPH:://
/\.cls' not found/{
  s/\(.*not found\.\).*/(##color_error##)\1(##color_reset##)/
  p
  d
}
/could not locate the file with any of these extensions:/d
/Missing .begin.document/{
  h
  s/.*/Are you trying to build an include file?/
  x
  G
}
/ LaTeX Error: Cannot determine size/d
s/.* LaTeX Error .*/(##color_error##)&(##color_reset##)/p
s/Error: pdflatex (file .*/(##color_error##)& - try specifying it without an extension(##color_reset##)/p
/.*\*hyperref using .*driver \([^\*]*\)\*.*/{
  s//\1/
  /^(##driver_pattern##)$/!{
    s/.*//
    p
    s/.*/(##color_error##)--- Using incorrect driver for hyperref! ---(##color_reset##)/
    p
    s/.*/(##color_error##)(##driver_error##)(##color_reset##)/
    p
  }
  d
}
/ LaTeX Error: Unknown graphics extension/{
  s/^/     /
  h
  s/.*/--- Graphics extension error:/
  G
  h
  s/.*/--- If you specified the extension explicitly in your .tex file, try removing it./
  H
  g
  s/.*/(##color_error##)&(##color_reset##)/
  p
  s/.*//
  h
  b
}
s/.*\(\n\{2,\}![[:space:]][^[:space:]]*[[:space:]]Error .*\)/(##color_error##)\1(##color_reset##)/p
d
