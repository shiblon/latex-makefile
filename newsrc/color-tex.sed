#(##defaults(color_error="", color_pages="", color_success="", color_reset="",
#             color_warning="", color_overfull="", color_underfull="")
##)
#
# This uses a neat trick from the Sed & Awk Book from O'Reilly:
# 1) If a line has a single ending paren, delete it to make a blank line (so
#  that we catch the first error, which is not always preceded by a blank
#  line).
# 2) Ensure that the last line of the file gets appended to the hold buffer,
#   and blank it out to trigger end-of-paragraph logic below.
# 3) When encountering a blank line (LaTeX output helpfully breaks output on
#   newlines)
#   a) swap the hold buffer (containing the paragraph) into the pattern buffer (putting a blank line into the hold buffer),
#   b) remove the newline at the beginning (don't ask),
#   c) apply any colorizing substitutions necessary to ensure happiness.
#   d) get the newline out of the hold buffer and append it
#   e) profit! (print)
# 4) Anything not colorized is deleted, unless in verbose mode.
${
  /^$/!{
    H
    s/.*//
  }
}
/^$/!{
  H
  d
}
/^$/{
  x
  s/^\n//
  /Output written on /{
    s/.*Output written on \([^(]*\) (\([^)]\{1,\}\)).*/Success!  Wrote \2 to \1/
    s/[[:digit:]]\{1,\}/(##color_pages##)&(##color_reset##)/g
    s/Success!/(##color_success##)&(##color_reset##)/g
    s/to \(.*\)$/to (##color_success##)\1(##color_reset##)/
    b end
  }
  / *LaTeX Error:.*/{
    s/.*\( *LaTeX Error:.*\)/(##color_error##)\1(##color_reset##)/
    b end
  }
  /.*Warning:.*/{
    s//(##color_warning##)&(##color_reset##)/
    b end
  }
  /Underfull.*/{
    s/.*\(Underfull.*\)/(##color_underfull##)\1(##color_reset##)/
    b end
  }
  /Overfull.*/{
    s/.*\(Overfull.*\)/(##color_overfull##)\1(##color_reset##)/
    b end
  }
  d
  :end
  G
}
