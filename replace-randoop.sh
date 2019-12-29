#!/bin/sh

# Use a different version of Randoop.
# The argument is Randoop's top-level directory.

RANDOOP_DIR=$1

cd integration-test2/libs

# Move aside old versions of files
if [ -f randoop.jar-ORIG ] ; then
  rm -f randoop.jar replacecall.jar
else
  mv -f randoop.jar randoop.jar-ORIG
  mv -f replacecall.jar replacecall.jar-ORIG
fi

# Get the most recent version of each file.
RANDOOP_ALL_JAR=echo $(ls ${RANDOOP_DIR}/build/libs/randoop-all*.jar | tail -n1)
REPLACECALL_JAR=echo $(ls ${RANDOOP_DIR}/build/libs/replacecall*.jar | tail -n1)
COVERED_CLASS_JAR=echo $(ls ${RANDOOP_DIR}/build/libs/covered-class*.jar | tail -n1)

# Install new versions
ln -sf $RANDOOP_ALL_JAR .
ln -sf $REPLACECALL_JAR .
ln -sf $COVERED_CLASS_JAR .

ln -s $(basename -- "$RANDOOP_ALL_JAR") randoop.jar
ln -s $(basename -- "$REPL_ALL_JAR") replacecall.jar
ln -s $(basename -- "$RANDOOP_ALL_JAR") covered-class.jar

cd ../..
