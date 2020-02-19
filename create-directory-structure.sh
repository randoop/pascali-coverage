#!/bin/sh

# Fail if any command fails
set -e
# Show commands as they are executed
set -x

# TODO: Add this to the base image either via apt-get or pip.
apt-get -y install python-subprocess32

# fetch_dependencies.sh builds Daikon, which needs JAVA_HOME to be set.
JAVA_HOME_DEFAULT=${JAVA_HOME:-$(dirname $(dirname $(dirname $(readlink -f $(/usr/bin/which java)))))}
export JAVA_HOME=${JAVA_HOME:-$JAVA_HOME_DEFAULT}

mkdir -p evaluation/coverage
mkdir -p evaluation/logs
mkdir logs

# git clone https://github.com/aas-integration/integration-test2.git
git clone https://github.com/mernst/integration-test2.git --branch debugging

(cd integration-test2 && git pull && ./fetch_dependencies.sh && ./fetch_corpus.py)
(cd extractcoverage && ./gradlew assemble)
