# Pascali-coverage computations

This is the initial state of the tools for evaluating Randoop test coverage over
the Pascali corpus.

Notes:
1. The default Pascali scripts run Randoop without the replacecall agent. This will remain broken until Randoop 4 is released and the Pascali scripts can be updated.
2. If you find anything wrong with these instructions, please modify this document in the repository and submit a pull-request.

## Setup

This is the directory structure that I use:
```
pascali-coverage
├── coverage.sh
├── evaluation
│   ├── coverage
│   └── logs
├── extractcoverage
├── integration-test2
├── libs
├── log
└── run_dyntrace.sh
```
It is somewhat historical and could be cleaned up.

To create this directory structure:
```
git clone git@gitlab.cs.washington.edu:randoop/pascali-coverage.git
cd pascali-coverage
mkdir -p evaluation/coverage
mkdir -p evaluation/logs
mkdir log
mkdir libs
wget http://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/0.7.9/jacoco-0.7.9.zip -O jacoco-0.7.9.zip
unzip -j jacoco-0.7.9.zip lib/jacocoagent.jar -d libs
\rm -f jacoco-0.7.9.zip
git clone git@github.com:aas-integration/integration-test2.git
(cd integration-test2 && python fetch.py)
(cd extractcoverage && ./gradlew assemble)
```

Finally, you may want to update `extractcoverage/libs/plume.jar` with the
[current release](https://github.com/mernst/plume-lib/releases/latest).
```
wget https://github.com/mernst/plume-lib/releases/download/v1.1.2/plume-lib-1.1.2.tar.gz
tar zxvf plume-lib-1.1.2.tar.gz -C libs plume-lib-1.1.2/java/plume.jar
\rm -f plume-lib-1.1.2.tar.gz
mv libs/plume-lib-1.1.2/java/plume.jar extractcoverage/libs/
\rm -rf libs/plume-lib-1.1.2
```

## Controlling which Randoop is used

By default the `integration-test2` scripts will run the Randoop that is downloaded
by the `integration-test2/fetch_dependencies.sh` script.  This is supposed to be
the current release of Randoop. (If it is not, a pull-request with the update needs to be made to the [integration-test2](https://github.com/aas-integration/integration-test2) repo.)

To use a different Randoop than the one used by default in
`integration-test2`, replace `integration-test2/libs/randoop.jar` with a
symbolic link to the version you want to use, probably in
`build/libs/randoop-all-X.X.X.jar` of your clone of Randoop.  Example:
```
mv -f integration-test2/libs/randoop.jar randoop.jar-ORIG
ln -s $HOME/research/testing/randoop/build/libs/randoop-all-3.1.5.jar integration-test2/libs/randoop.jar
mv -f integration-test2/libs/replacecall.jar replacecall.jar-ORIG
ln -s $HOME/research/testing/randoop/build/libs/replacecall-3.1.5.jar integration-test2/libs/replacecall.jar
```
(Note: if you make a change, check this link anytime you pull
integration-test2 and rerun the `fetch.py` script.)


## Running

Before you attempt to run the scripts, make sure you have run the
`integration-test2/fetch.py` script, and that
`integration-test2/libs/randoop.jar` points to the version of Randoop that you
wish to use.

```
sh ./run_dyntrace.sh
ln -s integration-test2/corpus/catalano/Catalano.Image/dljc-out integration-test2/corpus/catalano/dljc-out
sh ./coverage.sh
cd evaluation/coverage
tail -n +2 report*.csv | sort -t , -k1,1 -k2,2n >> report-`date +%Y%m%d`.csv
cd ..
```

The `run_dyntrace.sh` script uses Randoop to generate
tests in directories such as
`integration-test2/corpus/<program-name>/dljc-out/test-{src,classes}[0-9]+`.
The `run_dyntrace` script writes logs into `pascali-coverage/log`.
It runs for about 5 hours.
It is recommended that you run the scripts on a server without connecting your windowing system.

The library code in the corpus makes many attempts to open a window, but the replacecall agent should prevent the windows from being created.
However, depending on your OS/windowing system, the process may steal window focus, which can be disruptive to doing actual work.
If you get actual windows or dialogs, please report an issue to Randoop.

The `coverage.sh` script runs the generated tests.
It completes in about 5 minutes.
Again, it will pop up windows; you should wait for them to close by themselves.
The `coverage.sh` script
uses the `extractcoverage` program to pull all of the coverage information into
`evaluation/coverage`.
The files written into `evaluation/coverage` include the aggregate `report.csv` (which is what goes into the Google docs spreadsheet), and subdirectories such as

```
evaluation/coverage/thumbnailinator/
└── test-classes1
    ├── jacoco.exec
    └── report.csv
```    

which has the JaCoCo exec file, and a csv file with the extracted coverage per method.
If a failure occurs during the coverage script run, at least one of these files may be missing.

The `coverage` script writes a single log as `pascali-coverage/evaluation/logs/coverage-log.txt`.


## Updating the spreadsheet

To update the
[MUSE Pascali UW Randoop metrics spreadsheet](https://docs.google.com/spreadsheets/d/1SOh1EtNzQsSsTyFwOmIDMHK_HziKncqirLuQDoH7yEs/edit#gid=1134337280)
on Google Sheets do the following steps:
1. Do "File >> Import >> Upload >> Select a file from your computer >> `evaluation/coverage/report-20173028.csv` (adjust file name) >> Create new spreadsheet >> open now"
2. Select and copy the last four columns ("covered lines" through "total methods").
3. Navigate to the [MUSE Pascali UW Randoop metrics spreadsheet](https://docs.google.com/spreadsheets/d/1SOh1EtNzQsSsTyFwOmIDMHK_HziKncqirLuQDoH7yEs/edit#gid=1134337280)
4. Add 4 new blank columns at the right.  Scroll horizontally to the rightmost column. Right-click the last column and choose `Insert 1 right`, or select the last column and in the main menu do `Insert->Column right`. Repeat a total of 4 times.
Click in the second cell in the first new column and paste the new contents.
5. In the top row of the new columns, enter the date, the Randoop version (which may be a working version (**TODO: how to determine which information to enter here?**)), and information about the timelimit and outputlimit used in dyntrace, which you can find in the declaration of procedure `generate_tests` in file pascali-coverage/integration-test2/tools/do-like-javac/do_like_javac/tools/dyntrace.py`
6. Scroll to the bottom, copy the 3 by 4 block of cells with the formulas for the Sum, Coverage, and Package Count from the previous set of results. Then paste these into the corresponding cells in the new columns.
7. Add or fix any boundary lines affected by the insertion. (**TODO: how to do this?**)




## Caveat

Nothing in the repository currently counts the number of generated tests.
