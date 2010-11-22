#(##defaults(color_error="", color_warning="", color_reset="") ##)
/^Error:/,/context:/s/.*/(##color_error##)&(##color_reset##)/p
s/^Warning:.*/(##color_warning##)&(##color_reset##)/p
d
