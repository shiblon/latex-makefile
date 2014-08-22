#!/usr/bin/env python

"""Generate .log files for all .tex files in all test directories."""

import os
import os.path
import subprocess
import sys
import util.ensure_version

commands = "latex", "pdflatex", "xelatex"

rm_ext = "dvi", "pdf", "aux", "out"

if len(sys.argv) == 2:
  initial_dir = os.path.join("test", sys.argv[1])
else:
  initial_dir = "test"

for dirpath, dirnames, filenames in os.walk(initial_dir):
  if os.path.basename(dirpath) == "texmf":
    continue

  for fname in filenames:
    name, ext = os.path.splitext(fname)
    if ext != ".tex":
      continue

    print("Building {0}".format(os.path.join(dirpath, name)))

    env = os.environ.copy()
    if "texmf" in dirnames:
      env["TEXINPUTS"] = "%s::" % os.path.join(dirpath, "texmf")

    for command in commands:
      print "Running %r in %r" % (command, dirpath)
      ret = subprocess.call(args=(command,
                                  "-interaction=batchmode",
                                  "-file-line-error",
                                  name),
                            cwd=dirpath,
                            env=env)
      subprocess.call(args=("mv", "-f", "{0}.log".format(name),
                            "log.{0}--{1}".format(name, command)),
                      cwd=dirpath)

      rm_files = ["{0}.{1}".format(name, x) for x in rm_ext]
      rm_args = ["rm", "-f"]
      subprocess.call(args=(rm_args + rm_files), cwd=dirpath)
