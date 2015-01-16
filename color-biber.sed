#(##defaults(color_info="", color_warning="", color_error="", color_reset="") ##)
s/^INFO - .*/(##color_info##)&(##color_reset##)/
s/^WARN - .*/(##color_warning##)&(##color_reset##)/
s/^ERROR - .*/(##color_error##)&(##color_reset##)/
s/^Warning--.*/(##color_warning##)&(##color_reset##)/