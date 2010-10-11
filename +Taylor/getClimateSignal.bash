#!/bin/bash
cd /joe/Documents/Programing/Programs/Thor/trunk
nohup nice -10 \matlab -nodisplay -nodesktop -nosplash < ./+Taylor/getClimateSignal.m &> ./+Taylor/getClimateSignal.log &
