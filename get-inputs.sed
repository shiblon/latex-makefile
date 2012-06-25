#(##defaults(target_files="TARGET_FILES")##)

# only look at INPUT lines from the .fls file
/^INPUT/!d
# Remove references to the current directory, make all entries relative
s!^INPUT \(\./\)\{0,1\}!!
# Escape filepath spaces
s/[[:space:]]/\\ /g
# Depend on .tex, not on .aux
s/\(.*\)\.aux$/\1.tex/
# NOTE: BSD sed does not understand \|, so we have to do something more
# clunky to extract suitable extensions.
/\.tex$/b addtargets
/\.cls$/b addtargets
/\.sty$/b addtargets
/\.pstex_t$/b addtargets
/\.dot_t$/b addtargets
d
# Here we add the input targets.  This involves calling path-norm, which on
# cygwin systems will change the path to not contain spaces and to be
# unix-style instead of C:\Windows style.
:addtargets
s!.*!(##target_files##): $(call path-norm,&)!
