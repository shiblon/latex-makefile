#(##defaults(stem="TESTSTEM", build_target_extension="pdf")##)

#(##include("paragraphs.sed")##)

/^[^[:cntrl:]:]*:[[:digit:]]\{1,\}: LaTeX Error: File `/{
  # Get rid of trailing newlines for every paragraph, since LaTeX errors are
  # often split at arbitrary (not word) boundaries.
  s/\n//g
  b needonemore
}
# We have all the paragraphs we need - so extract the file name and extensions
/^::0::.*: LaTeX Error: File `/{
  # Kill all newlines, since the filename information can be split across lines
  s/\n\{1,\}/ /g
  # Collapse spaces
  s/[[:space:]]\{1,\}/ /g
  # Remove information before filename
  s/^.*File `//
  # Remove suffix and get extensions
  s/' not found\..*extensions: \([^[:space:]]*\).*/::::\1/
  # Now we have filename::::extensionlist in the pattern space
  # Place in the hold buffer, add missing stem comment
  h
  s/\(.*\)::::\(.*\)/# MISSING stem "\1" - allowed extensions are "\2" - leave comment here - it affects the build/
  p
  # Now get the hold buffer back, get rid of extension list, and call addtargets
  g
  s/::::.*//
  b addtargets
}
/.*File: \(.*\) Graphic file (type [^)]*).*/{
  s//\1/
  b addtargets
}

# If we didn't detect something known, trash it and go get another paragraph
d

:addtargets
# Attempt to deal with filenames that contain spaces
s/[[:space:]]/\\\\\\&/g
# Add -include .gpi.d line in case this is a gnuplot file
h
s/.*/-include &.gpi.d/
p
g

# Add graphics source files as dependencies of this file - it makes it rebuild
# when they change.
s!.*!(##stem##).d: $$(call graphics-source,&)!
p
s/.*//
x
# Add graphics dependencies to main document
s!.*!(##stem##).(##build_target_extension##) (##stem##)._graphics: $$(call graphics-target,&)!
p
d
