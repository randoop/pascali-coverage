# Pascali-coverage computations

This is the initial state of the tools for evaluating Randoop test coverage over
the Pascali corpus.

(these instructions were hastily written and may not be perfect)

## Setup

This is the directory structure that I use:
```
.
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

To get to something similar
1. clone this repository,
2. cd into the `pascali-coverage` directory
3. clone the `integration-test2` respository
4. run
```
mkdir -p evaluation/coverage
mkdir -p evaluation/logs
mkdir libs
mkdir log
```
5. cd into `integration-test2` and run `python fetch.py`
6. retrieve `jacocoagent.jar` from the interweb and add it to `pascali-coverage/libs`
7. cd into `extractcoverage` and run `./gradlew assemble`
8. you may want to update `extractcoverage/libs/plume.jar`

The Pascali fetch script will download the version of Randoop that is currently used in
Pascali.
If you want to use a Randoop that is different than the one in `integration-test2`,
replace `integration-test2/libs/randoop.jar` with a symbolic link to the version
you want to use.
(Note: this link should be checked after any time you pull integration-test2 and
rerun the fetch script.)

## Running

Before you attempt to run the scripts, make sure you have run the
`integration-test2/fetch.py` script, and that
`integration-test2/libs/randoop.jar` points to the version of Randoop that you
wish to use.
Then first run the `run_dyntrace.sh` script, which will use Randoop to generate
tests in the `integration-test2/corpus` directory.
Afterward, run the `coverage.sh` script, which will run the generated tests and
use the `extractcoverage` program to pull all of the coverage information into
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

The `run_dyntrace` script writes logs into `pascali-coverage/log` and the `coverage` script writes a single log as `pascali-coverage/evaluation/logs/coverage-log.txt`.

## Updating the spreadsheet

To update the
[MUSE Pascali UW Randoop metrics spreadsheet](https://docs.google.com/spreadsheets/d/1SOh1EtNzQsSsTyFwOmIDMHK_HziKncqirLuQDoH7yEs/edit#gid=1134337280)
I usually rename the `report.csv` file to include the date, say to `report-030617.csv`, and then on Google Sheets do the following steps:
1. Open the file picker (the "folder" icon on the right) and upload the report file.
2. Open the sheet for the report, select the cells with content, choose `Data->Sort range...`, click the `Data has header row` box so that the `sort by` dropbox says `project`. Click `Add another sort column` and a new dropbox with `case` should appear. Now click `Sort`.
3. In the sorted table, select and copy the last four columns ("covered lines" through "total methods").
4. Navigate to the [MUSE Pascali UW Randoop metrics spreadsheet](https://docs.google.com/spreadsheets/d/1SOh1EtNzQsSsTyFwOmIDMHK_HziKncqirLuQDoH7yEs/edit#gid=1134337280)
5. Scroll horizontally to the rightmost column. Select the last column and choose `Insert->Column right`.
Click in the top cell in the new column and paste the new contents.
6. Scroll to the bottom, copy the 3 by 4 block of cells with the formulas for the Sum, Coverage, and Package Count from the previous set of results. The paste these into the corresponding cells in the new columns.
7. In the top row of the new columns, enter the date, the Randoop version (which may be a working version), and information about the timelimit and outputlimit used in dyntrace (currently `timelimit=60` and `outputlimit=4000`)
8. Add or fix any  boundary lines affected by the insertion.




## Caveat

Nothing in the repository currently counts the number of generated tests.
