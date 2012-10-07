#(##defaults(color_error="", color_warning="", color_reset="") ##)
s/.*not found.*/(##color_error##)&(##color_reset##)/p
/^Error:/,/context:/s/.*/(##color_error##)&(##color_reset##)/p
s/^Warning:.*/(##color_warning##)&(##color_reset##)/p
d
