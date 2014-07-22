#!/bin/bash
cd /joe/Documents/Programs/Thor/trunk
nohup nice -10 \matlab -nodisplay -nodesktop -nosplash < ./+Sims/+Param/second.m &> ./+Sims/+Param/second.log &
