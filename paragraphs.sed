# This uses a neat trick from the Sed & Awk Book from O'Reilly:
# 1) Ensure that the last line of the file gets appended to the hold buffer,
#   and blank it out to trigger end-of-paragraph logic below.
# 2) When encountering a non-blank line, add to the hold buffer and delete.
# 3) When encountering a blank line
#    a) swap the hold buffer and pattern buffer
#    b) move the newline from the front to the back
# 4) Now the pattern buffer contains a full paragraph
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
  s/^\(\n\)\(.*\)/\2\1/
}
