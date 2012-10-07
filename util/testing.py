"""Module containing useful test stuff."""

class RunGoldenTest(object):
  """Runs golden file tests in a given directory.

  Looks for files called golden.* and parses the filename to determine what
  should be run and what output it should generate.
  """
  def __init__(self, testdir):
    self.testdir = testdir
