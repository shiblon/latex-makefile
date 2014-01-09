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

# Each P inside of :: represents a paragraph that we need to acquire.  When we
# see two or more P, we reduce the number by one, append the recently acquired
# paragraph to the pattern space, then hold the whole thing and delete the
# pattern space.  This puts the most recent paragraph into the hold buffer and
# starts the process over with paragraph accumulation.
# When discovering that we need, e.g., three more paragraphs, we can do the
# following:
#
# s/^/::PPP::/
# G
# h
# d
#
# This prefixes the current paragraph with the number of paragraphs needed,
# appends the contents of the hold space (a single newline after paragraph
# processing), puts everything back into the hold space, and deletes the
# pattern space (looping back to the beginning of the script, where paragraph
# processing begins).  See "needonemore" for a convenience label that you can
# branch to for adding one paragraph.

/^::P\(P\{1,\}\)::/{
  s//::\1::/
  G
  h
  d
}

# If we have exactly one P, then we swap it out for a zero and let processing
# continue (after :start).

/^::P::/{
  s//::0::/
  G
}

b start

# Convenience subroutines

:needonemore
s/^/::P::/
G
h
d

:needtwomore
s/^/::PP::/
G
h
d

:needthreemore
s/^/::PPP::/
G
h
d

# Start regular processing (this file is intended to be a preamble)
:start
