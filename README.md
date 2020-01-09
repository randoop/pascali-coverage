# Pascali-coverage computations

This repository contains the tools for evaluating Randoop test coverage over
the Pascali corpus.

Notes:
1. The default Pascali scripts run Randoop without the replacecall agent. This needs to be updated.
2. If you find anything wrong with these instructions, please open an issue or a pull request.

## Setup

This is the directory structure used for testing:
```
pascali-coverage
├── count-klocs.pl
├── coverage.sh
├── evaluation
│   ├── coverage
│   └── logs
├── extractcoverage
├── get_klocs.sh
├── integration-test2
├── libs
├── logs
├── README.md
├── run_dyntrace.sh
├── show-coverage.pl
└── tests-to-skip
```
It is somewhat historical and could be cleaned up.

To create this directory structure:
```
git clone git@gitlab.cs.washington.edu:randoop/pascali-coverage.git
cd pascali-coverage
./create-directory-structure.sh
```


## Controlling which Randoop is used

By default the `integration-test2` scripts will run the latest release of
Randoop.  To use a different Randoop, run the `replace-randoop-jars.sh`
from the Randoop whose jar files you wish to use.  For example:

```
cd integration-test2/libs && $HOME/randoop/scripts/replace-randoop-jars.sh
```

(Note: you might need to re-run `replace-randoop.sh` anytime you pull
integration-test2 and rerun the `fetch.py` script.)


## Setting up the Pascali test suites

Before you attempt to run the scripts, make sure you have run the
`integration-test2/fetch.py` script, and that
`integration-test2/libs/randoop.jar` points to the version of Randoop that you
wish to use.
(`./create-directory-structure.sh` did these things.)


## Running randoop to generate the coverage test cases.

The next step is to run Randoop over the test suites to generate a set of test
cases; then pass them to the java compiler.  This is done by running the
run_dyntrace.sh script:
```
./run_dyntrace.sh
```
The `run_dyntrace.sh` script uses Randoop to generate
tests in directories such as
`integration-test2/corpus/<program-name>/dljc-out/test-{src,classes}[0-9]+`.
It writes logs into `pascali-coverage/logs` and runs for about 4 hours.

It is recommended that you run the scripts on a server without connecting your windowing system.
The library code in the corpus makes many attempts to open a window, but the replacecall
agent should prevent the windows from being created.  However, depending on your OS/windowing
system, the process may steal window focus, which can be disruptive to doing actual work.
If you get actual windows or dialogs, please report an issue to Randoop.


## Running the Randoop-generated tests and collecting the coverage data.

The next step is to execute the Randoop generated tests under the control of the
JaCoCo coverage tool to collect the coverage data.  This is done by running the
coverage script:
```
(cd integration-test2/corpus/catalano && ln -s Catalano.Image/dljc-out dljc-out)
./coverage.sh
```
The `ln` is necessary as the catalano suite puts its generated files in a non-standard subdirectory.
The `coverage.sh` script runs the generated tests.  It completes in about 5 minutes.
Again, it will pop up windows; you should wait for them to close by themselves.
The `coverage.sh` script uses the `extractcoverage` program to pull all of the coverage
information into `evaluation/coverage`.
The files written into `evaluation/coverage` include the aggregate `report.csv` (which is what
goes into the Google docs spreadsheet), and subdirectories such as

```
evaluation/coverage/thumbnailinator/
└── test-classes1
    ├── jacoco.exec
    └── report.csv
```    

which has the JaCoCo exec file, and a csv file with the extracted coverage per method.
If a failure occurs during the coverage script run, at least one of these files may be missing.

The `coverage` script writes a single log as `pascali-coverage/evaluation/logs/coverage-log.txt`.


## Displaying the coverage data

The raw coverage data will be found at evaluation/coverage/report-<date>.csv.
You may display the coverage results by running the perl script:
```
./show-coverage.pl
```
This script will accept an optional argument of an alternative file location.
Invoke the script with -help for a full list of options.


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
