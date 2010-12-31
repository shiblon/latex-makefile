#!/usr/bin/python

"""Generate golden files for log.* in a test directory."""

import os
import os.path
import subprocess
import sys
import util.ensure_version

log_sed_scripts = ("color-tex.sed",
                   "colorize-latex-errors.sed",
                   "get-graphics.sed",
                   "get-log-index.sed",
                   "get-missing-inputs.sed")

if len(sys.argv) == 2:
  initial_dir = os.path.join("test", sys.argv[1])
else:
  initial_dir = "test"

for dirpath, dirnames, filenames in os.walk(initial_dir):
  for in_name in filenames:
    if not in_name.startswith("log."):
      continue

    print("Generating golden files for {0}".format(in_name))

    for scriptname in log_sed_scripts:
      # remove the .sed extension if there is one
      if scriptname.endswith(".sed"):
        scriptname = scriptname[:-4]
      out_name = "golden.run_sed__{script}__{log}".format(script=scriptname,
                                                          log=in_name)
      out_path = os.path.join(dirpath, out_name)
      in_path = os.path.join(dirpath, in_name)
      with open(out_path, "wb") as f:
        args=("./run_sed", "{0}.sed".format(scriptname), in_path)
        print(args, out_path)
        ret = subprocess.call(args, stdout=f)
      if ret != 0:
        print("FAILED: removing {0}".format(out_path))
        os.unlink(out_path)
