#!/bin/sh

# Fail if any command fails
set -e
# Show commands as they are executed
set -x

mkdir -p evaluation/coverage
mkdir -p evaluation/logs
mkdir logs

git clone https://github.com/aas-integration/integration-test2.git
# or if you wish to use ssh:
# git clone git@github.com:aas-integration/integration-test2.git

(cd integration-test2 && git pull && ./fetch_dependencies.sh && ./fetch_corpus.py)
(cd extractcoverage && ./gradlew assemble)
