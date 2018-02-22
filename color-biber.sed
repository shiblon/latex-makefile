#(##defaults(color_info="", color_warning="", color_error="", color_reset="") ##)

# color info
s/^INFO - .*/(##color_info##)&(##color_reset##)/

# color warning
s/^WARN - .*/(##color_warning##)&(##color_reset##)/

# color error
s/^ERROR - .*/(##color_error##)&(##color_reset##)/

# color warning
s/^Warning--.*/(##color_warning##)&(##color_reset##)/
