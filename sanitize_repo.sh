#!/usr/bin/env bash

# Replace all instances of optoro_skel with the directory name
# This assumes the current directory is named something like optoro_*
# as per cookbook convention.
DIRNAME=${PWD##*/}
for i in $(grep -rl optoro_skel | grep -v .git | grep -v ${0##*/} ); do
  echo "Replacing optoro_skel in ${i}"
  sed -i s/optoro_skel/$DIRNAME/g $i
done

# Remove this file from the new repo
git rm -f $0
