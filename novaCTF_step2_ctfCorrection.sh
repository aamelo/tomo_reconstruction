for i in $1; do for j in $(seq 0 $2);
do

cd bits_$(printf %03d $i);

stack=*.st
tilt=*.tlt
defocus_file=defNOVACTF_input_$(printf %03d $i).txt_$j
output=bits_$(printf %03d $i)_corrected_stack.st_$j;

/./frost/hotbox/melo/programs/novaCTF/novaCTF -Algorithm ctfCorrection -InputProjections $stack -OutputFile $output -DefocusFile $defocus_file -TILTFILE $tilt  -CorrectionType phaseflip -DefocusFileFormat ctffind4 -CorrectAstigmatism 0 -PixelSize 0.552 -AmplitudeContrast 0.07 -Cs 2.7 -Volt 300
cd ..;
done;
done
