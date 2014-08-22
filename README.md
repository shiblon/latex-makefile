#LaTeX Makefile

This is a single GNU makefile that builds a LaTeX document into various targets with minimal latex/bibtex invocations.  It colorizes and swallows the normally unhelpful latex output so that errors and other important messages are easy to spot.  It handles GNUplot, Fig, and Dot image creation (and many more formats besides), and does automatic dependency tracking.

Perhaps most important, it is convenient because it is a *single file* and only depends on standard Unix utilities that are likely to exist on any system.  It includes built-in help documentation and various utilities to test whether it will work on your system.  Just drop it in your source directory and type `make`.  Is something not working?  Type `make help | less`.
