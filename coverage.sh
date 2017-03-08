#!/bin/bash
tools=libs
evalpath=evaluation
projectpath=integration-test2
projectlibs=$projectpath/libs
classpath=extractcoverage/build/libs/extractcoverage-all.jar
corpuspath=$projectpath/corpus
coveragepath=$evalpath/coverage
logpath=$evalpath/logs
agentpath=$tools/jacocoagent.jar
outputpath=$coveragepath/
junitpath=$projectlibs/junit-4.12.jar
java -jar $classpath $corpuspath $agentpath $outputpath $junitpath &> $logpath/coverage-log.txt
