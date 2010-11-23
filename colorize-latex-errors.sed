#(##defaults(color_error="__E__", color_reset="__R__")##)

#(##include("paragraphs.sed")##)

# When we encounter ::2::, it means that we need two more paragraphs.  As we
# have one of them already (when ::2:: was added, the original paragraph was
# placed into the hold buffer, then the paragraph logic above added a second
# one), we switch the value down to ::1:: and delete the pattern buffer.
/^::2::/{
  s//::1::/
  G
  h
  b end
}
# When we encounter ::1::, it means that we just added our last paragraph.  We
# add ::0:: to indicate that this is a multi-paragraph pattern that is
# complete, and then let processing continue.
# Why don't we just delete the ::0::?  Because then the pattern used to
# indicate the need for multiple paragraphs in the first place will just
# trigger again and we'll keep adding paragraphs forever.  This allows us to
# test for <pattern> to start the accumulation process and for ::0::<pattern>
# to do the final processing on all paragraphs together.
/^::1::/{
  s//::0::/
  G
}

# File not found errors (e.g., for class and package files) require two more
# paragraphs to process properly And they don't start with a line number - that
# comes later by the "Emergency stop" output.
/^! LaTeX Error: File /{
  b needtwomore
}

# With -file-line-error specified in latex options, we get things like
# ./blah.tex:2: LaTeX Error
# (among other things).  We find all lines that look like they might contain a
# filename and line number and add an easy-to-find prefix to them.  That way we
# can easily find most errors, stuff that isn't called out here explicitly.
s/^[^[:cntrl:]:]*:[[:digit:]]\{1,\}:/!!! &/
# Note that we preserve all of the stuff before the !!! because it might
# contain useful errors that we have to find below.  Of particular interest is
# the File `something.cls' not found case.
# Note that any time we need to negate \n, we use [^[:cntrl:]] instead, since
# [^\n] doesn't work in POSIX sed.
s/^\(.*\n\)\([^[:cntrl:]:]*:[[:digit:]]\{1,\}: .*\)/\1!!! \2/

# Graphics files that go missing need only two paragraphs, and the
# filename:line: is at the beginning of the error message.
/^!!! .* LaTeX Error: File /{
  b needonemore
}

# Parse things that look like this (triple paragraphs)
# ! LaTeX Error: File `missing.cls' not found.
#
# Type X to quit or <RETURN> to proceed,
# or enter new name. (Default extension: cls)
# 
# Enter file name: 
# ./test-missing-cls.tex:2: Emergency stop.
# <read *> 
#          
# l.2 ^^M
#        
# *** (cannot \read from terminal in nonstop modes)
/^::0::! \(LaTeX Error: File.*not found\.\)/{
  # Remove paragraph prefix
  s//\1/
  s/^\(.*not found.\).*Enter file name:.*\n\(.*[[:digit:]]\{1,\}\): Emergency stop.*/\2: \1/
  b error
}

# Parse regular old file missing errors (not the special kind like classes and
# packages, but more mundane ones like missing graphics).
/^::0::!!! \(.*LaTeX Error: File.*not found\..*\)/{
  s//\1/
  # Handle file missing errors where we are looking for a particular extension
  /could not locate.*any of these extensions:/{
    s/\(not found\.\).*extensions:.\([^[:cntrl:]]*\).*/\1  Extensions tried: \2/
    s/,/, /g
    b error
  }
  # Handle everything else
  s/\(not found\.\).*/\1/
  b error
}

# This one is simple: find a single line that says we're missing
# begin{document} and colorize it.  Because this commonly happens when trying
# to build an include file (e.g., when typing "make" without a target in a
# directory that has a bunch of .tex files that are included in another), we
# handle it specially here.
/^\(.* LaTeX Error: Missing .begin.document.\.\).*/{
  s//\1 --- Are you trying to build an include file?/
  b error
}

# We deal with this one specially because it tends to be buried at the end of
# long paragraphs of other stuff, so it requires interesting processing.
# With the addition of the handy error prefix, though, we just need to delete
# the stuff before it and make the rest pretty.
# E.g., we want to parse this:
# LaTeX Font Info:    Checking defaults for OML/cmm/m/it on input line 5.
# LaTeX Font Info:    ... okay on input line 5.
# LaTeX Font Info:    Checking defaults for T1/cmr/m/n on input line 5.
# LaTeX Font Info:    ... okay on input line 5.
# LaTeX Font Info:    Checking defaults for OT1/cmr/m/n on input line 5.
# LaTeX Font Info:    ... okay on input line 5.
# LaTeX Font Info:    Checking defaults for OMS/cmsy/m/n on input line 5.
# LaTeX Font Info:    ... okay on input line 5.
# LaTeX Font Info:    Checking defaults for OMX/cmex/m/n on input line 5.
# LaTeX Font Info:    ... okay on input line 5.
# LaTeX Font Info:    Checking defaults for U/cmr/m/n on input line 5.
# LaTeX Font Info:    ... okay on input line 5.
# ./test.tex:6: Undefined control sequence.
# l.6 \halp
#          
# The control sequence at the end of the top line
# of your error message was never \def'ed. If you have
# misspelled it (e.g., `\hobx'), type `I' and the correct
# spelling (e.g., `I\hbox'). Otherwise just continue,
# and I'll forget about whatever was undefined.
/^\(!!! .*Undefined control sequence\)[^[:cntrl:]]*\(.*\)/{
  s//\1: \2/
  s/\nl\.[[:digit:]][^[:cntrl:]]*\(\\[^\\[:cntrl:]]*\).*/\1/
  b error
}

# Finally, we handle anything that looks remotely like an error that we
# haven't already caught.  We have to do this twice because POSIX sed doesn't handle things like ^|\n well.  In fact, it doesn't do branching expressions at all, and it can't match \n.
/^\(!!! [^[:cntrl:]]*\).*/{
  # Take only the first line and indicate that more info is in the log
  s//\1.  See log for more information./
  b error
}
/.*\n\(!!! [^[:cntrl:]]*\).*/{
  # Take only the first line and indicate that more info is in the log
  s//\1.  See log for more information./
  b error
}

# Anything not dealt with above gets dumped into the trash.
b end

# If we have an error (starts with !!! and we get this far), then strip the
# prefix and colorize it.
:error
s/^!!! \(.*\)/(##color_error##)\1(##color_reset##)/
p
b end

# Branch here if we need to add one more paragraph before processing.
:needonemore
s/^/::1::/
G
h
b end

# Branch here if we need two more paragraphs before processing.
:needtwomore
s/^/::2::/
G
h
b end

# Trash!
:end
d
