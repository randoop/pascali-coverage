#!/bin/bash
CORPUSDIR=integration-test2/corpus
for dirname in $CORPUSDIR/*; do
  [ -d "$dirname" ] || continue

  basename=`basename $dirname`
  log="logs/$basename-log.txt"

  if [[ -d "$dirname" && ! -L "$dirname" ]]; then
    if grep -q -x "$basename" tests-to-skip ; then
      echo "skipping $basename"
    else
      echo "running $basename"
      python integration-test2/run_randoop.py "$basename" &> "$log"
    fi
  fi
done
