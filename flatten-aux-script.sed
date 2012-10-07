#(##defaults() ##)
# Creates a sed script that does aux flattening by finding all of the included
# dependencies.

/\\@input{\(.*\)}/{
  # Get the file name
  s//\1/
  # Escape periods and colons
  s![.:]!\\&!g
  h
  # Emit a test for the file name input
  s!.*!\\:\\\\@input{&}:{!
  p
  x
  # Remove escapes and emit a line that reads the file
  s/\\././g
  s/.*/r &/p
  # Add d and endgroup commands
  s/.*/d/p
  s/.*/}/p
  d
}
d
