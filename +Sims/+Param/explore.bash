#!/bin/bash
cd /joe/Documents/Programs/Thor/trunk
nohup nice -10 \matlab -nodisplay -nodesktop -nosplash < ./+Sims/+Param/explore.m &> ./+Sims/+Param/explore.log &
