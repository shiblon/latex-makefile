from __future__ import print_function
import sys

if sys.version_info < (2, 6) or sys.version_info >= (3,):
  print("You must run this with Python version > 2.6 and < 3.0", file=sys.stderr)
  sys.exit(-1)
