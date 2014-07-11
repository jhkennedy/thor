#!/bin/bash

# Move into THOR
cd "$2"/Documents/Programs/Thor/trunk

# Make the results directory
mkdir ./+Param/Results/"$1"

# move the last runs results and controle file into results directory given by $1
echo ""
echo "Coppying last run results and control file into $1"
mv ./+Param/secondResults.mat +Param/Results/"$1"/secondResults.mat
cp ./+Param/second.m +Param/Results/"$1"/second.m
mv ./+Param/second.log +Param/Results/"$1"/second.log

# cp the last runs saved steps into results directory given by $1
echo ""
echo "Coppying the saved steps into $1"
mv ./+Thor/CrysDists/* +Param/Results/"$1"/

# clean up results directory
rm ./+Param/Results/"$1"/*/*.mat

# move saved steps from Run#/SavedSteps/* ro Run#/*
echo ""
echo "Moving saved steps to the run directory"
for f in ./+Param/Results/"$1"/*
do
	if [ -d $f ]; then
		echo ""
		echo "Processing $f";
		mv "$f"/SavedSteps/*.mat "$f"/;
	fi
done
rmdir ./+Param/Results/"$1"/*/SavedSteps
