#!/bin/bash
CORPUSDIR=integration-test2/corpus
DLJC_LOG=integration-test2/dljc.log
for dirname in $CORPUSDIR/*; do
  [ -d "$dirname" ] || continue

  basename=`basename $dirname`
  log="logs/$basename-log.txt"

  if [[ -d "$dirname" && ! -L "$dirname" ]]; then
    if grep -q -x "$basename" tests-to-skip ; then
      echo "skipping $basename"
    else
      echo "running $basename"
      if python3 integration-test2/run_randoop.py "$basename" &> "$log" ; then
	:
      else
        echo "Command failed: python3 integration-test2/run_randoop.py \"$basename\" &> \"$log\""
	echo "contents of $log:"
	cat "$log"
	echo "end of contents of $log."
	echo "contents of $DLJC_LOG"
	cat "$DLJC_LOG"
	echo "end of contents of $DLJC_LOG."
	exit 2
      fi
    fi
  fi
done
