#(##defaults(name="TEST.EPS")##)

# Given an unqualified basename (name), try to find its full path in the
# .fls file recorded by latex -recorder mode.
#
# Finds only the first occurrence, by quitting if it is there, and deletes any
# non-matching lines. Thus, only the first match is ever printed and the script
# immediately exits.
#
# Note that the filename is not escaped in any kind of special way for
# searching, so it should be passed in pre-escaped to avoid having issues with
# the dot operator, among other things.
/^INPUT \(.*\/\)(##name##)$/{
  s//\1/
  q
}
d
