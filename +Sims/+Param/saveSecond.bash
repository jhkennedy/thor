#!/bin/bash

# Move into THOR
cd "$2"/Documents/Programs/Thor/trunk

# Make the results directory
mkdir ./+Sims/+Param/Results/"$1"

# move the last runs results and controle file into results directory given by $1
echo ""
echo "Coppying last run results and control file into $1"
mv ./+Sims/+Param/secondResults.mat ./+Sims/+Param/Results/"$1"/secondResults.mat
cp ./+Sims/+Param/second.m ./+Sims/+Param/Results/"$1"/second.m
mv ./+Sims/+Param/second.log ./+Sims/+Param/Results/"$1"/second.log

# cp the last runs saved steps into results directory given by $1
echo ""
echo "Coppying the saved steps into $1"
mv ./+Thor/CrysDists/* ./+Sims/+Param/Results/"$1"/

# clean up results directory
rm ./+Sims/+Param/Results/"$1"/*/*.mat

# move saved steps from Run#/SavedSteps/* ro Run#/*
echo ""
echo "Moving saved steps to the run directory"
for f in ./+Sims/+Param/Results/"$1"/*
do
	if [ -d $f ]; then
		echo ""
		echo "Processing $f";
		mv "$f"/SavedSteps/*.mat "$f"/;
	fi
done
rmdir ./+Sims/+Param/Results/"$1"/*/SavedSteps
