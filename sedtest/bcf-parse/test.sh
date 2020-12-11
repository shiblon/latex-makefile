#!/bin/bash

cd "$(dirname "$0")" 2>/dev/null
testdir="$PWD"
cd ../../ 2>/dev/null

if ./run_sed get-bcf-bibs.sed < "$testdir/main.bcf" | diff "$testdir/golden.run_sed__get-bcf-bibs__main.bcf" -; then
  echo "PASS"
else
  echo "FAIL"
fi
