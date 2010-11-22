#(##defaults(color_warning="", color_error="", color_reset="") ##)
s/^Warning--.*/(##color_warning##)&(##color_reset##)/
t
/---/,/^.[^:]/{
  H
  /^.[^:]/{
    x
    s/\n\(.*\)/(##color_error##)\1(##color_reset##)/
    p
    s/.*//
    h
    d
  }
  d
}
/(.*error.*)/s//(##color_error##)&(##color_reset##)/
d
