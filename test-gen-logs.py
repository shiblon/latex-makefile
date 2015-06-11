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

if not os.path.isdir(initial_dir):
  print >>sys.stderr, "Directory %s does not exist - cannot generate logs" % initial_dir
  sys.exit(1)

print >>sys.stderr, "Generating logs in %s" % initial_dir

last_dir = None

for dirpath, dirnames, filenames in os.walk(initial_dir):
  if os.path.basename(dirpath) == "texmf":
    continue

  env = os.environ.copy()
  if "texmf" in dirnames:
    env["TEXINPUTS"] = "./texmf::"

  for fname in filenames:
    name, ext = os.path.splitext(fname)
    if ext != ".tex":
      continue

    print("Building {0}".format(os.path.join(dirpath, name)))

    for command in commands:
      texinputs = env.get("TEXINPUTS")
      if texinputs:
        print "TEXINPUTS=%s" % texinputs
      print "Running %r in %r" % (command, dirpath)
      ret = subprocess.call(args=(command,
                                  "-interaction=batchmode",
                                  "-file-line-error",
                                  "-recorder",
                                  name),
                            cwd=dirpath,
                            env=env)
      subprocess.call(args=("mv", "-f", "{0}.log".format(name),
                            "log.{0}--{1}".format(name, command)),
                      cwd=dirpath)

      subprocess.call(args=("mv", "-f", "{0}.fls".format(name),
                            "fls.{0}--{1}".format(name, command)),
                      cwd=dirpath)

      rm_files = ["{0}.{1}".format(name, x) for x in rm_ext]
      rm_args = ["rm", "-f"]
      subprocess.call(args=(rm_args + rm_files), cwd=dirpath)
