#!/usr/bin/python

"""Generate .log files for all .tex files in all test directories."""

import os
import os.path
import subprocess
import util.ensure_version

commands = "latex", "pdflatex", "xelatex"

rm_ext = "dvi", "pdf", "aux"

for dirpath, dirnames, filenames in os.walk("test"):
  for fname in filenames:
    name, ext = os.path.splitext(fname)
    if ext != ".tex":
      continue

    print("Building {0}".format(os.path.join(dirpath, name)))

    for command in commands:
      ret = subprocess.call(args=(command, "-interaction=batchmode", name),
                            cwd=dirpath)
      subprocess.call(args=("mv", "-f", "{0}.log".format(name),
                            "log.{0}--{1}".format(name, command)),
                      cwd=dirpath)

      rm_files = ["{0}.{1}".format(name, x) for x in rm_ext]
      rm_args = ["rm", "-f"]
      subprocess.call(args=(rm_args + rm_files), cwd=dirpath)
