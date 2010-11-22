#!/usr/bin/env python2.6

from __future__ import print_function, division

import sys
import template


def main(argv):
    ns = template.Template()
    print(ns.expand_file(argv[1]))

if __name__ == '__main__':
    main(sys.argv)


# vim: sts=4 sw=4 et
