#(##defaults(target_files="TARGET_FILES")##)

#(##include("paragraphs.sed")##)

# Inputs don't do file line errors until the middle of the message, weirdly
# enough.
/^! LaTeX Error: File `/{
  b needtwomore
}

# Only one type of thing to look for, so no need to get crazy with the search:
# if we had a multi-paragraph from above, this is it.
/^::0::\(.*\)/{
  # Remove prefix
  s//\1/
  # inputs have a "Default extension" message, anything else is ignored.
  /Default extension: /!d
  # Get the file name and line information
  s/.*File `\([^']*\)' not found.*/\1/
  # Get rid of newlines if they are there
  s/[[:cntrl:]]//
  # Now the pattern buffer contains the bare filename
  # Add .tex if it isn't there already (TODO: is this right?)
  /\.tex/!s/$/.tex/
  # Escape filename spaces if possible
  s/[[:space:]]/\\ /g
  # Add the special MISSING comment
  h
  s/.*/# MISSING input "&" - (presence of comment affects build)/
  p
  s/.*//
  x
  # Add the actual target file to the dependencies.
  s!^.*!(##target_files##): $(call path-norm,&)!
  p
}

# Anything else is not wanted
d
