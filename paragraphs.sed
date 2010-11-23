# This uses a neat trick from the Sed & Awk Book from O'Reilly:
# Ensure that the last line looks like the end of a paragraph; if it isn't
# blank, hold it and blank it out.
${
  /^$/!{
    H
    s/.*//
  }
}
# Non-blank lines get held in the hold buffer
/^$/!{
  H
  d
}
# Blank lines signify the end of a paragraph.
# Swap blank into hold buffer (bringing paragraph into pattern buffer).
# Move newline prefix to end of paragraph.
/^$/{
  x
  s/^\(\n\)\(.*\)/\2\1/
}
