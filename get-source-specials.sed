#(##defaults() ##)

# Get special comments (e.g. %%BEAMER or %%GNUPLOT_HEADER=filename)
/^%%[[:space:]]*\([^%].*\)[[:space:]]*$/{
  s//\1/
  s/[[:space:]]//g
  # Special rules for BEAMER (we only understand "BEAMER LARGE" to mean
  # anything, and it gets rewritten to just say "BEAMER").
  # This is here for dvips backward compatibility - it isn't use for direct pdf
  # output.
  /BEAMER/{
    /BEAMERLARGE/!d
    s/.*/BEAMER/
  }
  p
  d
}

# One-line variant of documentclass
/\\documentclass[^{]*{.*}/b procclass

# Get document class info, like whether we're using beamer and (if specified)
# the paper size argument (e.g., "letterpaper").
/\\documentclass/,/}/{
  # Remove comments
  s/%.*//
  # Accumulate
  H
  # If we hit an ending brace (after removing comments), then we have
  # everything we need.
  /}/{
    # Clear out the pattern buffer and get our accumulation into it before
    # processing everything.
    s/.*//
    x
    b procclass
  }
  d
}

d

:procclass
# Remove useless information, like \documentclass, square brackets, and
# anything in curlies.
s/\\documentclass//
s/[][]//g
s/{.*}//
# Kill spaces and newlines, replace commas with spaces, bound entries by spaces
s/[[:cntrl:][:space:]]*//g
s/,/ /g
s/^/ /
s/$/ /
# Find paper size
/.* \([[:alnum:]]\{1,\}\)paper .*/{
  h
  s//PAPERSIZE=\1/
  p
  g
}
# Find orientation
/.* landscape .*/{
  h
  s//ORIENTATION=landscape/
  p
  g
}
d
