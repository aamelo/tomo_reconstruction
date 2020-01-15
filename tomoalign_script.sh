#!/bin/bash


################################################################################################
#  Steps for fitting the gold fiducial into polynomial model and for calculating the tomogram  #
################################################################################################

##  Prefix of the alignment files in ETOMO  ##

echo Which stack?
read input_stack

## Parameters for reconstruction ##

echo Start in Y?
read starty

echo End in Y?
read endy

echo Size in Z-thickness?
read sizez

### STEP 1 ###
### Transform Fiducial File into .ali stack ###
imodtrans -i "$input_stack".ali -2 "$input_stack".tltxf "$input_stack".fid "$input_stack"_ali.fid;

### STEP 2 ###
### Create fiducial file ".fid" into a text file ".txt" to be used on STEP 3 ###
model2point -object -float "$input_stack"_ali.fid "$input_stack"_ali.fid.txt;

### STEP 3 ###
### Fitting fiducial into polynomials assuming sample in THIN ice ###
tomoalign -a "$input_stack".tlt -i "$input_stack"_ali.fid.txt -o "$input_stack"_thin.par -v 2 -t thin > "$input_stack"_thin.log;

### STEP 4 ###
### Calculate tomogram ###
tomorec -a "$input_stack"_thin.par -i "$input_stack".ali -o "$input_stack"_corrected_tomogram.mrc -Y $starty,$endy -z $sizez -w hamming -W 0 -v 2;

### STEP 5 ###
### Flip Y for Z of tomogram generated on STEP 4 ###
clip flipyz "$input_stack"_corrected_tomogram.mrc "$input_stack"_corrected_tomogram_flipped.mrc;
