#!/bin/bash

# Move into THOR
cd "$2"/Documents/Programs/Thor/trunk

# Make the results directory
mkdir ./+Taylor/Results/"$1"

# mv the last runs results and controle file into results directory given by $1
echo ""
echo "Coppying last run results and control file into $1"
mv ./+Taylor/evolveResults.mat +Taylor/Results/"$1"/evolveResults.mat
cp ./+Taylor/evolve.m +Taylor/Results/"$1"/evolve.m
mv ./+Taylor/evolve.log +Taylor/Results/"$1"/evolve.log

# cp the last runs saved steps into results directory given by $1
echo ""
echo "Coppying the saved steps into $1"
mv ./+Thor/CrysDists/* +Taylor/Results/"$1"/

# clean up results directory
rm ./+Taylor/Results/"$1"/*/*.mat

# move saved steps from Run#/SavedSteps/* ro Run#/*
echo ""
echo "Moving saved steps to the run directory"
for f in ./+Taylor/Results/"$1"/*
do
	if [ -d $f ]; then
		echo ""
		echo "Processing $f";
		mv "$f"/SavedSteps/*.mat "$f"/;
	fi
done
rmdir ./+Taylor/Results/"$1"/*/SavedSteps
