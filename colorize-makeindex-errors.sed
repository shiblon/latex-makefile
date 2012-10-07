#(##defaults(color_error="", color_reset="") ##)
/^!! /{
  N
  s/^.*$/(##color_error##)&(##color_reset##)/
  p
}
d
