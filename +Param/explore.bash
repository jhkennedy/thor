#!/bin/bash
cd /joe/Documents/Programs/Thor/trunk
nohup nice -10 \matlab -nodisplay -nodesktop -nosplash < ./+Param/explore.m &> ./+Param/explore.log &
