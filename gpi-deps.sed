#(##defaults(targets="TARGETS")##)

/^[[:space:]]*s\{0,1\}plot/,/[^\\]$/{
 H
 /[^\\]$/{
  s/.*//
  x
  s/\\\{0,1\}\n//g
  s/^[[:space:]]*s\{0,1\}plot[[:space:]]*\(\[[^]]*\][[:space:]]*\)*/,/
  s/[[:space:]]*\(['\''"][^'\''"]*['\''"]\)\{0,1\}[^,]*/\1/g
  s/,['\''"]-\{0,1\}['\''"]//g
  s/[,'\''"]\{1,\}/ /g
  s/.*:.*/$(error Error: Filenames with colons are not allowed: &)/
  s!.*!(##targets##): &!
  p
 }
 d
}
s/^[[:space:]]*load[[:space:]]*['\''"]\([^'\''"]*\.gpi\)['\''"].*$/-include \1.d/p
d
