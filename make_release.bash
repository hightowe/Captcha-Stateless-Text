#!/bin/bash

##############################################################################################
# A script to make the Captcha-Stateless-Text-x.xx.zip packages to be uploaded to CPAN.
#
# Must be run with the pwd in the location of code (where this script lives).
##############################################################################################

PM_NAME="Captcha-Stateless-Text"
PM_FILE="./lib/Captcha/Stateless/Text.pm"

if [ ! -f "$PM_FILE" ]; then
  echo "Do not see PM_FILE=$PM_FILE"
  exit -1
fi

VER_FROM_PM=`perl -MExtUtils::MakeMaker -le 'print MM->parse_version(shift)' "$PM_FILE"`
VER_FROM_META=`grep '^ version:' META.yml |cut -d: -f2 | sed 's/[^0-9.]//g'`

#echo "$VER_FROM_PM vs $VER_FROM_META"
if [ "$VER_FROM_PM" != "$VER_FROM_META" ]; then
  echo "Mismatch in versions between PM and the META.yml";
  exit -1
fi

grep -q -E "^Version $VER_FROM_PM" Changes
if [ $? != 0 ]; then
  echo "'Version $VER_FROM_PM' missing from Changes"
  exit -1
fi

rm -f ./README.md ./README.txt
./README_make.sh "$PM_FILE"

PM_DIR_NAME="$PM_NAME-$VER_FROM_PM"
mkdir ./"$PM_DIR_NAME"
FILES="MANIFEST Changes Makefile.PL META.yml README.md README.txt"
DIRS="./lib ./t"

# Make the MANIFEST file
echo "$FILES" | xargs -n 1 > ./MANIFEST
find ./lib -type f | sed 's%^./%%' >> ./MANIFEST

grep -E --color=always '^.+[.]swp$' ./MANIFEST
if [ $? == 0 ]; then
  echo -e " ** WARNING: grep found *.swp files in ./MANIFEST\n"
fi

# Now copy the dirs and files
for d in $DIRS; do
  if [ ! -d "$d" ]; then
    echo "Missing DIR=$d!";
    exit -1;
  fi
  cp -r "$d" --target-directory="./$PM_DIR_NAME"
done
for f in $FILES; do
  if [ ! -f "$f" ]; then
    echo "Missing FILE=$f!";
    exit -1;
  fi
  cp "$f" --target-directory="./$PM_DIR_NAME"
done

ZIP_NAME="$PM_DIR_NAME".zip

rm -f "$ZIP_NAME"
zip -9r "$ZIP_NAME" ./"$PM_DIR_NAME"

rm -rf ./"$PM_DIR_NAME"

# We leave README.md because it provides the README on github
rm ./README.txt ./MANIFEST

