#!/usr/bin/env python2.6

from __future__ import print_function, division

import re
import sys
from operator import itemgetter
from pprint import pprint

class Template(object):
    _tmpl_re = re.compile(r"(?ms)#?\(##\s*(.*?)\s*##\)(\s*\n?)")
    _tmpl_comment_re = re.compile(r"(?ms)^\s*#")

    def __init__(self, **kargs):
        self._defaults = {}
        for k, v in kargs.iteritems():
            setattr(self, k, v)

    def TPL_defaults(self, **kargs):
        """Set default variable values for this namespace.

        Clobbers previous defaults.

        This has no output, so it returns None to eat trailing space.
        """
        self._defaults = kargs.copy()
        return None

    def TPL_include_script(self, cmd, script_file_name, transform_before,
                           transform_after, *script_args, **script_variables):
        cmd_args = [cmd]
        cmd_args.extend(
            self.expand_file(script_file_name,
                             variables=script_variables,
                             transform_before=transform_before,
                             transform_after=transform_after).split("\n"))
        cmd_args.extend(script_args)
        return " \\\n".join(cmd_args)

    def TPL_include_sed(self, cmd, fname, *args, **variables):
        return self.TPL_include_script(cmd, fname,
                                       self.xfunc_escape_character("$", "$$"),
                                       self.xfunc_sed_lines_to_args(),
                                       *args, **variables)

    def TPL_include_as_comment(self, fname, leader="# "):
        return self.expand_file(fname,
                                transform_after=self.xfunc_add_leader(leader))

    def xfunc_compose(self, *xf_list):
        """Compose transforms to create a new one.

        This does the last one first so that xfunc_compose(a, b, c) returns a
        function f(x) = a(b(c(x))).
        """
        def xf_compose(text):
            xf_list.reverse()
            for f in xf_list:
                text = f(text)
            return text
        return xf_compose

    def xfunc_add_leader(self, leader):
        """Returns a transform that adds a leader to every line."""
        def xf_add_leader(text):
            text = re.sub(r"(?ms)^", leader, text)  # add leader
            return re.sub(r"(?ms)\s+$", "", text)  # remove trailing spaces
        return xf_add_leader

    def xfunc_escape_character(self, character, replacement):
        def xf_escape_character(text):
            return text.replace(character, replacement)
        return xf_escape_character

    def xfunc_sed_lines_to_args(self):
        """Escape single shell quotes and make every line into a -e argument."""
        def xf_sed_lines_to_args(text):
            return "\n".join("-e '{0}'".format(x.replace("'", """'"'"'"""))
                             for x in text.split("\n")
                             if x and not x.startswith("#"))
        return xf_sed_lines_to_args

    def _var_replace_func(self, variables=None):
        """Returns template substitution function for re.sub.

        Lookups are done in the following order:

            local variables argument (above)
            current namespace (self.__dict__)
            defaults (self._defaults)

        Args:
            variables - overrides all other settings.

        Returns:
            function suitable for use with re.sub as a replacement function
        """
        # Group 1: the context of the replacement
        # Group 2: possibly trailing spaces + newline

        # If the result of the eval is None, we eat the trailing spaces and
        # newline.  Otherwise we preserve them.

        # Also of note is the fact that we eliminate ^\s*# from the beginning
        # of every line, so that we can have these constructs be pure comments.

        # remove leading line comments
        if variables is None:
            variables = {}
        def var_replace(match):
            eval_text = self._tmpl_comment_re.sub("", match.group(1))
            # Handle defaults properly (set to defaults, then clobber with
            # other stuff).
            vardict = self._defaults.copy()
            for n in self.__class__.__dict__:
                if n.startswith("TPL_"):
                    vardict[n[4:]] = getattr(self, n)
            vardict.update(variables)
            # Do the expansion with eval
            result = eval(eval_text, globals(), vardict)
            # Determine whether to eat the trailing spaces or not.
            if result is not None:
                return "{0}{1}".format(result, match.group(2))
            else:
                return result
        return var_replace

    def expand_vars(self, text, variables=None):
        """Expands all template parameters in the given text."""
        return self._tmpl_re.sub(self._var_replace_func(variables), text)

    def expand_file(self, fname, variables=None,
                    transform_after=lambda x:x,
                    transform_before=lambda x:x):
        with open(fname) as f:
            return transform_after(
                self.expand_vars(transform_before(f.read()), variables))

# vim: et sts=4 sw=4
