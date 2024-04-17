#!/bin/bash

####################################################################
# This program makes README.txt and README.md files from Perl POD.
####################################################################

if [ "$1" == "" ]; then
  echo "You must specify the foo.pl/foo.pm file to use."
  exit
fi

#perldoc -t -T "$1" | col -bx  > README
#perldoc -otext -T "$1" | col -bx  > README

# https://www.commandlinefu.com/commands/view/24263/dump-man-page-as-clean-text
# The sed to remove three leading spaces here is needed to make this plain
# text ASCII dump align with the output of perldoc.
perldoc -oman  "$1" | col -bx | sed -e 's/^   //' > README.txt.tmp
# Strip off the header lines
tac README.txt.tmp | sed '/^NAME/q' | tac > README.txt
# Remove the temp file
rm -f README.txt.tmp

perl /usr/bin/pod2markdown "$1" > README.md


