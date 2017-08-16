#!/bin/bash
root=`pwd`
tools=$root/libs
evalpath=$root/evaluation
projectpath=$root/integration-test2
projectlibs=$projectpath/libs
classpath=$root/extractcoverage/build/libs/extractcoverage-all.jar
corpuspath=$projectpath/corpus
coveragepath=$evalpath/coverage
logpath=$evalpath/logs
agentpath=$tools/jacocoagent.jar
outputpath=$coveragepath/
junitpath=$projectlibs/junit-4.12.jar
replacecallpath=$projectlibs/replacecall.jar
java -jar $classpath --corpusDirectoryPath $corpuspath --jacocoAgentPath $agentpath --workingDirectoryPath $outputpath --junitPath $junitpath --replacecallAgentPath $replacecallpath &> $logpath/coverage-log.txt
