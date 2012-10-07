#!/usr/bin/env python

"""
Check whether make invoked the right commands for all test-cases in
the directory test/build-sequence/

The expected sequence of commands for each given test-case is written
in the first line of the respective .tex file.
"""

import os
import os.path
import subprocess
import sys
import string
import util.ensure_version
import re

# Colorize terminal output
HEADER = '\033[95m'
OKBLUE = '\033[94m'
OKGREEN = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
ENDC = '\033[0m'


def run_make(makefile, directory, target):
  """Runs make with the given target in the given directory

  Note that we set WRITE_TRANSCRIPT to true, and we supress the output.

  """
  subprocess.call(args = ("make",
    "--makefile=" + makefile,
    "WRITE_TRANSCRIPT=true",
    target),
    stderr = subprocess.STDOUT,
    stdout = subprocess.PIPE,
    cwd = directory)


def read_transcript(path):
  """Returns two lists containing the "transcript" and "justification"

  "transcript" is a list of commands that were executed by make, and
  "justification" is a list of reasons for why each command was executed

  The "path" argument is a file .transcript.make that contains a list
  of executed commands together with the reason given. Each line of
  the file is assumed to have the following format:
  Running command (reason)

  """
  # Read the .transcript.make file
  with open(path) as myfile:
    lines = myfile.readlines()
  transcript = []
  justification = []
  # Now extract the information we need
  for line in lines:
    matchObj = re.match("Running (.*) \((.*)\)", line)
    transcript.append(matchObj.group(1))
    justification.append(matchObj.group(2))
  return transcript, justification


def read_expected_transcript(path):
  """Returns a list containing the "expected transcript"

  "path" is expected to be a file whose first line contains the
  expected transcript in the following format:
  % Expected transcript: latex bibtex latex latex

  """
  with open(path) as myfile:
    expected_str = myfile.next()
  # Strip the string to the right format and convert it to a list
  expected_str = string.replace(expected_str, "% Expected transcript: ", "")
  expected_str = string.strip(expected_str)
  expected_transcript = expected_str.split()
  return expected_transcript

def main():
  current_directory = os.getcwd()
  makefile = os.path.join(current_directory, "Makefile")
  if not os.path.exists(makefile):
    print FAIL + "Failed.",
    print ENDC + " You need to ./build the Makefile before running this test!"
    quit(1)


  if len(sys.argv) == 2:
    initial_dir = os.path.join("test", "transcript", sys.argv[1])
  else:
    initial_dir = os.path.join("test", "transcript")

  total_tests = 0
  passed_tests = 0

  print WARNING + "Testing transcripts... \n"

  for dirpath, dirnames, filenames in os.walk(initial_dir):
    for fname in filenames:
      name, ext = os.path.splitext(fname)
      if ext != ".tex":
        continue

      total_tests += 1
      print ENDC + os.path.join(dirpath, fname) + "...",

      # make clean
      run_make(makefile, dirpath, "clean")

      # make testfile
      run_make(makefile, dirpath, name)

      transcript_filename = os.path.join(dirpath, name + ".transcript.make")

      if(os.path.exists(transcript_filename)):
        actual, justification = read_transcript(transcript_filename)
      else:
        actual, justification = [], []

      expected = read_expected_transcript(os.path.join(dirpath, fname))

      # Delete the transcript file and run make a second time
      # to see whether fixed-point was reached
      os.remove(transcript_filename)
      run_make(makefile, dirpath, name)

      second_success = 0
      if not os.path.exists(transcript_filename):
        second_success = 1
      else:
        actual2, justification2 = read_transcript(transcript_filename)

      if actual == expected and second_success:
        passed_tests += 1
        print OKGREEN + " Passed."
      else:
        print FAIL + " Failed."
        if actual == expected:
          print ENDC + "  First 'make' was ok, but the second 'make' rebuilt stuff"
          print ENDC + "  Transcript of 1st 'make': " + OKBLUE + str(expected)
          print ENDC + "  Transcript of 2nd 'make': " + OKBLUE + str(actual2)
          for i, (act, just) in enumerate(zip(actual2, justification2)):
            print "%s   %d: Ran %s%s%s because: %s" \
            % (ENDC, i+1, OKBLUE, act, ENDC, just)
        else:
          print "%s  Expected transcript: %s%s" % (ENDC, OKBLUE, str(expected))
          print "%s  Observed transcript: %s%s" % (ENDC, OKBLUE, str(actual))
          for i, (act, just) in enumerate(zip(actual, justification)):
            print "%s   %d: Ran %s%s%s because: %s" \
            % (ENDC, i+1, OKBLUE, act, ENDC, just)

      print ""

      # make clean
      run_make(makefile, dirpath, "clean")

  print WARNING + "Result: ",
  print OKGREEN + str(passed_tests) + " passed   ",
  print FAIL + str(total_tests-passed_tests) + " failed"


if __name__ == '__main__':
  main()
