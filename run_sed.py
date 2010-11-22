#!/usr/bin/env python2.6

"""Run sed from a script, but do it as though it is being used in a Makefile.

The difference between this and its use in the makefile itself is that here we
don't escape $ to $$.
"""

from __future__ import print_function, division

from pprint import pprint
import template
import os
import sys

def main(argv):
  ns = template.Template()

  sed_args = ["sed"]
  text = ns.expand_file(argv[1],
                        transform_after=ns.xfunc_sed_lines_to_args())
  sed_args.extend(text.split('\n'))
  sed_args.extend(argv[2:])

  pprint(sed_args, stream=sys.stderr)

  with os.popen(" ".join(sed_args)) as f:
    print(f.read())

if __name__ == '__main__':
  main(sys.argv)
