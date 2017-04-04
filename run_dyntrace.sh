#!/bin/bash
python integration-test2/run_randoop.py boofcv &> log/boofcv-log.txt
python integration-test2/run_randoop.py catalano &> log/catalano-log.txt
python integration-test2/run_randoop.py commonsmath &> log/commonsmath-log.txt
python integration-test2/run_randoop.py dyn4j &> log/dyn4j-log.txt
python integration-test2/run_randoop.py ejml &> log/ejml-log.txt
python integration-test2/run_randoop.py facedetection1 &> log/facedetection1-log.txt
python integration-test2/run_randoop.py facer &> log/facer-log.txt
python integration-test2/run_randoop.py imagej &> log/imagej-log.txt
python integration-test2/run_randoop.py imglib2 &> log/imglib2-log.txt
python integration-test2/run_randoop.py imgscalr &> log/imgscalr-log.txt
python integration-test2/run_randoop.py jbox2d &> log/jbox2d-log.txt
python integration-test2/run_randoop.py jcodec &> log/jcodec-log.txt
python integration-test2/run_randoop.py jmonkeyengine &> log/jmonkeyengine-log.txt
python integration-test2/run_randoop.py jreactphysics3d &> log/jreactphysics3d-log.txt
python integration-test2/run_randoop.py ojalgo &> log/ojalgo-log.txt
python integration-test2/run_randoop.py react &> log/react-log.txt
python integration-test2/run_randoop.py thumbnailinator &> log/thumbnailinator-log.txt
