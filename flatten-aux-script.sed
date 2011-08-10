#(##defaults() ##)
# Creates a sed script that does aux flattening by finding all of the included
# dependencies.

/\\@input{\(.*\)}/{
  s//\1/
  s![.:]!\\&!g
  h
  s!.*!\\:\\\\@input{&}:{!
  p
  x
  s/\\././g
  s/.*/r &/p
  s/.*/d/p
  s/.*/}/p
  d
}
d
