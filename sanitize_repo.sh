#!/usr/bin/env bash

# Replace all instances of optoro_skel with the directory name
DIRNAME=${PWD##*/}
echo $DIRNAME
for i in $(grep -rl optoro_skel | grep -v .git | grep -v ${0##*/} ); do
  echo "Replacing optoro_skel in ${i}"
  sed -i s/optoro_skel/$DIRNAME/g $i
done

echo "${0}" >> .gitignore
