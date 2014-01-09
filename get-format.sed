#(##defaults(target_files="TARGET_FILES")##)

# Format files are always specified on the first line
1!d

# They must be of the form %&name, with no spaces in "name"
# Everything after spaces is ignored.
/^%&\([[:alnum:]]\{1,\}\)\( .*\)*$/{
  s!!\1!
  h
  s/.*/# MISSING format "&.fmt" (comment forces rebuild of target file)/
  p
  g
  s!.*!(##target_files##): $(call path-norm,&.fmt)!
  p
}
d
