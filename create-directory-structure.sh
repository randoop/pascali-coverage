#!/bin/sh

# Fail if any command fails
set -e
# Show commands as they are executed
set -x

# fetch_dependencies.sh builds Daikon, which needs JAVA_HOME to be set.
JAVA_HOME_DEFAULT=${JAVA_HOME:-$(dirname $(dirname $(dirname $(readlink -f $(/usr/bin/which java)))))}
export JAVA_HOME=${JAVA_HOME:-$JAVA_HOME_DEFAULT}

mkdir -p evaluation/coverage
mkdir -p evaluation/logs
mkdir logs

## For testing
## git clone https://github.com/aas-integration/integration-test2.git
git clone https://github.com/mernst/integration-test2.git --branch debug-fetch-dependencies

# or if you wish to use ssh:
# git clone git@github.com:aas-integration/integration-test2.git

(cd integration-test2 && git pull && ./fetch_dependencies.sh && ./fetch_corpus.py)
(cd extractcoverage && ./gradlew assemble)
