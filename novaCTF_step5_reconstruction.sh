for i in $1; 

do
cd bits_$(printf %03d $i);

tilt=*.tlt
defocus_file=defNOVACTF_input_$(printf %03d $i).txt
stack=bits_$(printf %03d $i)_filtered_stack.st_$j;
output=tomogram_bits_$(printf %03d $i)_ctfcorrected.rec;

/./frost/hotbox/melo/programs/novaCTF/novaCTF -Algorithm 3dctf  -InputProjections $stack -OutputFile $output -TILTFILE $tilt -THICKNESS 600 -FULLIMAGE 1023,1440 -SHIFT 0.0,0.0 -PixelSize 0.552 -DefocusStep 15

cd ..;
done;
