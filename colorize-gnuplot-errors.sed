#(##defaults(color_error="", color_reset="") ##)
/, line [0-9]*:/!{
  H
  x
  s/.*\n\(.*\n.*\)$/\1/
  x
}
/, line [0-9]*:/{
  H
  /unknown.*terminal type/{
    s/.*/--- Try changing the GNUPLOT_OUTPUT_EXTENSION variable to 'eps'./
    H
  }
  /gpihead/{
    s/.*/--- This could be a Makefile bug - contact the maintainer./
    H
  }
  g
  s/.*/(##color_error##)&(##color_reset##)/
  p
}
/^gnuplot>/,/^$/{
  s/^gnuplot.*/(##color_error##)&/
  s/^$/(##color_reset##)/
  p
}
d
