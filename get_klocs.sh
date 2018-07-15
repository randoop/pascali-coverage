#!/bin/bash
CORPUSDIR=integration-test2/corpus
for dirname in $CORPUSDIR/*; do
  [ -d "$dirname" ] || continue

  basename=`basename $dirname`
  log="logs/$basename-kloc.txt"

  if [[ -d "$dirname" && ! -L "$dirname" ]]; then
    if grep -q -x "$basename" tests-to-skip ; then
      echo "skipping $basename"
    else
      echo "counting $basename"
#     ./count-klocs.pl "$basename" &> "$log"
      ./count-klocs.pl "$dirname" 
    fi
  fi
done
