for i in $1
do
cd bits_$i;

stack=*.st
tilt=*.tlt
defocus_file=*.txt;

/./frost/hotbox/melo/programs/novaCTF/novaCTF -Algorithm defocus -InputProjections $stack -FULLIMAGE 1023,1440 -THICKNESS 600 -TILTFILE $tilt -SHIFT 0.0,0.0 -CorrectionType phaseflip -DefocusFileFormat ctffind4 -CorrectAstigmatism 0 -DefocusFile $defocus_file -PixelSize 0.552 -DefocusStep 15;
cd ..;
done
