#!/usr/bin/env python2.6

"""Run sed from a script, but do it as though it is being used in a Makefile.

The difference between this and its use in the makefile itself is that here we
don't escape $ to $$.
"""

from __future__ import print_function, division

import os
import sys

from optparse import OptionParser
from util import template

def main(opts, args):
  ns = template.Template()

  sed_args = ["sed"]
  text = ns.expand_file(args[0],
                        transform_after=ns.xfunc_sed_lines_to_args())
  sed_args.extend(text.split('\n'))
  sed_args.extend(args[1:])

  if opts.show_cmd:
    import pprint
    pprint.pprint(sed_args, stream=sys.stderr)

  with os.popen(" ".join(sed_args)) as f:
    print(f.read())

if __name__ == '__main__':
  op = OptionParser()
  op.add_option("-c", "--show_cmd", dest="show_cmd", default=False,
                action="store_true", help="show sed script")

  opts, args = op.parse_args()
  main(opts, args)
