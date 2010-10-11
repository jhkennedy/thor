#!/bin/bash
# get files names in directory
FILES="hi18Otd.dat"
# loop through each file in the directory
for f in $FILES
do
	# display what file is being processed
	echo "Processing $f"
	# remove all lines in the file that have '999999' in them
	sed '/999999/ d' $f > age.dat
done

#echo "Processing age.dat"
#sed -i '/#/ d' age.dat

