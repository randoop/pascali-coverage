#!/bin/bash
python integration-test2/run_dyntrace.py boofcv &> log/boofcv-log.txt
python integration-test2/run_dyntrace.py catalano &> log/catalano-log.txt
python integration-test2/run_dyntrace.py commonsmath &> log/commonsmath-log.txt
python integration-test2/run_dyntrace.py dyn4j &> log/dyn4j-log.txt
python integration-test2/run_dyntrace.py ejml &> log/ejml-log.txt
python integration-test2/run_dyntrace.py facedetection1 &> log/facedetection1-log.txt
python integration-test2/run_dyntrace.py facer &> log/facer-log.txt
python integration-test2/run_dyntrace.py imagej &> log/imagej-log.txt
python integration-test2/run_dyntrace.py imglib2 &> log/imglib2-log.txt
python integration-test2/run_dyntrace.py imgscalr &> log/imgscalr-log.txt
python integration-test2/run_dyntrace.py jbox2d &> log/jbox2d-log.txt
python integration-test2/run_dyntrace.py jcodec &> log/jcodec-log.txt
python integration-test2/run_dyntrace.py jmonkeyengine &> log/jmonkeyengine-log.txt
python integration-test2/run_dyntrace.py jreactphysics3d &> log/jreactphysics3d-log.txt
python integration-test2/run_dyntrace.py ojalgo &> log/ojalgo-log.txt
python integration-test2/run_dyntrace.py react &> log/react-log.txt
python integration-test2/run_dyntrace.py thumbnailinator &> log/thumbnailinator-log.txt
