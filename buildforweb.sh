#!/bin/bash

files=(\
Makefile \
)

version=`sed -e '
s/^version[[:space:]]*.=[[:space:]]*\\(.*\\)[[:space:]]*$/\\1/p
d' Makefile`

outputfile=latex-makefile-$version.tar.gz

echo Creating $outputfile

tar czf $outputfile ${files[@]}
