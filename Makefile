# Copyright 2004 Chris Monson (monpublic@gmail.com)
# Latest version available at http://www.bouncingchairs.net/oss
#
#    This file is part of ``Chris Monson's Free Software''.
#
#    ``Chris Monson's Free Software'' is free software; you can redistribute it
#    and/or modify it under the terms of the GNU General Public License as
#    published by the Free Software Foundation, Version 2.
#
#    ``Chris Monson's Free Software'' is distributed in the hope that it will
#    be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
#    Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with ``Chris Monson's Free Software''; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#    It is also available on the web at http://www.gnu.org/copyleft/gpl.html
#
#    Note that using this makefile to build your documents does NOT place them
#    under the GPL unless you, the author, specifically do so.  In other words,
#    I, Chris Monson, the copyright holder and author of this makefile,
#    consider it impossible to ``link'' to this makefile in any way covered by
#    the GPL.
#
# TO OBTAIN INSTRUCTIONS FOR USING THIS FILE, RUN:
#    make help
#
fileinfo	:= LaTeX Makefile
author		:= Chris Monson
version		:= 2.1.23
svninfo		:= $$Id$$
#
# If you specify sources here, all other files with the same suffix
# will be treated as if they were _include_ files.
#onlysources.tex	:= main.tex
#onlysources.tex.sh	:=
#onlysources.rst	:=
#onlysources.fig	:=
#onlysources.gpi	:=
#onlysources.dot	:=
#onlysources.eps.gz	:=
#onlysources.eps	:=
#
# If you list files here, they will be treated as _include_ files
#includes.tex		:= file1.tex file2.tex
#includes.tex.sh	:=
#includes.rst		:=
#includes.fig		:=
#includes.gpi		:=
#includes.dot		:=
#includes.eps.gz	:=
#includes.eps		:=
#
# Alternatively (recommended), you can add those lines to a Makefile.ini file
# and it will get picked up automatically without your having to edit this
# Makefile.
-include Makefile.ini

# TODO:
# 	* Sometimes we get
# 		"mv: cannot stat '*.dvi.1st.make': No such file or directory"
# 		 on the second build (if nothing triggered a .d rebuild, but
# 		 the .dvi rule fired anyway).  To reproduce in the
# 		 dissertation directory:
#
#		 make clean
# 		 make byumsphd-example
# 		 make byumsphd-example
#
# KNOWN ISSUES:
#	* The following occurs:
#		file with: \usepackage{named}\bibliographystyle{named}
#		Compile
#		change to: \usepackage{apalike}\bibliographystyle{apalike}
#		Compile again -- BARF!
#
#		The workaround: make clean-nographics; make
#
#		Note that we may not be able to fix this.  LaTeX itself barfs
#		on this, not the makefile.  The very first invocation of LaTeX
#		(when something like this has happened) reads the existing .aux
#		file and discovers invalid commands like \citeauthoryear that
#		are only valid in the package that was just removed.  It then
#		tries to parse them and explodes.  It's not at all clear to me
#		how to fix this.  I tried removing the .aux files on the first
#		run of LaTeX, but that necessarily requires more subsequent
#		rebuilds on common edits.  There does not appear to be a
#		graceful solution to this issue.
#
# CHANGES:
# Chris Monson (2008-10-23):
# 	* Bumped version to 2.1.23
# 	* issue 23: fixed _check_programs to not use bash string subs
# Chris Monson (2008-09-02):
# 	* Bumped version to 2.1.22
# 	* Appled patch from Holger <yllohy@googlemail.com> to add include
# 		sources and some documentation updates.
# 	* Updated backup_patterns to be a bit more aggressive (also thanks to
# 		Holger)
# Chris Monson (2008-08-30):
# 	* Bumped version to 2.1.21
# 	* Added ability to specify onlysources.* variables to indicate the only
# 		files that should *not* be considered includes.  Thanks to Holger
# 		<yllohy@googlemail.com> for this patch.
# 	* Added an automatic include of Makefile.ini if it exists.  Allows
# 		settings to be made outside of this makefile.
# Chris Monson (2008-05-21):
# 	* Bumped version to 2.1.20
# 	* Added manual pstex compilation support (run make all-pstex first)
# 	* Removed all automatic pstex support.  It was totally breaking
# 		everything and is very hard to incorporate into the makefile
# 		concept because it requires LaTeX to *fail* before it can
# 		determine that it needs the files.
# Chris Monson (2008-04-17):
# 	* Bumped version to 2.1.19
# 	* Changed the pstex build hack to be on by default
# Chris Monson (2008-04-09):
# 	* Bumped version to 2.1.18
# 	* issue 16: fixed pstex build problems, seems nondeterministic.  Added
# 		gratuitious hack for testing: set PSTEX_BUILD_ALL_HACK=1.
# Chris Monson (2008-04-09):
# 	* Bumped version to 2.1.17
# 	* issue 20: fixed accumulation of <pid>*.make files - wildcard was
#		refusing to work on files that are very recently created.
# Chris Monson (2008-04-02):
# 	* Bumped version to 2.1.16
# 	* issue 19: Removed the use of "type" to fix broken "echo" settings
# Chris Monson (2008-03-27):
# 	* Bumped version to 2.1.15
# 	* issue 18: Favors binary echo over builtin, as binary understands -n
# 	* issue 16: Fixed handling of missing pstex_t files in the log
# 	* issue 9: Added .SECONDARY target for .pstex files
# Chris Monson (2008-03-21):
# 	* Bumped version to 2.1.14
# 	* Fixed broken aux file flattening, which caused included bibs to be
# 		missed.
# Chris Monson (2008-03-20):
# 	* Bumped version to 2.1.13
# 	* Changed error output colorization to show errors for missing files
# 		that are not graphics files.
# Chris Monson (2008-03-20):
# 	* Bumped version to 2.1.12
# 	* Fixed a regression introduced in r28 that makes bibtex fail when
# 		there is no index file present
# Chris Monson (2008-03-03):
# 	* Bumped version to 2.1.11
# 	* Fixed issue 11 (handle index files, reported by abachn)
# 	* Cleaned up some comments and help text
# Chris Monson (2008-01-24):
# 	* Bumped version to 2.1.10
#	* Fixed to work when 'sh' is a POSIX shell like 'dash'
# Chris Monson (2007-12-12):
# 	* Bumped version to 2.1.9
# 	* Fixed documentation and dependency graph for pstex files
# Chris Monson (2007-12-12):
# 	* Bumped version to 2.1.8
# 	* Added basic pstex_t support for fig files (Issue 9 by favonia)
# 		I still suggest that psfrag be used instead.
# Chris Monson (2007-10-16):
# 	* Bumped version to 2.1.7
# 	* Removed todo item: allow other comment directives for rst conversion
# 	* Added ability to use global rst style file _rststyle_._include_.tex
# 	* Added help text to that effect
# Chris Monson (2007-05-20):
# 	* Bumped version to 2.1.6
# 	* Changed default paper size for rst files
# 	* Added todo item: fix paper size for rst files
# 	* Added todo item: allow other comment directives for rst conversion
# Chris Monson (2007-04-02):
# 	* Bumped version to 2.1.5
# 	* Addressed Issue 7, incorrect .gpi.d generation in subdirectories
# Chris Monson (2007-03-28):
# 	* Bumped version to 2.1.4
# 	* Fixed syntax error in dot output
# Chris Monson (2007-03-01):
# 	* Bumped version to 2.1.3
# 	* Added reST to the included documentation
# 	* Fixed graphics and script generation to be settable in the
# 		environment.
# Chris Monson (2007-02-23):
# 	* Bumped version to 2.1.2
# 	* Added the ability to generate .tex files from .rst files
# Chris Monson (2006-10-17):
# 	* Bumped version to 2.1.1
# 	* Fixed includes from subdirectories (sed-to-sed slash escape problem)
# Chris Monson (2006-10-05):
# 	* Bumped version to 2.1.0 (pretty serious new feature added)
# 	* New feature: bib files can now be anywhere on the BIBINPUTS path
# 	* New programs: kpsewhich (with tetex) and xargs (BSD)
# Chris Monson (2006-09-28):
# 	* Bumped version to 2.0.9
# 	* Added ability to parse more than one bibliography
# Chris Monson (2006-06-01):
# 	* Bumped version to 2.0.8
# 	* Added .vrb to the list of cleaned files
# Chris Monson (2006-04-26):
# 	* Bumped version to 2.0.7
# 	* Fixed so that clean-nographics does not remove .gpi.d files
# 	* Removed jpg -> eps hack (not working properly -- just pre-convert)
# 	* Fixed so that postscript grayscale can be done with BSD sed
# Chris Monson (2006-04-25):
# 	* Bumped version to 2.0.6
# 	* Fixed so that changed toc, lot, lof, or out causes a rebuild
# Chris Monson (2006-04-17):
# 	* Bumped version to 2.0.5
# 	* Added jpg -> eps conversion target
# Chris Monson (2006-04-12):
# 	* Bumped version to 2.0.4
# 	* Fixed BSD sed invocation to not use \| as a branch delimiter
# 	* Added a comment section on what is and is not allowed in BSD sed
# 	* Made paper size handling more robust while I was at it
# 	* Fixed postscript RGB grayscale to use a weighted average
# 	* Fixed postscript HSB grayscale to convert to RGB first
# 	* Fixed a problem with rebuilding .bbl files
# Chris Monson (2006-04-11):
# 	* Bumped version to 2.0.3
# 	* Fixed some BSD sed problems: can't use \n in substitutions
# Chris Monson (2006-04-10):
# 	* Bumped version to 2.0.2
# 	* Once again removed ability to create .tex files from scripts
# 	* \includeonly works again
# Chris Monson (2006-04-09):
# 	* Bumped version to 2.0.1
# 	* Fixed grayscale postscript handling to be more robust
# 	* Added ability to generate ._gray_. files from eps and eps.gz
# 	* Added ability to clean ._gray_.eps files created from .eps files
# Chris Monson (2006-04-07):
# 	* Bumped version to 2.0.0
# 	* Removed clunky ability to create included .tex files from scripts
# 	* Added note in the help about included tex scripting not working
# 	* Fixed the .eps generation to delete %.gpihead.make when finished
# 	* Abandoned designs to use shell variables to create sed scripts
# 	* Abandoned __default__.tex.sh idea: it causes recursion with %: .
# 	* Removed web page to-do.  All items are now complete.
# 	* Added better grayscale conversion for dot figures (direct ps fixup).
# 	* Include files can now be scripted (at the expense of \includeonly).
# 	* Updated dependency graph to contain better node names.
# Chris Monson (2006-04-06):
# 	* Bumped version to 2.0b3
# 	* Top level includes now fail if there is no rule to build them
# 	* A helpful message is printed when they do fail
# 	* Grayscale has been changed to be ._gray_, other phonies use _ now, too
# 	* Grayscale handling has been completed
# 	* Changed _include_stems target to _includes target.
# 	* Fixed _includes target to be useful by itself.
# 	* Removed the ability to specify clean and build targets at once
# 	* Verified that epsfig works fine with current code
# 	* Fixed included scripts so that they are added to the dep files
# 	* Fixed so that graphics includes don't happen if they aren't for gpi
# 	* Fixed dot output to allow grayscale.
# Chris Monson (2006-04-05):
#	* Bumped version to 2.0b2
#	* Removed automatic -gray output.  It needs fixing in a bad way.
#	* Revamped dependency creation completely.
#	* Fixed conditional inclusion to actually work (test.nobuild.d, test.d).
#	* Fixed clean target to remove log targets
#	* Added the 'monochrome' word for gray gpi output
#	* Added a _check_gpi_files target that checks for common problems
#	* Changed the _version target into the version target (no _)
#	* Added better handling of grayscale files.  Use the .gray.pdf target.
#	* Fixed testing for rebuilds
# Chris Monson (2006-04-04):
#	* Bumped version to 2.0b1
#	* Changed colorization of output
#	* Made .auxbbl and .auxtex .make files secondary targets
#	* Shortened and simplified the final latex invocation loop
#	* Added version-specific output ($$i vs. $$$$i) in latex loop
#	* Added a build message for the first .dvi run (Building .dvi (0))
#	* Removed some build messages that most people don't care about.
#	* Simplified procedure for user-set colors -- simple text specification
#	* Fixed diff output to...not output.
#	* Fixed rerun bug -- detect not only when preceded with LaTeX Warning
#	* Sped up gpi plotting
#	* Added error handling and colorized output for gpi failure
#	* Documented color changing stuff.
#	* Now sort the flattened aux file to avoid false recompilation needs
#	* Added clean-nographics target
#	* Don't remove self.dvi file if self.aux is missing in the log
#	* Clarified some code.  Did some very minor adjusting.
# Chris Monson (2006-04-03):
#	* Bumped version to 2.0a7
#	* Added .dvi and .ps files as secondary files.
#	* Fixed handling of multiple run detection when includeonly is in use.
#	* Added code to flatten .aux files.
#	* Added more files as .SECONDARY prerequisites to avoid recompilation.
#	* Fixed the inputs generation to be much simpler and to use pipes.
#	* Added the dependency graph directly into the makefile.
#	* Changed flatten-aux to remove \@writefile \relax \newlabel, etc.
#	* Undid pipe changes with sed usage (BSD sed doesn't know -f-).
#	* Added a _check_programs target that tells you what your system has.
#	* Fixed an error in colorization that made unnecessary errors appear
#	* Added view targets.
#	* Updated help text.
#	* Augmented cookies so that .aux can trigger .bbl and .dvi rebuilds
#	* Added more informative error handling for dvips and ps2pdf
# Chris Monson (2006-04-02):
#	* Bumped version to 2.0a6
#	* Added indirection to .bbl dependencies to avoid rebuilding .bbl files
#	* Streamlined the diff invocation to eliminate an existence test
#	* Removed special shell quote escape variables
#	* Moved includes to a more prominent location
#	* Fixed .inputs.make to not contain .aux files
#	* Fixed embedding to use a file instead of always grepping.
#	* Added *.make.temp to the list of cleanable files
#	* Fixed Ruby.  It should now be supported properly.
#	* Now differentiate between all, default, and buildable files.
#	* Fixed to bail out on serious errors.
#	* Revised the handling of includable files.  Still working on it.
# Chris Monson (2006-03-31):
#	* Bumped version to 2.0a5
#	* Fixed a bug with LaTeX error detection (there can be spaces)
#	* Added .bbl support, simplifying everything and making it more correct
#	* Refactored some tests that muddy the code
#	* Did a little cleanup of some shell loops that can safely be make loops
#	* Added support for graphviz .dot files
#	* Made _all_programs output easier to read
#	* Added the ruby support that has long been advertised
#	* Font embedding was screwed up for PostScript -- now implicit
#	* Changed the generation of -gray.gpi files to a single command
#	* Changed any make-generated file that is not included from .d to .make
# Chris Monson (2006-03-30):
#	* Bumped version to 2.0a4
#	* Fixed a bug with very long graphics file names
#	* Added a todo entry for epsfig support
#	* Fixed a bug paper size bug: sometimes more than one entry appears
#	* Fixed DVI build echoing to display the number instead of process ID
#	* DVI files are now removed on first invocation if ANY file is missing
#	* Added a simple grayscale approach: if a file ends with -gray.gpi, it
#		is created from the corresponding .gpi file with a special
#		comment ##GRAY in its header, which causes coloring to be
#		turned off.
#	* Fixed a bug in the handling of .tex.sh files.  For some reason I had
#		neglected to define file stems for scripted output.
#	* Removed a trailing ; from the %.graphics dependencies
#	* Added dvips embedding (I think it works, anyway)
# Chris Monson (2006-03-29):
#	* Bumped version to 2.0a3
#	* Fixed error in make 3.79 with MAKEFILE_LIST usage
#	* Added the presumed filename to the _version output
#	* Added a vim macro for converting sed scripts to make commands
#	* Added gpi dependency support (plotting external files and loading gpi)
#	* Allow .gpi files to be ignored if called .include.gpi or .nobuild.gpi
#	* Fixed sed invocations where \+ was used.  BSD sed uses \{1,\}.
# Chris Monson (2006-03-28):
#	* Bumped version to 2.0a2
#	* Added SHELL_DEBUG and VERBOSE options
#	* Changed the default shell back to /bin/sh (unset, in other words)
#	* Moved .PHONY declarations closer to their targets
#	* Moved help text into its own define block to obtain better formatting
#	* Removed need for double-entry when adding a new program invocation
#	* Moved .SECONDARY declaration closer to its relevant occurrence
#	* Commented things more heavily
#	* Added help text about setting terminal and output in gnuplot
#	* Created more fine-grained clean targets
#	* Added a %.graphics target that generates all of %'s graphics
#	* Killed backward-compatible graphics generation (e.g., eps.gpi=gpi.eps)
#	* For now, we're just GPL 2, not 3.  Maybe it will change later
#	* Made the version and svninfo into variables
# Chris Monson (2006-03-27):
#	* Bumped version to 2.0a1
#	* Huge, sweeping changes -- automatic dependencies

# IMPORTANT!
#
# When adding to the following list, do not introduce any blank lines.  The
# list is extracted for documentation using sed and is terminated by a blank
# line.
#
# EXTERNAL PROGRAMS:
# = ESSENTIAL PROGRAMS =
# == Basic Shell Utilities ==
CAT		:= cat
CP		:= cp -f
DIFF		:= diff
ECHO		:= echo
EGREP		:= egrep
ENV		:= env
MV		:= mv -f
SED		:= sed
SORT		:= sort
TOUCH		:= touch
UNIQ		:= uniq
WHICH		:= which
XARGS		:= xargs
# == LaTeX (tetex-provided) ==
BIBTEX		:= bibtex
DVIPS		:= dvips
LATEX		:= latex
MAKEINDEX	:= makeindex
KPSEWHICH	:= kpsewhich
PS2PDF_NORMAL	:= ps2pdf
PS2PDF_EMBED	:= ps2pdf13
# = OPTIONAL PROGRAMS =
# == Makefile Color Output ==
TPUT		:= tput
# == TeX Generation ==
RST2LATEX	?= rst2latex.py
# == EPS Generation ==
DOT		?= dot		# GraphViz
FIG2DEV		?= fig2dev	# XFig
GNUPLOT		?= gnuplot	# GNUplot
GUNZIP		?= gunzip	# GZipped EPS
# == Beamer Enlarged Output ==
PSNUP		?= psnup
# == Viewing Stuff ==
VIEW_POSTSCRIPT	?= gv
VIEW_PDF	?= xpdf
VIEW_GRAPHICS	?= display

# This ensures that even when echo is a shell builtin, we still use the binary
# (the builtin doesn't always understand -n)
FIXED_ECHO	:= $(if $(findstring -n,$(shell $(ECHO) -n)),$(shell which echo),$(ECHO))
ECHO		:= $(if $(FIXED_ECHO),$(FIXED_ECHO),$(ECHO))

# SH NOTES
#
# On some systems, /bin/sh, which is the default shell, is not linked to
# /bin/bash.  While bash is supposed to be sh-compatible when invoked as sh, it
# just isn't.  This section details some of the things you have to stay away
# from to remain sh-compatible.
#
#	* File pattern expansion does not work for {}
#	* [ "$x" = "$y" ] has to be [ x"$x" x"$y" ]
#	* &> for stderr redirection doesn't work, use 2>&1 instead
#
# BSD SED NOTES
#
# BSD SED is not very nice compared to GNU sed, but it is the most
# commonly-invoked sed on Macs (being based on BSD), so we have to cater to
# it or require people to install GNU sed.  It seems like the GNU
# requirement isn't too bad since this makefile is really a GNU makefile,
# but apparently GNU sed is much less common than GNU make in general, so
# I'm supporting it here.
#
# Sad experience has taught me the following about BSD sed:
#
# 	* \+ is not understood to mean \{1,\}
# 	* \| is meaningless (does not branch)
# 	* \n cannot be used as a substitution character
# 	* ? does not mean \{0,1\}, but is literal
# 	* a\ works, but only reliably for a single line if subsequent lines
# 		have forward slashes in them (as is the case in postscript)
#
# For more info (on the Mac) you can consult
#
# man -M /usr/share/man re_format
#
# And look for the word "Obsolete" near the bottom.

#
# EXTERNAL PROGRAM DOCUMENTATION SCRIPT
#

# $(call output-all-programs,[<output file>])
define output-all-programs
	[ -f '$(this_file)' ] && \
	$(SED) \
		-e '/^[[:space:]]*#[[:space:]]*EXTERNAL PROGRAMS:/,/^$$/!d' \
		-e '/EXTERNAL PROGRAMS/d' \
		-e '/^$$/d' \
		-e '/^[[:space:]]*#/i\ '\
		-e 's/^[[:space:]]*#[[:space:]][^=]*//' \
		$(this_file) $(if $1,> '$1',) || \
	$(ECHO) "Cannot determine the name of this makefile."
endef

# If they misspell gray, it should still work.
GRAY	?= $(call get-default,$(GREY),)

#
# Utility Functions and Definitions
#

# While not exactly a make function, this vim macro is useful.  It takes a
# verbatim sed script and converts each line to something suitable in a command
# context.  Just paste the script's contents into the editor, yank this into a
# register (starting at '0') and run the macro once for each line of the
# original script:
#
# 0i	-e :s/\$/$$/eg:s/'/'"'"'/eg^Ela'A' \:nohj

# don't call this directly - it is here to avoid calling wildcard more than
# once in remove-files.
remove-files-helper	= $(if $1,$(RM) $1,:)

# $(call remove-files,file1 file2)
remove-files		= $(call remove-files-helper,$(wildcard $1))

# This removes files without checking whether they are there or not.  This
# sometimes has to be used when the file is created by a series of shell
# commands, but there ends up being a race condition: make doesn't know about
# the file generation as quickly as the system does, so $(wildcard ...) doesn't
# work right.  Blech.
# $(call remove-temporary-files,filenames)
remove-temporary-files	= $(if $1,$(RM) $1,:)

# Create an identifier from a file name
# $(call cleanse-filename,filename)
cleanse-filename	= $(subst .,_,$(subst /,__,$1))

# Escape dots
# $(call escape-dots,str)
escape-dots		= $(subst .,\\.,$1)

# Test that a file exists
# $(call test-exists,file)
test-exists		= [ -e '$1' ]

# Copy file1 to file2 only if file2 doesn't exist or they are different
# $(call copy-if-different,sfile,dfile)
copy-if-different	= $(call test-different,$1,$2) && $(CP) '$1' '$2'
copy-if-exists		= $(call test-exists,$1) && $(CP) '$1' '$2'
move-if-different	= $(call test-different,$1,$2) && $(MV) '$1' '$2'
replace-if-different-and-remove	= \
	$(call test-different,$1,$2) \
	&& $(MV) '$1' '$2' \
	|| $(call remove-files,'$1')

# Note that $(DIFF) returns success when the files are the SAME....
# $(call test-different,sfile,dfile)
test-different		= ! $(DIFF) -q '$1' '$2' >/dev/null 2>&1
test-exists-and-different	= \
	$(call test-exists,$2) && $(call test-different,$1,$2)

# Return value 1, or value 2 if value 1 is empty
# $(call get-default,<possibly empty arg>,<default value if empty>)
get-default	= $(if $1,$1,$2)

# Gives a reassuring message about the failure to find include files
# $(call include-message,<list of include files>)
define include-message
$(strip \
$(if $(filter-out $(wildcard $1),$1),\
	$(shell $(ECHO) \
	"$(C_INFO)NOTE: You may ignore warnings about the"\
	"following files:" >&2;\
	$(ECHO) >&2; \
	$(foreach s,$(filter-out $(wildcard $1),$1),$(ECHO) '     $s' >&2;)\
	$(ECHO) "$(C_RESET)" >&2)
))
endef
# Characters that are hard to specify in certain places
space		:= $(empty) $(empty)
colon		:= \:
comma		:= ,

# Useful shell definitions
sh_true		:= :
sh_false	:= ! :

# Clear out the standard interfering make suffixes
.SUFFIXES:

# Turn off forceful rm (RM is usually mapped to rm -f)
ifdef SAFE_RM
RM	:= rm
endif

# Turn command echoing back on with VERBOSE=1
ifndef VERBOSE
QUIET	:= @
endif

# Turn on shell debugging with SHELL_DEBUG=1
# (EVERYTHING is echoed, even $(shell ...) invocations)
ifdef SHELL_DEBUG
SHELL	+= -x
endif

# Get the name of this makefile (always right in 3.80, often right in 3.79)
# This is only really used for documentation, so it isn't too serious.
ifdef MAKEFILE_LIST
this_file	:= $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
else
this_file	:= $(wildcard GNUmakefile makefile Makefile)
endif

# Terminal color definitions

ifdef NO_COLOR
tput		=
else
tput		= $(shell $(TPUT) $1)
endif

black	:= $(call tput,setaf 0)
red	:= $(call tput,setaf 1)
green	:= $(call tput,setaf 2)
yellow	:= $(call tput,setaf 3)
blue	:= $(call tput,setaf 4)
magenta	:= $(call tput,setaf 5)
cyan	:= $(call tput,setaf 6)
white	:= $(call tput,setaf 7)
bold	:= $(call tput,bold)
uline	:= $(call tput,smul)
reset	:= $(call tput,sgr0)

#
# User-settable definitions
#
LATEX_COLOR_WARNING	?= magenta
LATEX_COLOR_ERROR	?= red
LATEX_COLOR_INFO	?= green
LATEX_COLOR_UNDERFULL	?= magenta
LATEX_COLOR_OVERFULL	?= red bold
LATEX_COLOR_PAGES	?= bold
LATEX_COLOR_BUILD	?= blue
LATEX_COLOR_GRAPHIC	?= yellow
LATEX_COLOR_DEP		?= green
LATEX_COLOR_SUCCESS	?= green bold
LATEX_COLOR_FAILURE	?= red bold

# Gets the real color from a simple textual definition like those above
# $(call get-color,ALL_CAPS_COLOR_NAME)
# e.g., $(call get-color,WARNING)
get-color	= $(subst $(space),,$(foreach c,$(LATEX_COLOR_$1),$($c)))

#
# STANDARD COLORS
#
C_WARNING	:= $(call get-color,WARNING)
C_ERROR		:= $(call get-color,ERROR)
C_INFO		:= $(call get-color,INFO)
C_UNDERFULL	:= $(call get-color,UNDERFULL)
C_OVERFULL	:= $(call get-color,OVERFULL)
C_PAGES		:= $(call get-color,PAGES)
C_BUILD		:= $(call get-color,BUILD)
C_GRAPHIC	:= $(call get-color,GRAPHIC)
C_DEP		:= $(call get-color,DEP)
C_SUCCESS	:= $(call get-color,SUCCESS)
C_FAILURE	:= $(call get-color,FAILURE)
C_RESET		:= $(reset)

#
# PRE-BUILD TESTS
#

# Check that clean targets are not combined with other targets (weird things
# happen, and it's not easy to fix them)
hascleangoals	:= $(if $(sort $(filter clean clean-%,$(MAKECMDGOALS))),1)
hasbuildgoals	:= $(if $(sort $(filter-out clean clean-%,$(MAKECMDGOALS))),1)
ifneq "$(hasbuildgoals)" ""
ifneq "$(hascleangoals)" ""
$(error $(C_ERROR)Clean and build targets specified together$(C_RESET)))
endif
endif

#
# VARIABLE DECLARATIONS
#

# Names of sed scripts that morph gnuplot files -- only the first found is used
GNUPLOT_SED	:= global-gpi.sed gnuplot.sed
GNUPLOT_GLOBAL	:= global._include_.gpi gnuplot.global

# Files of interest
all_files.tex		:= $(wildcard *.tex)
all_files.tex.sh	:= $(wildcard *.tex.sh)
all_files.rst		:= $(wildcard *.rst)
all_files.fig		:= $(wildcard *.fig)
all_files.gpi		:= $(wildcard *.gpi)
all_files.dot		:= $(wildcard *.dot)
all_files.eps.gz	:= $(wildcard *.eps.gz)
all_files.eps		:= $(wildcard *.eps)

# Utility function for getting all .$1 files that are to be ignored
#  * files listed in $(includes.$1)
#  * files not listed in $(onlysources.$1) if it is defined
ignore_files = \
  $(includes.$1) \
  $(if $(onlysources.$1),$(filter-out $(onlysources.$1), $(all_files.$1)))

# Patterns to never be allowed as source targets
ignore_patterns	:= %._include_

# Patterns allowed as source targets but not included in 'all' builds
nodefault_patterns := %._nobuild_ $(ignore_patterns)

# Utility function for getting targets suitable building
# $(call filter-buildable,suffix)
filter-buildable	= \
	$(filter-out $(call ignore_files,$1) \
		$(addsuffix .$1,$(ignore_patterns)),$(all_files.$1))

# Utility function for getting targets suitable for 'all' builds
# $(call filter-default,suffix)
filter-default		= \
	$(filter-out $(call ignore_files,$1) \
		$(addsuffix .$1,$(nodefault_patterns)),$(all_files.$1))

# Top level sources that can be built even when they are not by default
files.tex	:= $(filter-out %._gray_.tex,$(call filter-buildable,tex))
files.tex.sh	:= $(call filter-buildable,tex.sh)
files.rst	:= $(call filter-buildable,rst)
files.gpi	:= $(call filter-buildable,gpi)
files.dot	:= $(call filter-buildable,dot)
files.fig	:= $(call filter-buildable,fig)
files.eps.gz	:= $(call filter-buildable,eps.gz)

# Make all pstex targets secondary.  The pstex_t target requires the pstex
# target, and nothing else really depends on it, so it often gets deleted.
# This avoids that by allowing *all* fig files to be pstex targets, which is
# perfectly valid and causes no problems even if they're going to become eps
# files in the end.
.SECONDARY:	$(patsubst %.fig,%.pstex,$(files.fig))
.SECONDARY:	$(patsubst %.fig,%._gray_.pstex,$(files.fig))

# Top level sources that are built by default targets
default_files.tex	:= $(filter-out %._gray_.tex,$(call filter-default,tex))
default_files.tex.sh	:= $(call filter-default,tex.sh)
default_files.rst	:= $(call filter-default,rst)
default_files.gpi	:= $(call filter-default,gpi)
default_files.dot	:= $(call filter-default,dot)
default_files.fig	:= $(call filter-default,fig)
default_files.eps.gz	:= $(call filter-default,eps.gz)

# Utility function for creating larger lists of files
# $(call concat-files,suffixes,[prefix])
concat-files	= $(foreach s,$1,$($(if $2,$2_,)files.$s))

# Useful file groupings
all_files_source	:= $(call concat-files,tex,all)
all_files_scripts	:= $(call concat-files,tex.sh rst,all)
all_files_graphics	:= $(call concat-files,fig gpi eps.gz dot,all)

default_files_source	:= $(call concat-files,tex,default)
default_files_scripts	:= $(call concat-files,tex.sh rst,default)
default_files_graphics	:= $(call concat-files,fig gpi eps.gz dot,default)

files_source	:= $(call concat-files,tex)
files_scripts	:= $(call concat-files,tex.sh rst)
files_graphics	:= $(call concat-files,fig gpi eps.gz dot)

# Utility function for obtaining stems
# $(call get-stems,suffix,[prefix])
get-stems	= $(sort $($(if $2,$2_,)files.$1:%.$1=%))

# List of all stems (including ._include_ and ._nobuild_ file stems)
all_stems.tex		:= $(call get-stems,tex,all)
all_stems.tex.sh	:= $(call get-stems,tex.sh,all)
all_stems.rst		:= $(call get-stems,rst,all)
all_stems.fig		:= $(call get-stems,fig,all)
all_stems.gpi		:= $(call get-stems,gpi,all)
all_stems.dot		:= $(call get-stems,dot,all)
all_stems.eps.gz	:= $(call get-stems,eps.gz,all)
all_stems.eps		:= $(call get-stems,eps,all)

# List of all default stems (all default PDF targets):
default_stems.tex		:= $(call get-stems,tex,default)
default_stems.tex.sh		:= $(call get-stems,tex.sh,default)
default_stems.rst		:= $(call get-stems,rst,default)
default_stems.fig		:= $(call get-stems,fig,default)
default_stems.gpi		:= $(call get-stems,gpi,default)
default_stems.dot		:= $(call get-stems,dot,default)
default_stems.eps.gz		:= $(call get-stems,eps.gz,default)

# List of all stems (all possible bare PDF targets created here):
stems.tex		:= $(call get-stems,tex)
stems.tex.sh		:= $(call get-stems,tex.sh)
stems.rst		:= $(call get-stems,rst)
stems.fig		:= $(call get-stems,fig)
stems.gpi		:= $(call get-stems,gpi)
stems.dot		:= $(call get-stems,dot)
stems.eps.gz		:= $(call get-stems,eps.gz)

# Utility function for creating larger lists of stems
# $(call concat-stems,suffixes,[prefix])
concat-stems	= $(sort $(foreach s,$1,$($(if $2,$2_,)stems.$s)))

all_stems_source	:= $(call concat-stems,tex,all)
all_stems_script	:= $(call concat-stems,tex.sh rst,all)
all_stems_graphic	:= $(call concat-stems,fig gpi eps.gz dot,all)
all_stems_gray_graphic	:= $(addsuffix ._gray_,\
	$(all_stems_graphic) $(all_stems.eps) \
	)
all_stems_gg		:= $(sort \
	$(all_stems_graphic) $(all_stems_gray_graphic))
all_stems_ss		:= $(sort $(all_stems_source) $(all_stems_script))
all_stems_gray		:= $(addsuffix ._gray_,$(all_stems_ss))
all_stems_sg		:= $(sort $(all_stems_script) $(all_stems_gray))
all_stems_ssg		:= $(sort $(all_stems_ss) $(all_stems_gray))

default_stems_source	:= $(call concat-stems,tex,default)
default_stems_script	:= $(call concat-stems,tex.sh rst,default)
default_stems_graphic	:= $(call concat-stems,fig gpi eps.gz dot,default)
default_stems_gray_graphic	:= $(addsuffix ._gray_,$(default_stems_graphic))
default_stems_gg	:= $(sort \
	$(default_stems_graphic) $(default_stems_gray_graphic))
default_stems_ss	:= $(sort \
	$(default_stems_source) $(default_stems_script))
default_stems_gray	:= $(addsuffix ._gray_,$(default_stems_ss))
default_stems_sg	:= $(sort $(default_stems_script) $(default_stems_gray))
default_stems_ssg	:= $(sort $(default_stems_ss) $(default_stems_gray))

stems_source		:= $(call concat-stems,tex)
stems_script		:= $(call concat-stems,tex.sh rst)
stems_graphic		:= $(call concat-stems,fig gpi eps.gz dot)
stems_gray_graphic	:= $(addsuffix ._gray_,\
	$(stems_graphic) $(all_stems.eps))
stems_gg		:= $(sort $(stems_graphic) $(stems_gray_graphic))
stems_ss		:= $(sort $(stems_source) $(stems_script))
stems_gray		:= $(addsuffix ._gray_,$(stems_ss))
stems_sg		:= $(sort $(stems_script) $(stems_gray))
stems_ssg		:= $(sort $(stems_ss) $(stems_gray))

# Calculate names that can generate the need for an include file.  We can't
# really do this with patterns because it's too easy to screw up, so we create
# an exhaustive list.
allowed_source_suffixes	:= \
	pdf \
	ps \
	dvi \
	ind \
	bbl \
	aux \
	aux.make \
	d \
	tex \
	auxbbl.make \
	_graphics \
	_show
allowed_source_patterns		:= $(addprefix %.,$(allowed_source_suffixes))

allowed_graphic_suffixes	:= \
	eps \
	gpihead.make \
	gpi.d
allowed_graphic_patterns	:= $(addprefix %.,$(allowed_graphic_suffixes))

# All targets allowed to build documents
allowed_source_targets	:= \
	$(foreach suff,$(allowed_source_suffixes),\
	$(addsuffix .$(suff),$(stems_ssg)))

# All targets allowed to build graphics
allowed_graphic_targets	:= \
	$(foreach suff,$(allowed_graphic_suffixes),\
	$(addsuffix .$(suff),$(stems_gg)))

# All targets that build multiple documents (like 'all')
allowed_batch_source_targets	:= \
	all \
	all-pdf \
	all-ps \
	all-dvi \
	all-bbl \
	all-ind \
	show

# All targets that build multiple graphics (independent of document)
allowed_batch_graphic_targets	:= \
	all-graphics \
	all-pstex \
	all-gray-pstex \
	show-graphics

# Now we figure out which stuff is available as a make target for THIS RUN.
real_goals	:= $(call get-default,$(filter-out _includes,$(MAKECMDGOALS)),\
			all)

specified_source_targets	:= $(strip \
	$(filter $(allowed_source_targets) $(stems_ssg),$(real_goals)) \
	)

specified_batch_source_targets	:= $(strip \
	$(filter $(allowed_batch_source_targets),$(real_goals)) \
	)

specified_graphic_targets	:= $(strip \
	$(filter $(allowed_graphic_targets),$(real_goals)) \
	)

specified_batch_graphic_targets	:= $(strip \
	$(filter $(allowed_batch_graphic_targets),$(real_goals)) \
	)

specified_gpi_targets	:= $(patsubst %.gpi,%.eps,\
	$(filter $(patsubst %.eps,%.gpi,$(specified_graphic_targets)),\
		$(all_files.gpi)) \
	)

# Determine which .d files need including from the information gained above.
# This is done by first checking whether a batch target exists.  If it does,
# then all *default* stems are used to create possible includes (nobuild need
# not apply for batch status).  If no batch targets exist, then the individual
# targets are considered and appropriate includes are taken from them.
source_stems_to_include	:= \
	$(sort\
	$(if $(specified_batch_source_targets),\
		$(default_stems_ss),\
		$(foreach t,$(specified_source_targets),\
		$(foreach p,$(allowed_source_patterns),\
			$(patsubst $p,%,$(filter $p $(stems_ssg),$t)) \
		)) \
	))

# Determine which .gpi.d files are needed using the above information.  We
# first check whether a batch target is specified, then check individual
# graphics that may have been specified.
graphic_stems_to_include	:= \
	$(sort\
	$(if $(specified_batch_graphic_targets),\
		$(default_stems.gpi),\
		$(foreach t,$(specified_gpi_targets),\
		$(foreach p,$(allowed_graphic_patterns),\
			$(patsubst $p,%,$(filter $p,$t)) \
		)) \
	))

# All dependencies for the 'all' targets
all_pdf_targets		:= $(addsuffix .pdf,$(stems_ssg))
all_ps_targets		:= $(addsuffix .ps,$(stems_ssg))
all_dvi_targets		:= $(addsuffix .dvi,$(stems_ssg))
all_tex_targets		:= $(addsuffix .tex,$(stems_sg))
all_d_targets		:= $(addsuffix .d,$(stems_ssg))
all_graphics_targets	:= $(addsuffix .eps,$(stems_gg))
all_pstex_targets	:= $(addsuffix .pstex_t,$(stems.fig))
all_gray_pstex_targets	:= $(addsuffix ._gray_.pstex_t,$(stems.fig))

all_known_graphics	:= $(sort $(all_graphics_targets) $(wildcard *.eps))

default_pdf_targets	:= $(addsuffix .pdf,$(default_stems_ss))
default_ps_targets	:= $(addsuffix .ps,$(default_stems_ss))
default_dvi_targets	:= $(addsuffix .dvi,$(default_stems_ss))

# Extensions generated by LaTeX invocation that can be removed when complete
rm_ext		:= \
	log aux dvi ps pdf blg bbl out nav snm toc lof lot pfg fls vrb \
	idx ind ilg lox
backup_patterns	:= *~ *.bak *.backup

graph_stem	:= _graph

# All LaTeX-generated files that can be safely removed

rm_tex := \
	$(foreach e,$(rm_ext),$(addsuffix .$e,$(all_stems_source))) \
	$(foreach e,$(rm_ext) tex,$(addsuffix .$e,$(all_stems_sg))) \
	$(addsuffix .log,$(all_ps_targets) $(all_pdf_targets)) \
	$(addsuffix .*.log,$(stems_graphic))

# These are the files that will affect .gpi transformation for all .gpi files.
#
# Use only the first one found.  Backward compatible values are at the end.
# Note that we use foreach, even though wildcard also returns a list, to ensure
# that the order in the uppercase variables is preserved.  Directory listings
# provide no such guarantee, so we avoid relying on them.
gpi_sed		:= $(strip \
	$(firstword $(foreach f,$(GNUPLOT_SED),$(wildcard $f))))
gpi_global	:= $(strip \
	$(firstword $(foreach f,$(GNUPLOT_GLOBAL),$(wildcard $f))))

#
# Functions used in generating output
#

# Outputs all source dependencies to stdout.  The first argument is the file to
# be parsed, the second is a list of files that will show up as dependencies in
# the new .d file created here.
#
# NOTE: BSD sed does not understand \|, so we have to do something more
# clunky to extract suitable extensions.
#
# $(call get-inputs,<parsed file>,<target files>)
define get-inputs
$(SED) \
-e '/^INPUT/!d' \
-e 's!^INPUT \(\./\)\{0,1\}!$2: !' \
-e '/\.tex$$/p' \
-e '/\.cls$$/p' \
-e '/\.sty$$/p' \
-e 'd' \
$1 | $(SORT) | $(UNIQ)
endef

# Outputs all of the graphical dependencies to stdout.  The first argument is
# the stem of the source file being built, the second is a list of suffixes
# that will show up as dependencies in the generated .d file.
#
# $(call get-graphics,<parsed file>,<target files>)
define get-graphics
$(SED) \
-e '/^File:/!d' \
-e 'N' \
-e 's/\n//g' \
-e '/Graphic file/!d' \
-e 's/^File: //' \
-e 's/ Graphic.*$$//' \
-e '/^\(.*\)\(\.[^.]*\)$$/{' \
-e   's//$2: \1\2/' \
-e   'p' \
-e   's/[^:]*: \(.*\)\(\.[^.]*\)$$/-include \1.gpi.d/' \
-e   'p' \
-e   'd' \
-e '}' \
$1 | $(SORT) | $(UNIQ)
endef

# Checks for build failure due to pstex inclusion, and gives instructions.
#
# $(call die-on-pstexs,<parsed file>)
define die-on-pstexs
if $(EGREP) -q '^! LaTeX Error: File .*\.pstex.* not found' $1; then \
	$(ECHO) "$(C_ERROR)Missing pstex_t file(s)$(C_RESET)"; \
	$(ECHO) "$(C_ERROR)Please run$(C_RESET)"; \
	$(ECHO) "$(C_ERROR)  make all-pstex$(C_RESET)"; \
	$(ECHO) "$(C_ERROR)before proceeding.$(C_RESET)"; \
	exit 1; \
fi
endef

# Outputs all index files to stdout.  Arg 1 is the source stem, arg 2 is the
# list of targets for the discovered dependency.
#
# $(call get-inds,<parsed file>,<target files>)
define get-inds
$(SED) \
-e 's/^No file \(.*\)\.ind\.$$/$2: \1.ind/p' \
-e 'd' \
$1 | $(SORT) | $(UNIQ)
endef


# Outputs all bibliography files to stdout.  Arg 1 is the source stem, arg 2 is
# a list of targets for each dependency found.
#
# The script kills all lines that do not contain bibdata.  Remaining lines have
# the \bibdata macro and delimiters removed to create a dependency list.  A
# trailing comma is added, then all adjacent commas are collapsed into a single
# comma.  Then commas are replaced with the string .bib[space], and the
# trailing space is killed off.  This produces a list of space-delimited .bib
# filenames, which is what the make dep file expects to see.
#
# $(call get-bibs,<aux file>,<targets>)
define get-bibs
$(SED) \
-e '/^\\bibdata/!d' \
-e 's/\\bibdata{\([^}]*\)}/\1,/' \
-e 's/,\{2,\}/,/g' \
-e 's/,/.bib /g' \
-e 's/ \{1,\}$$//' \
$1 | $(XARGS) $(KPSEWHICH) - | \
$(SED) \
-e 's/^/$2: /' | \
\$(SORT) | $(UNIQ)
endef

# Makes a an aux file that only has stuff relevant to the dvi in it
# $(call make-auxdvi-file,<flattened-aux>,<new-aux>)
define make-auxdvi-file
$(SED) \
-e '/^\\newlabel/!d' \
$1 > $2
endef

# Makes an aux file that only has stuff relevant to the bbl in it
# $(call make-auxbbl-file,<flattened-aux>,<new-aux>)
define make-auxbbl-file
$(SED) \
-e '/^\\newlabel/d' \
$1 > $2
endef

# Makes a .gpi.d file from a .gpi file
# $(call make-gpi-d,<.gpi>,<.gpi.d>)
define make-gpi-d
$(ECHO) '# vim: ft=make' > $2; \
$(ECHO) 'ifndef INCLUDED_$(call cleanse-filename,$2)' >> $2; \
$(ECHO) 'INCLUDED_$(call cleanse-filename,$2) = 1' >> $2; \
$(call get-gpi-deps,$1,$(addprefix $(2:%.gpi.d=%).,eps gpi.d)) >> $2; \
$(ECHO) 'endif' >> $2;
endef

# Parse .gpi files for data and loaded dependencies, output to stdout
#
# The sed script here tries to be clever about obtaining valid
# filenames from the gpi file.  It assumes that the plot command starts its own
# line, which is not too difficult a constraint to satisfy.
#
# This command script also generates 'include' directives for every 'load'
# command in the .gpi file.  The load command must appear on a line by itself
# and the file it loads must have the suffix .gpi.  If you don't want it to be
# compiled when running make graphics, then give it a suffix of ._include_.gpi.
#
# $(call get-gpi-deps,<gpi file>,<targets>)
define get-gpi-deps
$(SED) \
-e '/^[[:space:]]*s\{0,1\}plot/,/[^\\]$$/{' \
-e ' H' \
-e ' /[^\\]$$/{' \
-e '  s/.*//' \
-e '  x' \
-e '  s/\\\{0,1\}\n//g' \
-e '  s/^[[:space:]]*s\{0,1\}plot[[:space:]]*\(\[[^]]*\][[:space:]]*\)*/,/' \
-e '  s/[[:space:]]*\(['\''"][^'\''"]*['\''"]\)\{0,1\}[^,]*/\1/g' \
-e '  s/,['\''"]-\{0,1\}['\''"]//g' \
-e '  s/[,'\''"]\{1,\}/ /g' \
-e '  s!.*!$2: &!' \
-e '  p' \
-e ' }' \
-e ' d' \
-e '}' \
-e 's/^[[:space:]]*load[[:space:]]*['\''"]\([^'\''"]*\.gpi\)['\''"].*$$/-include \1.d/p' \
-e 'd' \
$1
endef

# Colorizes real, honest-to-goodness LaTeX errors that can't be overcome with
# recompilation.
#
# Note that we only ignore file not found errors for things that we know how to
# build, like graphics files.
#
# $(call colorize-latex-errors,<log file>)
define colorize-latex-errors
$(SED) \
-e '/^! LaTeX Error: File .*eps'"'"' not found\.$$/d' \
-e '/^! LaTeX Error: Cannot determine size/d' \
-e '/^! /,/^$$/{' \
-e '  H' \
-e '  /^$$/{' \
-e '    x' \
-e '    s/^.*$$/$(C_ERROR)&$(C_RESET)/' \
-e '    p' \
-e '  }' \
-e '}' \
-e 'd' \
$1
endef

# Colorize Makeindex errors
define colorize-makeindex-errors
$(SED) \
-e '/^!! /{' \
-e '  N' \
-e '  s/^.*$$/$(C_ERROR)&$(C_RESET)/' \
-e '  p' \
-e '}' \
-e 'd' \
$1
endef

# Colorize GNUplot errors
#
# $(call colorize-gnuplot-errors,<log file>)
define colorize-gnuplot-errors
$(SED) \
-e '/^gnuplot>/,/^$$/{' \
-e '  s/^gnuplot.*/$(C_ERROR)&/' \
-e '  s/^$$/$(C_RESET)/' \
-e '  p' \
-e '}' \
-e 'd' \
$1
endef

# Colorize GraphViz errors
#
# $(call colorize-dot-errors,<log file>)
define colorize-dot-errors
$(SED) \
-e '/^Error:/,/context:/s/.*/$(C_ERROR)&$(C_RESET)/p' \
-e 's/^Warning:.*/$(C_WARNING)&$(C_RESET)/p' \
-e 'd' \
$1
endef

# Get all important .aux files from the top-level .aux file and merges them all
# into a single file, which it outputs to stdout.
#
# $(call flatten-aux,<toplevel aux>,<output file>)
define flatten-aux
$(SED) \
-e '/\\@input{\(.*\)}/{' \
-e     's//\1/' \
-e     's![.:]!\\&!g' \
-e     'h' \
-e     's!.*!\\:\\\\@input{&}:{!' \
-e     'p' \
-e     'x' \
-e     's/\\././g' \
-e     's/.*/r &/p' \
-e     's/.*/d/p' \
-e     's/.*/}/p' \
-e     'd' \
-e '}' \
-e 'd' \
'$1' > "$1.$$$$.sed.make"; \
$(SED) -f "$1.$$$$.sed.make" '$1' > "$1.$$$$.make"; \
$(SED) \
-e '/^\\relax/d' \
-e '/^\\bibcite/d' \
-e 's/^\(\\newlabel{[^}]\{1,\}}\).*/\1/' \
"$1.$$$$.make" | $(SORT) > '$2'; \
$(call remove-temporary-files,$1.$$$$.make $1.$$$$.sed.make)
endef

# Generate pdf from postscript
ps2pdf_normal	:= $(PS2PDF_NORMAL)
ps2pdf_embedded	:= \
	$(PS2PDF_EMBED) \
	-dPDFSETTINGS=/printer \
	-dEmbedAllFonts=true \
	-dSubsetFonts=true \
	-dMaxSubsetPct=100

# Colorize LaTeX output.
color_tex	:= \
	$(SED) \
	-e '/^[[:space:]]*Output written/{' \
	-e ' s/.*(\([^)]\{1,\}\)).*/Success!  Wrote \1/' \
	-e ' s/[[:digit:]]\{1,\}/$(C_PAGES)&$(C_RESET)/g' \
	-e ' s/Success!/$(C_SUCCESS)&$(C_RESET)/g' \
	-e '}' \
	-e 's/^! *LaTeX Error:.*/$(C_ERROR)&$(C_RESET)/' -e 't' \
	-e 's/^LaTeX Warning:.*/$(C_WARNING)&$(C_RESET)/' -e 't' \
	-e 's/^Underfull.*/$(C_UNDERFULL)&$(C_RESET)/' -e 't' \
	-e 's/^Overfull.*/$(C_OVERFULL)&$(C_RESET)/' -e 't' \
	$(if $(VERBOSE),,-e 'd')

# Colorize BibTeX output.
color_bib	:= \
	$(SED) \
	-e 's/^Warning--.*/$(C_WARNING)&$(C_RESET)/' -e 't' \
	-e '/---/,/^.[^:]/{' \
	-e '  H' \
	-e '  /^.[^:]/{' \
	-e '    x' \
	-e '    s/\n\(.*\)/$(C_ERROR)\1$(C_RESET)/' \
	-e '	p' \
	-e '    s/.*//' \
	-e '    h' \
	-e '    d' \
	-e '  }' \
	-e '  d' \
	-e '}' \
	-e '/(.*error.*)/s//$(C_ERROR)&$(C_RESET)/' \
	$(if $(VERBOSE),,-e 'd')


# Make beamer output big enough to print on a full page.  Landscape doesn't
# seem to work correctly.
enlarge_beamer	= $(PSNUP) -l -1 -W128mm -H96mm -pletter

# $(call test-run-again,<source stem>)
test-run-again	= $(EGREP) -q '^(.*Rerun .*|No file $1\.[^.]+\.)$$' $1.log

# This tests whether the dvi target should be run at all, from viewing the log
# file.
# $(call test-log-for-need-to-run,<source stem>)
define test-log-for-need-to-run
$(SED) \
-e '/^No file $(call escape-dots,$1)\.aux\./d' \
$1.log \
| $(EGREP) -q '^(.*Rerun .*|No file $1\.[^.]+\.|LaTeX Warning: File.*)$$'
endef

# LaTeX invocations
#
# $(call latex,<tex file>,[<extra LaTeX args>])
run-latex	= $(LATEX) --interaction=batchmode $(if $2,$2,) $1 > /dev/null

# $(call latex-color-log,<LaTeX stem>)
latex-color-log	= $(color_tex) $1.log

# $(call run-makeindex,<tex stem>)
define run-makeindex
success=1; \
if ! $(MAKEINDEX) -q $1.idx > /dev/null || $(EGREP) -q '^!!' $1.ilg; then \
	$(call colorize-makeindex-errors,$1.ilg); \
	success=0; \
fi; \
[ "$$success" = "1" ] && $(sh_true) || $(sh_false);
endef

# BibTeX invocations
#
# $(call run-bibtex,<tex stem>)
run-bibtex	= $(BIBTEX) $1 | $(color_bib)


# $(call convert-gpi,<gpi file>,<eps file>,[gray])
define convert-gpi
$(ECHO) 'set terminal postscript enhanced eps' \
$(call get-default,$(strip \
$(firstword \
	$(shell \
		$(SED) \
			-e 's/^\#\#FONTSIZE=\([[:digit:]]\{1,\}\)/\1/p' \
			-e 'd' \
			$1 $(strip $(gpi_global)) \
	) \
) \
),22) \
$(strip $(if $3,monochrome,$(if \
$(shell $(EGREP) '^\#\#[[:space:]]*GRAY[[:space:]]*$$' $< $(gpi_global)),\
,color))) > $1head.make; \
$(ECHO) 'set output "$2"' >> $1head.make; \
$(if $(gpi_global),$(CAT) $(gpi_global) >> $1head.make;,) \
fnames='$1head.make $1';\
$(if $(gpi_sed),\
	$(SED) -f '$(gpi_sed)' $$fnames > $1.temp.make; \
	fnames=$1.temp.make;,\
) \
success=1; \
if ! $(GNUPLOT) $$fnames 2>$1.log; then \
	$(call colorize-gnuplot-errors,$1.log); \
	success=0; \
fi; \
$(if $(gpi_sed),$(call remove-temporary-files,$1.temp.make);,) \
$(call remove-temporary-files,$1head.make); \
[ "$$success" = "1" ] && $(sh_true) || $(sh_false);
endef

# Creation of .eps files from .fig files
# $(call convert-fig,<fig file>,<eps file>,[gray])
convert-fig	= $(FIG2DEV) -L eps $(if $3,-N,) $1 $2

# Creation of .pstex files from .fig files
# $(call convert-fig-pstex,<fig file>,<pstex file>)
convert-fig-pstex	= $(FIG2DEV) -L pstex $1 $2 > /dev/null 2>&1

# Creation of .pstex_t files from .fig files
# $(call convert-fig-pstex-t,<fig file>,<pstex file>,<pstex_t file>)
convert-fig-pstex-t	= $(FIG2DEV) -L pstex_t -p $3 $1 $2 > /dev/null 2>&1

# Creation of .tex files from .rst files
# TODO: Fix paper size so that it can be specified in the file itself
# $(call convert-rst,<rst file>,<tex file>)
rst_style_file=$(wildcard _rststyle_._include_.tex)
define convert-rst
$(RST2LATEX) \
	--documentoptions=letterpaper \
	$(if $(rst_style_file),--stylesheet=$(rst_style_file),) \
	$1 $2
endef

# Converts .eps.gz files into .eps files
#
# $(call convert-epsgz,<eps.gz file>,<eps file>,[gray])
convert-epsgz	= $(GUNZIP) -c '$1' $(if $3,| $(call kill-ps-color)) > '$2'

# Converts .eps files into .eps files (usually a no-op, but can make grayscale)
#
# $(call convert-eps,<in file>,<out file>,[gray])
convert-eps	= $(if $3,$(call kill-ps-color) $1 > $2)

# The name of the file containing special postscript commands for grayscale
gray_eps_file	:= gray.eps.make

# Changes sethsbcolor and setrgbcolor calls in postscript to always produce
# grayscale.  In general, this is accomplished by writing new versions of those
# functions into the user dictionary space, which is looked up before the
# global or system dictionaries (userdict is one of the permanent dictionaries
# in postscript and is not read-only like systemdict).
#
# For setrgbcolor, the weighted average of the triple is computed and the
# triple is replaced with three copies of that average before the original
# procedure is called: .299R + .587G + .114B
#
# For sethsbcolor, the color is first converted to RGB, then to grayscale by
# the new setrgbcolor operator as described above.  Why is this done?
# Because simply using the value component will tend to make pure colors
# white, a very undesirable thing.  Pure blue should not translate to white,
# but to some level of gray.  Conversion to RGB does the right thing.  It's
# messy, but it works.
#
# From
# http://en.wikipedia.org/wiki/HSV_color_space#Transformation_from_HSV_to_RGB,
# HSB = HSV (Value = Brightness), and the formula used to convert to RGB is
# as follows:
#
# Hi = int(floor(6 * H)) mod 6
# f = 6 * H - Hi
# p = V(1-S)
# q = V(1-fS)
# t = V(1-(1-f)S)
# if Hi = 0: R G B <-- V t p
# if Hi = 1: R G B <-- q V p
# if Hi = 2: R G B <-- p V t
# if Hi = 3: R G B <-- p q V
# if Hi = 4: R G B <-- t p V
# if Hi = 5: R G B <-- V p q
#
# The messy stack-based implementation is below
# $(call create-gray-eps-file,filename)
define create-gray-eps-file
$(ECHO) -n -e '\
/OLDRGB /setrgbcolor load def\n\
/setrgbcolor {\n\
    .114 mul exch\n\
    .587 mul add exch\n\
    .299 mul add\n\
    dup dup\n\
    OLDRGB\n\
} bind def\n\
/OLDHSB /sethsbcolor load def\n\
/sethsbcolor {\n\
    2 index                     % H V S H\n\
    6 mul floor cvi 6 mod       % Hi V S H\n\
    3 index                     % H Hi V S H\n\
    6 mul                       % 6H Hi V S H\n\
    1 index                     % Hi 6H Hi V S H\n\
    sub                         % f Hi V S H\n\
    2 index 1                   % 1 V f Hi V S H\n\
    4 index                     % S 1 V f Hi V S H\n\
    sub mul                     % p f Hi V S H\n\
    3 index 1                   % 1 V p f Hi V S H\n\
    6 index                     % S 1 V p f Hi V S H\n\
    4 index                     % f S 1 V p f Hi V S H\n\
    mul sub mul                 % q p f Hi V S H\n\
    4 index 1 1                 % 1 1 V q p f Hi V S H\n\
    5 index                     % f 1 1 V q p f Hi V S H\n\
    sub                         % (1-f) 1 V q p f Hi V S H\n\
    8 index                     % S (1-f) 1 V q p f Hi V S H\n\
    mul sub mul                 % t q p f Hi V S H\n\
    4 -1 roll pop               % t q p Hi V S H\n\
    7 -2 roll pop pop           % t q p Hi V\n\
    5 -2 roll                   % Hi V t q p\n\
    dup 0 eq\n\
    {1 index 3 index 6 index}\n\
    {\n\
        dup 1 eq\n\
        {3 index 2 index 6 index}\n\
        {\n\
            dup 2 eq\n\
            {4 index 2 index 4 index}\n\
            {\n\
                dup 3 eq\n\
                {4 index 4 index 3 index}\n\
                {\n\
                    dup 4 eq\n\
                    {2 index 5 index 3 index}\n\
                    {\n\
                        dup 5 eq\n\
                        {1 index 5 index 5 index}\n\
                        {0 0 0}\n\
                        ifelse\n\
                    }\n\
                    ifelse\n\
                }\n\
                ifelse\n\
            }\n\
            ifelse\n\
        }\n\
        ifelse\n\
    }\n\
    ifelse                      % B G R Hi V t q p\n\
    setrgbcolor\n\
    5 {pop} repeat\n\
} bind def\n'\
> $1
endef

# This actually inserts the color-killing code into a postscript file
# $(call kill-ps-color)
define kill-ps-color
$(SED) -e '/%%EndComments/r $(gray_eps_file)'
endef

# Converts graphviz .dot files into .eps files
# Grayscale is not directly supported by dot, so we pipe it through fig2dev in
# that case.
# $(call convert-dot,<dot file>,<eps file>,<log file>,[gray])
define convert-dot
$(DOT) -Tps '$1' 2>'$3' $(if $4,| $(call kill-ps-color)) > '$2'; \
$(call colorize-dot-errors,$3)
endef

# Convert DVI to Postscript
# $(call make-ps,<dvi file>,<ps file>,<log file>,[<paper size>])
make-ps		= \
	$(DVIPS) -o '$2' $(if $(filter-out BEAMER,$4),-t$(firstword $4),) '$1' \
		$(if $(filter BEAMER,$4),| $(enlarge_beamer)) > $3 2>&1

# Convert Postscript to PDF
# $(call make-pdf,<ps file>,<pdf file>,<log file>,<embed file>)
make-pdf	= \
	$(if $(filter 1,$(shell $(CAT) '$4')),\
		$(ps2pdf_embedded),\
		$(ps2pdf_normal)) '$1' '$2' > $3 2>&1

# Display information about what is being done
# $(call echo-build,<output file>,[<run number>])
echo-build	= $(ECHO) "$(C_BUILD)= $1 --> $2$(if $3, ($3),) =$(C_RESET)"
echo-graphic	= $(ECHO) "$(C_GRAPHIC)= $1 --> $2 =$(C_RESET)"
echo-dep	= $(ECHO) "$(C_DEP)= $1 --> $2 =$(C_RESET)"

# Display a list of something
# $(call echo-list,<values>)
echo-list	= for x in $1; do $(ECHO) "$$x"; done

#
# DEFAULT TARGET
#

.PHONY: all
all: $(default_pdf_targets) ;

.PHONY: all-pdf
all-pdf: $(default_pdf_targets) ;

.PHONY: all-ps
all-ps: $(default_ps_targets) ;

.PHONY: all-dvi
all-dvi: $(default_dvi_targets) ;

#
# VIEWING TARGET
#
.PHONY: show
show: all
	$(QUIET)for x in $(default_pdf_targets); do \
		[ -e "$$x" ] && $(VIEW_PDF) $$x & \
	done

#
# INCLUDES
#
source_includes	:= $(addsuffix .d,$(source_stems_to_include))
graphic_includes := $(addsuffix .gpi.d,$(graphic_stems_to_include))

# Include only the dependencies used
ifneq "" "$(source_includes)"
include $(source_includes)$(call include-message,$(source_includes))
endif
ifneq "" "$(graphic_includes)"
include $(graphic_includes)$(call include-message,$(graphic_includes))
endif

#
# MAIN TARGETS
#

%: %.pdf ;

# This builds and displays the wanted file.
.PHONY: $(addsuffix ._show,$(stems_ssg))
%._show: %.pdf
	$(QUIET)$(VIEW_PDF) $< &

.SECONDARY: $(all_pdf_targets)
%.pdf: %.ps %.embed.make
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)$(call make-pdf,$<,$@.temp,$@.log,$*.embed.make); \
	if [ x"$$?" = x"0" ]; then \
	    $(if $(VERBOSE),$(CAT) $@.log,:); \
	    $(MV) '$@.temp' '$@'; \
	else \
	    $(CAT) $@.log; \
	    $(call remove-temporary-files,'$@.temp'); \
	    $(sh_false); \
	fi

.SECONDARY: $(all_ps_targets)
%.ps: %.dvi %.paper.make
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)$(call make-ps,$<,$@.temp,$@.log,\
			$(firstword $(shell $(CAT) $*.paper.make))); \
	if [ x"$$?" = x"0" ]; then \
	    $(if $(VERBOSE),$(CAT) $@.log,:); \
	    $(MV) '$@.temp' '$@'; \
	else \
	    $(CAT) $@.log; \
	    $(call remove-temporary-files,'$@.temp'); \
	    $(sh_false); \
	fi

# Build the final dvi file.  This is a very tricky rule because of the way that
# latex runs multiple times, needs graphics after the first run (or maybe
# already has them), and relies on bibliographies or indices that may not exist.
#
#	Check the log for fatal errors.  If they exist, colorize and bail.
#
#	Create the .auxdvi.cookie file.  (Needed for next time if not present)
#
#	If any of the following are true, we must rebuild at least one time:
#
#	* the .bbl was recently rebuilt
#
#		check a cookie, then delete it
#
#	* any of several output files was created or changed:
#
#		check $*.run.cookie, then delete it
#
#	* the .aux file changed in a way that necessitates attention
#
#		Note that if the .auxdvi.make file doesn't exist, this means
#		that we are doing a clean build, so it doesn't figure into the
#		test for running again.
#
#		compare against .auxdvi.make
#
#		move if different, remove if not
#
#	* the .log file has errors or warnings requiring at least one more run
#
#	We use a loop over a single item to simplify the process of breaking
#	out when we find one of the conditions to be true.
#
#	If we do NOT need to run latex here, then we move the $@.1st.make file
#	over to $@ because the .dvi file has already been built by the first
#	dependency run and is valid.
#
#	If we do, we delete that cookie file and do the normal multiple-runs
#	routine.
#
.SECONDARY: $(all_dvi_targets)
%.dvi: %.bbl %.aux
	$(QUIET)\
	fatal=`$(call colorize-latex-errors,$*.log)`; \
	if [ x"$$fatal" != x"" ]; then \
		$(ECHO) "$$fatal"; \
		exit 1; \
	fi; \
	$(call make-auxdvi-file,$*.aux.make,$*.auxdvi.cookie); \
	run=0; \
	for i in 1; do \
		if $(call test-exists,$*.bbl.cookie); then \
			run=1; \
			break; \
		fi; \
		if $(call test-exists,$*.run.cookie); then \
			run=1; \
		    	break; \
		fi; \
		if $(call \
		test-exists-and-different,$*.auxdvi.cookie,$*.auxdvi.make);\
		then \
			run=1; \
			break; \
		fi; \
		if $(call test-log-for-need-to-run,$*); then \
			run=1; \
			break; \
		fi; \
	done; \
	$(call remove-temporary-files,$*.bbl.cookie $*.run.cookie); \
	$(MV) $*.auxdvi.cookie $*.auxdvi.make; \
	if [ x"$$run" = x"1" ]; then \
		$(call remove-files,$@.1st.make); \
		for i in 2 3 4 5; do \
			$(if $(findstring 3.79,$(MAKE_VERSION)),\
				$(call echo-build,$*.tex,$@,$$$$i),\
				$(call echo-build,$*.tex,$@,$$i)\
			); \
			$(call run-latex,$*); \
			$(call test-run-again,$*) || break; \
		done; \
	else \
		$(MV) $@.1st.make $@; \
	fi; \
	$(call latex-color-log,$*)

# Build the .bbl file.  When dependencies are included, this will (or will
# not!) depend on something.bib, which we detect, acting accordingly.  The
# dependency creation also produces the %.auxbbl.make file.  BibTeX is a bit
# finicky about what you call the actual files, but we can rest assured that if
# a .auxbbl.make file exists, then the .aux file does, as well.  The
# .auxbbl.make file is a cookie indicating whether the .bbl needs to be
# rewritten.  It only changes if the .aux file changes in ways relevant to .bbl
# creation.
#
# Note that we do NOT touch the .bbl file if there is no need to
# create/recreate it.  We would like to leave existing files alone if they
# don't need to be changed, thus possibly avoiding a rebuild trigger on the
# .dvi side.
%.bbl: %.auxbbl.make
	$(QUIET)\
	$(if $(filter %.bib,$^),\
		$(call echo-build,$(filter %.bib,$?) $*.aux,$@); \
		$(call run-bibtex,$*); \
		$(TOUCH) $@.cookie; \
	)

# Create the index file
%.ind:	%.idx %.tex
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)$(call run-makeindex,$*)
#
# SCRIPTED LaTeX TARGETS
#
.SECONDARY: $(all_tex_targets)
%.tex:	%.tex.sh
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)$(SHELL) $< $@

%.tex:	%.rst $(rst_style_file)
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)$(call convert-rst,$<,$@)

#
# GRAYSCALE LaTeX TARGETS
#

# Parse %.d to get all of the include files, then run sed to generate new files
# for all of them that depend on _gray.
%._gray_.tex: %.d %.tex
	$(QUIET)$(call echo-build,$^,$@)
	$(QUIET)\
	texstems=`$(SED) \
		 -e 's/[^:]*:[[:space:]]*\(.*\)\.tex[[:space:]]*$$/\\1/p' \
		 -e 'd' \
		 $<`; \
	for f in $$texstems; do \
		$(SED) \
		-e 's/\.eps/._gray_&/' \
		-e 's/\.pstex/._gray_&/' \
		-e 's/\.pstex_t/._gray_&/' \
		-e 's/_include_/&._gray_/g' \
		$$f.tex > $$f._gray_.tex; \
	done;

#
# GRAPHICS TARGETS
#
.PHONY: all-graphics
all-graphics:	$(all_graphics_targets);

.PHONY: all-pstex all-gray-pstex
all-pstex:	$(all_pstex_targets);
all-gray-pstex:	$(all_gray_pstex_targets);

.PHONY: show-graphics
show-graphics: all-graphics
	$(VIEW_GRAPHICS) $(all_known_graphics)

$(gray_eps_file):
	$(QUIET)$(call echo-build,$^,$@)
	$(QUIET)$(call create-gray-eps-file,$@)

%._gray_.eps:	%.gpi $(gpi_sed)
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-gpi,$<,$@,1)

%._gray_.eps:	%.fig
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-fig,$<,$@,1)

%._gray_.eps: %.dot $(gray_eps_file)
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-dot,$<,$@,$<.log,1)

%._gray_.eps: %.eps.gz $(gray_eps_file)
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-epsgz,$<,$@,1)

%._gray_.eps: %.eps $(gray_eps_file)
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-eps,$<,$@,1)

%._gray_.pstex: %.fig
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-fig-pstex,$<,$@,1)

%._gray_.pstex_t: %.fig %._gray_.pstex
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-fig-pstex-t,$<,$@,$*._gray_.pstex,1)

%.eps:	%.gpi $(gpi_sed)
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-gpi,$<,$@,$(GRAY))

%.eps: %.fig
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-fig,$<,$@,$(GRAY))

%.eps: %.dot $(if $(GRAY),$(gray_eps_file))
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-dot,$<,$@,$<.log,$(GRAY))

%.eps: %.eps.gz $(if $(GRAY),$(gray_eps_file))
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-epsgz,$<,$@,$(GRAY))

%.pstex: %.fig
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-fig-pstex,$<,$@,$(GRAY))

%.pstex_t: %.fig %.pstex
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-fig-pstex-t,$<,$@,$*.pstex,$(GRAY))

#
# DEPENDENCY-RELATED TARGETS.
#

# Generate all of the information needed to get dependencies
# As a side effect, this creates a .dvi file.  We need to be sure to remove it
# if there are errors.  Errors can take several forms and all of them are found
# within the log file:
#	* There was a LaTeX error
#	* A needed file was not found
#	* Cross references need adjustment
#
# Behavior:
#	This rule is responsible for generating the following:
#	%.aux
#	%.d
#	%.aux.make
#	%.dvi.1st.make (the .dvi file, moved)
#
#	Steps:
#
#	Run latex
#	Move .dvi somewhere else (make no judgements about success)
#	Flatten the .aux file into another file
#	Add source dependencies
#	Add graphic dependencies
#	Add bib dependencies
#
#	Create cookies for various suffixes that may represent files that
#	need to be read by LaTeX in order for it to function properly.
#
%.d %.aux %.aux.make: %.tex
	$(QUIET)$(call echo-build,$<,$*.d $*.dvi,1)
	$(QUIET)\
	$(call run-latex,$<,--recorder) || $(sh_true); \
	$(call die-on-pstexs,$*.log); \
	$(MV) $*.dvi $*.dvi.1st.make; \
	$(call flatten-aux,$*.aux,$*.aux.make); \
	$(ECHO) "# vim: ft=make" > $*.d; \
	$(ECHO) ".PHONY: $*._graphics" >> $*.d; \
	$(call get-inputs,$*.fls,$(addprefix $*.,aux aux.make d dvi)) >> $*.d; \
	$(call get-graphics,$*.log,$(addprefix $*.,d dvi _graphics)) >> $*.d; \
	$(call get-inds,$*.log,$(addprefix $*.,d aux aux.make)) >> $*.d; \
	$(call get-bibs,$*.aux.make,$(addprefix $*.,bbl aux aux.make)) >> $*.d; \
	for s in toc out lot lof nav; do \
		if [ -e "$*.$$s" ]; then \
			if ! $(DIFF) -q $*.$$s $*.$$s.make 2>/dev/null; then \
				$(TOUCH) $*.run.cookie; \
			fi; \
			$(CP) $*.$$s $*.$$s.make; \
		fi; \
	done

# This is a cookie that is updated if the flattened aux file has changed in a
# way that affects the bibliography generation.
.SECONDARY: $(addsuffix .auxbbl.make,$(stems_ssg))
%.auxbbl.make: %.aux.make
	$(QUIET)\
	$(call make-auxbbl-file,$<,$@.temp); \
	$(call replace-if-different-and-remove,$@.temp,$@)

# Build a dependency file for .gpi files.  These often plot data files that
# also reside in the directory, so if a data file changes, it's nice to know
# about it.  This also handles loaded .gpi files, whose filename should have
# _include_. in it.
%._gray_.gpi.d: %.gpi
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)$(call make-gpi-d,$<,$@)

%.gpi.d: %.gpi
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)$(call make-gpi-d,$<,$@)

# Store the paper size for this document -- note that if beamer is used we set
# it to the special BEAMER paper size.  We only do this, however, if the
# special comment exists, in which case we enlarge the output with psnup.
#
#	The paper size is extracted from a documentclass attribute.
%.paper.make: %.tex
	$(QUIET)$(SED) \
	-e '/\\documentclass/,/}/{' \
	-e '  s/%.*//' \
	-e '  H' \
	-e '  /}/{' \
	-e '    s/.*//' \
	-e '    x' \
	-e '    /\\documentclass/!d' \
	-e '    s/[\n[:space:]]*//g' \
	-e '    s/\([,{[]\)\([[:alnum:]]\{1,\}\)paper\([],}]\)/\1%-\2-%\3/g' \
	-e '    s/\([,{[]\)\(landscape\)\([],}]\)/\1%-\2-%\3/g' \
	-e '    s/^[^%]*%-//' \
	-e '    s/-%[^%]*$$//' \
	-e '    s/-%[^%]%-/ /g' \
	-e '    p' \
	-e '  }' \
	-e '  d' \
	-e '}' \
	-e 'd' \
	$< > $@; \
	$(EGREP) -q '^[^%]*\\documentclass[^{]*{beamer}' $< && \
	(\
		$(EGREP) -q '^%%[[:space:]]*BEAMER[[:space:]]*LARGE$$' $< && \
		$(ECHO) "BEAMER" > $@ || \
		: > $@ \
	) || $(sh_true)

# Store embedding instructions for this document using a special comment
%.embed.make: %.tex
	$(QUIET)$(EGREP) '^%%[[:space:]]*NO[[:space:]]*EMBED[[:space:]]*$$' $< \
		&& $(ECHO) '' > $@ \
		|| $(ECHO) '1' > $@;

#
# HELPFUL PHONY TARGETS
#

.PHONY: _all_programs
_all_programs:
	$(QUIET)$(ECHO) "== All External Programs Used =="
	$(QUIET)$(call output-all-programs)

.PHONY: _check_programs
_check_programs:
	$(QUIET)$(ECHO) "== Checking Makefile Dependencies =="; $(ECHO)
	$(QUIET) \
	$(ECHO) hi; \
	allprogs=`\
	 ($(call output-all-programs)) | \
	 $(SED) \
	 -e 's/^[[:space:]]*//' \
	 -e '/^#/d' \
	 -e 's/[[:space:]]*#.*//' \
	 -e '/^=/s/[[:space:]]/_/g' \
	 -e '/^[[:space:]]*$$/d' \
	 -e 's/^[^=].*=[[:space:]]*\([^[:space:]]\{1,\}\).*$$/\\1/' \
	 `; \
	spaces='                             '; \
	for p in $${allprogs}; do \
	case $$p in \
		=*) $(ECHO); $(ECHO) "$$p";; \
		*) \
			$(ECHO) -n "$$p:$$spaces" | $(SED) -e 's/^\(.\{0,20\}\).*$$/\1/'; \
			loc=`$(WHICH) $$p`; \
			if [ x"$$?" = x"0" ]; then \
				$(ECHO) "$(C_SUCCESS)Found:$(C_RESET) $$loc"; \
			else \
				$(ECHO) "$(C_FAILURE)Not Found$(C_RESET)"; \
			fi; \
			;; \
	esac; \
	done

.PHONY: _check_gpi_files
_check_gpi_files:
	$(QUIET)$(ECHO) "== Checking all .gpi files for common errors =="; \
	$(ECHO); \
	for f in $(files.gpi); do \
	result=`$(EGREP) '^([^#]*set terminal |set output )' $$f`; \
	$(ECHO) -n "$$f: "; \
	if [ x"$$result" = x"" ]; then \
		$(ECHO) "$(C_SUCCESS)Okay$(C_RESET)"; \
	else \
		$(ECHO) "$(C_FAILURE)Warning: Problematic commands:$(C_RESET)";\
		$(ECHO) "$(C_ERROR)$$result$(C_RESET)"; \
	fi; \
	done; \
	$(ECHO)

.PHONY: _all_stems
_all_stems:
	$(QUIET)$(ECHO) "== All Stems =="
	$(QUIET)$(call echo-list,$(sort $(all_stems)))

.PHONY: _includes
_includes:
	$(QUIET)$(ECHO) "== Include Stems =="
	$(QUIET)$(ECHO) "=== Sources ==="
	$(QUIET)$(call echo-list,$(sort $(source_includes)))
	$(QUIET)$(ECHO) "=== Graphics ==="
	$(QUIET)$(call echo-list,$(sort $(graphic_includes)))

.PHONY: _all_sources
_all_sources:
	$(QUIET)$(ECHO) "== All Sources =="
	$(QUIET)$(call echo-list,$(sort $(all_files.tex)))

.PHONY: _dependency_graph
_dependency_graph:
	$(QUIET)$(ECHO) "/* LaTeX Dependency Graph */"
	$(QUIET)$(call output-dependency-graph)

.PHONY: _show_dependency_graph
_show_dependency_graph:
	$(QUIET)$(call output-dependency-graph,$(graph_stem).dot)
	$(QUIET)$(DOT) -Tps -o $(graph_stem).eps $(graph_stem).dot
	$(QUIET)$(VIEW_POSTSCRIPT) $(graph_stem).eps
	$(QUIET)$(call remove-temporary-files,$(graph_stem).*)

.PHONY: _sources
_sources:
	$(QUIET)$(ECHO) "== Sources =="
	$(QUIET)$(call echo-list,$(sort $(files.tex)))

.PHONY: _scripts
_scripts:
	$(QUIET)$(ECHO) "== Scripts =="
	$(QUIET)$(call echo-list,$(sort $(files_scripts)))

.PHONY: _graphic_outputs
_graphic_outputs:
	$(QUIET)$(ECHO) "== Graphic Outputs =="
	$(QUIET)$(call echo-list,$(sort $(all_graphics_targets)))

.PHONY: _graphic_sources
_graphic_sources:
	$(QUIET)$(ECHO) "== Graphic Sources =="
	$(QUIET)$(call echo-list,$(sort $(files_graphics)))

.PHONY: _env
_env:
ifdef .VARIABLES
	$(QUIET)$(ECHO) "== MAKE VARIABLES =="
	$(QUIET)$(call echo-list,$(foreach var,$(sort $(.VARIABLES)),'$(var)'))
endif
	$(QUIET)$(ECHO) "== ENVIRONMENT =="
	$(QUIET)$(ENV)

#
# CLEAN TARGETS
#
.PHONY: clean-deps
clean-deps:
	$(QUIET)$(call remove-files,$(all_d_targets) *.make *.make.temp *.cookie)

.PHONY: clean-tex
clean-tex: clean-deps
	$(QUIET)$(call remove-files,$(rm_tex))

.PHONY: clean-graphics
# TODO: This *always* deletes pstex files, even if they were not generated by
# anything....  In other words, if you create a pstex and pstex_t pair by hand
# an drop them in here without the generating fig file, they will be deleted
# and you won't get them back.  It's a hack put in here because I'm not sure we
# even want to keep pstex functionality, so my motivation is not terribly high
# for doing it right.
clean-graphics:
	$(QUIET)$(call remove-files,$(all_graphics_targets) *.gpi.d *.pstex *.pstex_t)

.PHONY: clean-backups
clean-backups:
	$(QUIET)$(call remove-files,$(backup_patterns) *.temp)

.PHONY: clean-auxiliary
clean-auxiliary:
	$(QUIET)$(call remove-files,$(graph_stem).*)

.PHONY: clean-nographics
clean-nographics: clean-tex clean-deps clean-backups clean-auxiliary ;

.PHONY: clean
clean:	clean-tex clean-graphics clean-deps clean-backups clean-auxiliary

#
# HELP TARGETS
#

.PHONY: help
help:
	$(help_text)

.PHONY: version
version:
	$(QUIET)\
	$(ECHO) "$(fileinfo) Version $(version)"; \
	$(ECHO) "by $(author)"; \
	$(ECHO); \
	$(ECHO) 'SVN info: $(svninfo)';

#
# HELP TEXT
#

define help_text
# $(fileinfo) Version $(version)
#
# by $(author)
#
# Generates a number of possible output files from a LaTeX document and its
# various dependencies.  Handles .bib files, \include and \input, and .eps
# graphics.  All dependencies are handled automatically by running LaTeX over
# the source.
#
# USAGE:
#
#    make [GRAY=1] [VERBOSE=1] [SHELL_DEBUG=1] <target(s)>
#
# STANDARD OPTIONS:
#    GRAY:
#        Setting this variable forces all recompiled graphics to be grayscale.
#        It is useful when creating a document for printing.  The default is
#        to allow colors.  Note that it only changes graphics that need to be
#        rebuilt!  It is usually a good idea to do a 'make clean' first.
#
#        There is another facility for creating grayscale documents that is
#        better when you can use it (it has some small limitations not shared
#        by this approach).  See the section on %._gray_ targets below.
#
#    VERBOSE:
#        This turns off all @ prefixes for commands invoked by make.  Thus,
#        you get to see all of the gory details of what is going on.
#
#    SHELL_DEBUG:
#        This enables the -x option for sh, meaning that everything it does is
#        echoed to stderr.  This is particularly useful for debugging
#        what is going on in $$(shell ...) invocations.  One of my favorite
#        debugging tricks is to do this:
#
#        make -d SHELL_DEBUG=1 VERBOSE=1 2>&1 | less
#
# STANDARD ENVIRONMENT VARIABLES:
#
#      LATEX_COLOR_WARNING		'$(LATEX_COLOR_WARNING)'
#      LATEX_COLOR_ERROR		'$(LATEX_COLOR_ERROR)'
#      LATEX_COLOR_UNDERFULL		'$(LATEX_COLOR_UNDERFULL)'
#      LATEX_COLOR_OVERFULL		'$(LATEX_COLOR_OVERFULL)'
#      LATEX_COLOR_PAGES		'$(LATEX_COLOR_PAGES)'
#      LATEX_COLOR_BUILD		'$(LATEX_COLOR_BUILD)'
#      LATEX_COLOR_GRAPHIC		'$(LATEX_COLOR_GRAPHIC)'
#      LATEX_COLOR_DEP			'$(LATEX_COLOR_DEP)'
#      LATEX_COLOR_SUCCESS		'$(LATEX_COLOR_SUCCESS)'
#      LATEX_COLOR_FAILURE		'$(LATEX_COLOR_FAILURE)'
#
#   These may be redefined in your environment to be any of the following:
#
#      black
#      red
#      green
#      yellow
#      blue
#      magenta
#      cyan
#      white
#
#   Bold or underline may be used, as well, either alone or in combination
#   with colors:
#
#      bold
#      uline
#
#   Order is not important.  You may want, for example, to specify:
#
#   export LATEX_COLOR_SUCCESS='bold blue uline'
#
#   in your .bashrc file.  I don't know why, but you may want to.
#
# STANDARD TARGETS:
# 
#    all:
#        Make all possible documents in this directory.  The documents are
#        determined by scanning for .tex and .tex.sh (described in more detail
#        later) and omitting any file that ends in ._include_.tex or
#        ._nobuild_.tex.  The output is a set of .pdf files.
#
#        If you wish to omit files without naming them with the special
#        underscore names, set the following near the top of the Makefile,
#        or (this is recommended) within a Makefile.ini in the same directory:
#
#        	includes.tex := file1.tex file2.tex
#
#        This will cause the files listed to be considered as include files.
#
#        If you have only few source files, you can set
#
#        	onlysources.tex := main.tex
#
#        This will cause only the source files listed to be considered in
#        dependency detection.  All other .tex files will be considered as
#        include files.  Note that these options work for *any* source type,
#        so you could do something similar with includes.gpi, for example.
#
#    show:
#        Builds and displays all documents in this directory.  It uses the
#        environment-overridable value of VIEW_PDF (currently $(VIEW_PDF)) to
#        do its work.
#
#    all-graphics:
#        Make all of the graphics in this directory.
#
#    all-pstex:
#        Build all fig files into pstex and pstex_t files.  Gray DOES NOT WORK.
#
#    show-graphics:
#        Builds and displays all graphics in this directory.  Uses the
#        environment-overridable value of VIEW_GRAPHICS (currently
#        $(VIEW_GRAPHICS)) to do its work.
#
#    clean:
#        Remove ALL generated files, leaving only source intact.
#
#    clean-graphics:
#        Remove all generated graphics files.
#
#    clean-backups:
#        Remove all backup files: $(backup_patterns)
#        (XFig and other editors have a nasty habit of leaving them around)
#        Also removes Makefile-generated .temp files
#
#    clean-tex:
#        Remove all files generated from LaTeX invocations except dependency
#        information.  Leaves graphics alone.
#
#    clean-deps:
#        Removes all auto-generated dependency information.
#
#    clean-auxiliary:
#        Removes extra files created by various targets (like the dependency
#        graph output).
#
#    clean-nographics:
#        Cleans everything *except* the graphics files.
#
#    help:
#        This help text.
#
#    version:
#        Version information about this LaTeX makefile.
#
# DEBUG TARGETS:
#
#    _all_programs:
#        A list of the programs used by this makefile.
#
#    _check_programs:
#        Checks your system for the needed software and reports what it finds.
#
#    _check_gpi_files:
#        Checks the .gpi files in the current directory for common errors, such
#        as specification of the terminal or output file inside of the gpi file
#        itself.
#
#    _dependency_graph:
#        Outputs a .dot file to stdout that represents a graph of LaTeX
#        dependencies.  To see it, use the _show_dependency_graph target or
#        direct the output to a file, run dot on it, and view the output, e.g.:
#
#        make _dependency_graph > graph.dot
#        dot -T ps -o graph.eps graph.dot
#        gv graph.eps
#
#    _show_dependency_graph:
#        Makes viewing the graph simple: extracts, builds and displays the
#        dependency graph given in the _dependency_graph target using the value
#        of the environment-overridable VIEW_POSTSCRIPT variable (currently set
#        to $(VIEW_POSTSCRIPT)).  The postscript viewer is used because it
#        makes it easier to zoom in on the graph, a critical ability for
#        something so dense and mysterious.
#
#    _all_sources:
#        List all .tex files in this directory.
#
#    _sources:
#        Print out a list of all compilable sources in this directory.  This is
#        useful for determining what make thinks it will be using as the
#        primary source for 'make all'.
#
#    _scripts:
#        Print out a list of scripts that make knows can be used to generate
#        .tex files (described later).
#
#    _all_stems:
#        Print a list of stems.  These represent bare targets that can be
#        executed.  Listing <stem> as a bare target will produce <stem>.pdf.
#
#    _includes:
#        A list of .d files that would be included in this run if _includes
#        weren't specified.  This target may be used alone or in conjunction
#        with other targets.
#
#    _graphic_sources:
#        A list of all files that can create .eps files
#
#    _graphic_outputs:
#        A list of all generated .eps files
#
#    _env:
#        A list of environment variables and their values.  If supported by
#        your version of make, also a list of variables known to make.
#
# FILE TARGETS:
#
#    %, %.pdf:
#        Build a PDF file from the corresponding %.tex file.  This is
#        done using dvips and ps2pdf.  Some may object to this idea,
#        saying that pdflatex is a better approach, but I disagree for
#        two major reasons:
#
#        * Postscript can be a very nice thing to have directly from the LaTeX
#          file, especially when printing.
#
#        * One word: psfrag.  If you don't know this wonderful package, get to
#          know it.  It is a workhorse for making graphs pretty.
#
#    %._show:
#        A phony target that builds the pdf file and then displays it using the
#        environment-overridable value of VIEW_PDF ($(VIEW_PDF)).
#
#    %._graphics:
#        A phony target that generates all graphics on which %.dvi
#        depends.
#
#    %.ps:
#        Build a Postscript file from the corresponding %.tex file.
#        This is done using dvips.  Paper size is automatically
#        extracted from the declaration
#
#        \documentclass[<something>paper]
#
#        or it is the system default.
#
#        If using beamer (an excellent presentation class), the paper
#        size is ignored.  More on this later.
#
#    %.dvi:
#        Build the DVI file from the corresponding %.tex file.
#
#    %.ind:
#        Build the index for this %.tex file.
#
#    %.eps:
#        Build an eps file from one of the following file types:
#
#       .dot    : graphviz
#       .gpi    : gnuplot
#       .fig    : xfig
#       .eps.gz : gzipped eps
#
#       The behavior of this makefile with each type is described in
#       its own section below.
#
#    %.pstex{,_t}:
#       Build a .pstex_t file from a .fig file.
#
#    All targets have a corresponding %._gray_.suffix form, which creates
#    everything in monochrome.  This is useful for creating both color and
#    grayscale versions of the same document, and they can coexist happily in
#    the same directory.  Examples:
#
#       make test._gray_._graphics 	# Build all grayscale graphics
#       make test._gray_		# Build a grayscale document
#
#    The use of a ._gray_ target creates ._gray_.tex files (not forgetting the
#    included files!) with appropriate dependencies on ._gray_.eps graphics.
#    This approach is in many ways superior to specifying GRAY=1 on the command
#    line, but has some limitations.  Because a new .tex file must be created,
#    this means that the original .tex file must be parsed and all references
#    to graphics and include files must be transformed.  This can be a brittle
#    operation in a macro-based language like LaTeX, since it is very easy to
#    define macros that call \include or \input indirectly.
#
#    Here the naming strategy for include files comes into play.  They all have
#    ._include_. in their name, and are therefore fairly easy to search out.
#    That sequence is unlikely to appear in text, so it is fairly safe to
#    replace it.  Anything ending in .eps is also replaced to end with
#    ._gray_.eps, and is subject to the same issues.
#
#    In short, if your file contains _include_ when not referencing a file, or
#    it says .eps when not referencing a graphic, this approach is probably not
#    for you.  I imagine that these cases are fairly rare, however, so it
#    should work most of the time.  When a doubt arises, you can be sure that
#    GRAY=1 will do the right thing, provided you precede it with a 'make
#    clean'.
#
# FEATURES:
#
#    External Program Dependencies:
#        Every external program used by the makefile is represented by an
#        ALLCAPS variable at the top of this file.  This should allow you to
#        make judgments about whether your system supports the use of this
#        makefile.  The list is available in the ALL_PROGRAMS variable and,
#        provided that you are using GNU make 3.80 or later (or you haven't
#        renamed this file to something weird like "mylatexmakefile" and like
#        invoking it with make -f) can be viewed using
#
#        make _all_programs
#
#        Additionally, the availability of these programs can be checked
#        automatically for you by running
#
#        make _check_programs
#
#        The programs are categorized according to how important they are and
#        what function they perform to help you decide which ones you really
#        need.
#
#    Colorized Output:
#        The output of commands is colorized to highlight things that are often
#        important to developers.  This includes {underfull,overfull}
#        {h,v}boxes, general LaTeX Errors, each stage of document building, and
#        the number of pages in the final document.  The colors are obtained
#        using 'tput', so colorization should work pretty well on any terminal.
#
#        The colors can be customized very simply by setting any of the
#        LATEX_COLOR_<CONTEXT> variables in your environment (see above).
#
#    Predecessors to TeX Files:
#        Given a target <target>, if no <target>.tex file exists but a
#        corresponding script or predecessor file exists, then appropriate
#        action will be taken to generate the tex file.
#
#        Currently supported script or predecessor languages are:
#
#        sh:     %.tex.sh
#
#           Calls the script using sh, assuming that its output is a .tex
#           file.  Of course, your .sh file can call another script to do
#           its work.  Go wild!
#
#           The script is called thus:
#
#              <interpreter> <script file name> <target tex file>
#
#           and therefore sees exactly one parameter: the name of the .tex
#           file that it is to create.
#
#           Why does this feature exist?  I ran into this while working on
#           my paper dissertation.  I wrote a huge bash script that used a
#           lot of sed to bring together existing papers in LaTeX.  It
#           would have been nice had I had something like this to make my
#           life easier, since as it stands I have to run the script and
#           then build the document with make.  This feature provides hooks
#           for complicated stuff that you may want to do, but that I have
#           not considered.
#
#           This approach does not work for included .tex files.  If you
#           want to do something special with those, you should wrap all of
#           that functionality into a top-level source script that creates
#           the necessary includes as well.
#
#        reST:	 %.rst
#
#           Runs the reST to LaTeX converter to generate a .tex file
#           If it finds a file names _rststyle_._include_.tex, uses it as
#           the "stylesheet" option to rst2latex.
#
#    Dependencies:
#
#        In general, dependencies are extracted directly from LaTeX output on
#        your document.  This includes
#
#        *    Bibliography information
#        *    \include or \input files (honoring \includeonly, too)
#        *    Graphics files inserted by the graphicx package
#
#        Where possible, all of these are built correctly and automatically.
#        In the case of graphics files, these are generated from the following
#        file types:
#
#        GraphViz:      .dot
#        GNUPlot:       .gpi
#        XFig:          .fig
#        GZipped EPS:   .eps.gz
#
#        If the file exists as a .eps already, it is merely used (and will not
#        be deleted by 'clean'!).
#
#        LaTeX and BibTeX are invoked correctly and the "Rerun to get
#        cross-references right" warning is heeded a reasonable number of
#        times.  In my experience this is enough for even the most troublesome
#        documents, but it can be easily changed (if LaTeX has to be run after
#        BibTeX more than three times, it is likely that something is moving
#        back and forth between pages, and no amount of LaTeXing will fix
#        that).
#
#        \includeonly is honored by this system, so files that are not
#        specified there will not trigger a rebuild when changed.
#
#    Beamer:
#        A special TeX source comment is recognized by this makefile:
#
#        %%[[:space:]]*BEAMER[[:space:]]*LARGE
#
#        The presence of this comment forces the output of dvips through psnup
#        to enlarge beamer slides to take up an entire letter-sized page.  This
#        is particularly useful when printing transparencies or paper versions
#        of the slides.  For some reason landscape orientation doesn't appear
#        to work, though.
#
#        If you want to put multiple slides on a page, use this option and then
#        print using mpage, a2ps, or psnup to consolidate slides.  My personal
#        favorite is a2ps, but your mileage may vary.
#
#        When beamer is the document class, dvips does NOT receive a paper size
#        command line attribute, since beamer does special things with sizes.
#
#    GNUPlot Graphics:
#        When creating a .gpi file, DO NOT INCLUDE the "set terminal" or "set
#        output" commands!  The makefile will include terminal information for
#        you.  Besides being unnecessary and potentially harmful, including the
#        terminal definition in the .gpi file makes it harder for you, the one
#        writing the document, to preview your graphics, e.g., with
#
#           gnuplot -persist myfile.gpi
#
#        so don't do specify a terminal or an output file in your .gpi files.
#
#        When building a gpi file into an eps file, there are several features
#        available to the document designer:
#
#        Global Header:
#            The makefile searches for the files in the variable GNUPLOT_GLOBAL
#            in order:
#
#            ($(GNUPLOT_GLOBAL))
#
#            Only the first found is used.  All .gpi files in the directory are
#            treated as though the contents of GNUPLOT_GLOBAL were directly
#            included at the top of the file.
#
#            NOTE: This includes special comments! (see below)
#
#        Font Size:
#            A special comment in a .gpi file (or a globally included file) of
#            the form
#
#            ## FONTSIZE=<number>
#
#            will change the font size of the GPI output.  If font size is
#            specified in both the global file and the GPI file, the
#            specification in the individual GPI file is used.
#
#        Grayscale Output:
#            GNUplot files also support a special comment to force them to be
#            output in grayscale *no matter what*:
#
#            ## GRAY
#
#            This is not generally advisable, since you can always create a
#            grayscale document using the forms mentioned above.  But, if your
#            plot simply must be grayscale even in a document that allows
#            colors, this is how you do it.    
#
#    XFig Graphics:
#            No special handling is done with XFig, except when a global
#            grayscale method is used, e.g.
#
#                make document._gray_
#                or
#                make GRAY=1 document
#
#            In these cases the .eps files is created using the -N switch to
#            fig2dev to turn off color output.  (Only works with eps, not
#            pstex output!)
#
#    GraphVis Graphics:
#            Color settings are simply ignored here.  The 'dot' program is used
#            to transform a .dot file into a .eps file.
#
#    GZipped EPS Graphics:
#        
#        A .eps.gz file is sometimes a nice thing to have.  EPS files can get
#        very large, especially when created from bitmaps (don't do this if you
#        don't have to).  This makefile will unzip them (not in place) to
#        create the appropriate EPS file.
#
endef

#
# DEPENDENCY CHART:
#
#digraph "g" {
#    rankdir=TB
#    size="9,9"
#    edge [fontsize=12 weight=10]
#    node [shape=box fontsize=14 style=rounded]
#
#    eps [
#        shape=Mrecord
#        label="{{<gpi> GNUplot|<epsgz> GZip|<dot> Dot|<fig> XFig}|<eps> eps}"
#        ]
#    pstex [label="%.pstex"]
#    pstex_t [label="%.pstex_t"]
#    tex_outputs [shape=point]
#    extra_tex_files [shape=point]
#    gpi_data [label="<data>"]
#    gpi_includes [label="_include_.gpi"]
#    aux [label="%.aux"]
#    fls [label="%.fls"]
#    idx [label="%.idx"]
#    ind [label="%.ind"]
#    log [label="%.log"]
#    tex_sh [label="%.tex.sh"]
#    rst [label="%.rst"]
#    tex [
#        shape=record
#        label="<tex> %.tex|<include> _include_.tex"
#        ]
#    include_aux [label="_include_.aux"]
#    file_bib [label=".bib"]
#    bbl [label="%.bbl"]
#    dvi [label="%.dvi"]
#    ps [label="%.ps"]
#    pdf [label="%.pdf"]
#    fig [label=".fig"]
#    dot [label=".dot"]
#    gpi [label=".gpi"]
#    eps_gz [label=".eps.gz"]
#
#    gpi_files [shape=point]
#
#    rst -> tex:tex [label="reST"]
#    tex_sh -> tex:tex [label="sh"]
#    tex -> tex_outputs [label="latex"]
#    tex_outputs -> dvi
#    tex_outputs -> aux
#    tex_outputs -> log
#    tex_outputs -> fls
#    tex_outputs -> idx
#    tex_outputs -> include_aux
#    aux -> bbl [label="bibtex"]
#    file_bib -> bbl [label="bibtex"]
#    idx -> ind [label="makeindex"]
#    ind -> extra_tex_files
#    bbl -> extra_tex_files
#    eps -> extra_tex_files
#    extra_tex_files -> dvi [label="latex"]
#    gpi_files -> eps:gpi [label="gnuplot"]
#    gpi -> gpi_files
#    gpi_data -> gpi_files
#    gpi_includes -> gpi_files
#    eps_gz -> eps:epsgz [label="gunzip"]
#    fig -> eps:fig [label="fig2dev"]
#    fig -> pstex [label="fig2dev"]
#    fig -> pstex_t [label="fig2dev"]
#    pstex -> pstex_t [label="fig2dev"]
#    dot -> eps:dot [label="dot"]
#    dvi -> ps [label="dvips"]
#    include_aux -> bbl [label="bibtex"]
#    ps -> pdf [label="ps2pdf"]
#
#    edge [ color=blue label="" style=dotted weight=1 fontcolor=blue]
#    fls -> tex:include [label="INPUT: *.tex"]
#    fls -> file_bib [label="INPUT: *.aux"]
#    aux -> file_bib [label="\\bibdata{...}"]
#    include_aux -> file_bib [label="\\bibdata{...}"]
#    log -> gpi [label="Graphic file"]
#    log -> fig [label="Graphic file"]
#    log -> eps_gz [label="Graphic file"]
#    log -> dot [label="Graphic file"]
#    log -> idx [label="No such *.ind"]
#    gpi -> gpi_data [label="plot '...'"]
#    gpi -> gpi_includes [label="load '...'"]
#    tex:tex -> ps [label="paper"]
#    tex:tex -> pdf [label="embedding"]
#}

#
# DEPENDENCY CHART SCRIPT
#
# $(call output_dependency_graph,[<output file>])
define output-dependency-graph
	if [ -f '$(this_file)' ]; then \
	$(SED) \
		-e '/^[[:space:]]*#[[:space:]]*DEPENDENCY CHART:/,/^$$/!d' \
		-e '/DEPENDENCY CHART/d' \
		-e '/^$$/d' \
		-e 's/^[[:space:]]*#//' \
		$(this_file) $(if $1,> '$1',); \
	else \
		$(ECHO) "Cannot determine the name of this makefile."; \
	fi
endef
# vim: noet sts=0 sw=8 ts=8
