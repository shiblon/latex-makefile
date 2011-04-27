#(##defaults(stem="TESTSTEM", build_target_extension="pdf")##)

# Existing graphics files look different than missing files.  We still want to
# extract them, though.  Also, the paragraph structure is much simpler, so we
# short-circuit paragraph logic and just get the target off the line.
/^File: \(.*\) Graphic file (type [^)]*)/{
  s//\1/
  # If the file has a ps extension, kill that first.
  s/\.e\{0,1\}ps$//
  b addtargets
}

#(##include("paragraphs.sed")##)

/^[^[:cntrl:]:]*:[[:digit:]]\{1,\}: LaTeX Error: File `/{
  # Get rid of trailing newlines for every paragraph, since LaTeX errors are
  # often split at arbitrary (not word) boundaries.
  s/\n//g
  b needonemore
}
# We have all the paragraphs we need - so extract the file name and extensions
/^::0::.*: LaTeX Error: File `/{
  # Request one more paragraph if we ended in a newline.  This is a very
  # strange corner case that hits us when the filename error line ends in a
  # newline, and latex breaks the error line right before that newline
  # (creating a double empty line, which looks like an extra empty paragraph).
  # Yes, LaTeX log output is that weird.
  /\n\n$/{
    s/^::0:://
    b needonemore
  }
  # Kill all newlines, since the filename information can be split across lines
  s/\n\{1,\}/ /g
  # Collapse spaces
  s/[[:space:]]\{1,\}/ /g
  # Remove information before filename
  s/^.*File `//
  # If we have a pdflatex-style error (specifying which extensions are
  # allowed), handle that.
  /extensions: /{
    # Remove suffix and get extensions
    s/' not found\..*extensions: \([^[:space:]]*\).*/::::\1/
    b fileparsed
  }
  # graphic file names with extensions specified in the .tex file (bad news,
  # but it happens, especially with old latex-dvi-ps pipelines) don't give the
  # same error, so we generate an empty extension list.
  s/' not found\..*/::::/
  :fileparsed

  # If there are no extensions, that typically means that an extension was
  # specified.  We only want stems (extensions determined dynamically), so
  # remove it (but only do so for eps includes - pdf stuff is handled differently).
  s/\.e\{0,1\}ps::::$/::::/
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
