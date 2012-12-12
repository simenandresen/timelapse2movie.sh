#!/bin/bash

#-------------------------------------------
#	Timelapse2movie
#	make a movie out of a series of photos
#	by Simen Andresen
#-------------------------------------------
#
# ARGUMENTS:
# 	pic_format : jpg, png etc
# 
# DEPENDENCIES : 
#	mencoder
# 	ffmpeg

fps=25
pic_format=$1
pic_files=$(ls *.$pic_format x) 
number_of_files=$(ls *.$pic_format | wc -l)
echo "Converting $number_of_files pictures to movie"


if [ ! -d timelapse_build ]; then
	mkdir timelapse_build
fi

# CHECK HOW MANY DIGITS USED FOR ZERO PADDING
if [ $number_of_files -lt 10  ]; then
	n_digits=1
elif [ $number_of_files -lt 100 ]; then
	n_digits=2
elif [ $number_of_files -lt 1000 ]; then
	n_digits=3
elif [ $number_of_files -lt 10000 ]; then
	n_digits=4
elif [ $number_of_files -lt 100000 ]; then
	n_digits=5
elif [ $number_of_files -lt 1000000 ]; then
	n_digits=6
elif [ $number_of_files -lt 10000000 ]; then
	n_digits=7
else 
	echo "Two many files error"
fi

# MAKE COPIES WITH ZEROPADDED NAMES
count=0
for file in $pic_files
do
	fname=`printf "pic%0${n_digits}d" $count`
	cp $file ./timelapse_build/${fname}.jpg
	count=$((count +1 ))
done	
cd timelapse_build


# GENERATE MOVIE

#ffmpeg ./timelapse_build/pic%${n_digits}d.${pic_format} -vcodec mpeg4 test.avi
mencoder "mf://*.jpg" -mf fps=$fps -o movie.mpeg -ovc  lavc -lavcopts vcodec=mjpeg
# make a copy in avi format
ffmpeg -i movie.mpeg -qmax 10 avmov.avi


# CLEAN UP
rm pic*.jpg

