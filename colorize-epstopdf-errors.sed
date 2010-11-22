#(##defaults(color_error="", color_reset="") ##)
/^Error:/,/^Execution stack:/{
  /^Execution stack:/d
  s/.*/(##color_error##)&(##color_reset##)/
  p
}
d
