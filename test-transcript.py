#!/usr/bin/python

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

'''Colorize terminal output'''
HEADER = '\033[95m'
OKBLUE = '\033[94m'
OKGREEN = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
ENDC = '\033[0m'

current_directory = os.getcwd()
if not os.path.exists(current_directory+"/Makefile"):
  print FAIL+"Failed.",
  print ENDC+" You need to ./build the Makefile before running this test!"
  quit(1)


def run_make (directory, target):
  subprocess.call(args=("make",
                              "--makefile="+current_directory+"/Makefile",
                              "WRITE_TRANSCRIPT=true",
                              target),
                        stderr=subprocess.STDOUT,
                        stdout=subprocess.PIPE,
                        cwd=directory)
  return


if len(sys.argv) == 2:
  initial_dir = os.path.join("test/transcript", sys.argv[1])
else:
  initial_dir = "test/transcript"

total_tests = 0
passed_tests = 0

print WARNING+"Testing transcripts... \n"

'''
  This function reads a file .transcript.make and returns a list of
  commands that have been run, separated by space
'''
def read_transcript (path):
  '''Read the .transcript.make file'''
  with open(path) as myfile:
    lines=myfile.readlines()
  transcript=[]
  justification=[]
  for line in lines:
    matchObj = re.match("Running (.*) \((.*)\)",line)
    transcript.append(matchObj.group(1))
    justification.append(matchObj.group(2))
  return [transcript,justification]

'''
  This function reads the expected transcript from the first line of a .tex file
'''
def read_expected_transcript (path):
  with open(path) as myfile:
    expected_str=myfile.next()
  '''Strip the string to the right format and convert it to a list'''
  expected_str=string.replace(expected_str,"% Expected transcript: ","")
  expected_str=string.strip(expected_str)
  expected_transcript=expected_str.split()
  return expected_transcript

for dirpath, dirnames, filenames in os.walk(initial_dir):
  for fname in filenames:
    name, ext = os.path.splitext(fname)
    if ext != ".tex":
      continue

    total_tests += 1
    print ENDC+dirpath+'/'+fname+"...",

    '''make clean'''
    run_make(dirpath, "clean")

    '''make testfile'''
    run_make(dirpath, name)

    transcript_filename = os.path.join(dirpath,name+".transcript.make")

    if(os.path.exists(transcript_filename)):
      [actual,justification] = read_transcript(transcript_filename)
    else:
      [actual,justification] = [ [], [] ]

    expected = read_expected_transcript(os.path.join(dirpath,fname))

    '''
    Remove transcript and run make a second time to see whether
    fixed-point was reached
    '''
    os.remove(transcript_filename)
    run_make(dirpath, name)

    second_success = 0
    if(not os.path.exists(transcript_filename)):
      second_success = 1
    else:
      [actual2,justification2] = read_transcript(os.path.join(dirpath,name+".transcript.make"))

    if actual == expected and second_success:
      passed_tests += 1
      print OKGREEN + " Passed."
    else:
      print FAIL + " Failed."
      if actual == expected:
        print ENDC + "  First 'make' was ok, but the second 'make' rebuilt stuff"
        print ENDC + "  Transcript of 1st 'make': " + OKBLUE+str(expected)
        print ENDC + "  Transcript of 2nd 'make': " + OKBLUE+str(actual2)
        for i in xrange(len(justification2)):
          print ENDC + "   "+str(i+1)+": Ran",
          print OKBLUE+actual2[i]+ENDC+" because: " + justification2[i]

      else:
        print ENDC + "  Expected transcript: " + OKBLUE+str(expected)
        print ENDC + "  Observed transcript: " + OKBLUE+str(actual)
        for i in xrange(len(justification)):
          print ENDC + "   "+str(i+1)+": Ran",
          print OKBLUE+actual[i]+ENDC+" because: " + justification[i]

    print ""

    '''make clean'''
    run_make(dirpath, "clean")

print WARNING+"Result: ",
print OKGREEN+str(passed_tests)+" passed   ",
print FAIL+str(total_tests-passed_tests)+" failed"
