#!/bin/bash
CORPUSDIR=integration-test2/corpus
for dirname in $CORPUSDIR/*; do
  [ -e "$dirname" ] || continue

  basename=`basename $dirname`
  log="logs/$basename-log.txt"

  if [[ -d "$dirname" && ! -L "$dirname" ]]; then
    if [[ ! "$basename" =~ ^Sort[0-9]+ ]]; then
      echo "running $basename"
      python integration-test2/run_randoop.py "$basename" &> "$log"
    fi
  fi
done
