for i in $1; do for j in $(seq 0 $2);
do
cd bits_$(printf %03d $i);
inputstack=bits_$(printf %03d $i)_corrected_stack_flipped.st_$j
tilt=*.tlt
defocus_file=defNOVACTF_input_$(printf %03d $i).txt_$j
output=bits_$(printf %03d $i)_filtered_stack.st_$j;

/./frost/hotbox/melo/programs/novaCTF/novaCTF -Algorithm filterProjections -InputProjections $inputstack -OutputFile $output -TILTFILE $tilt -StackOrientation xz -RADIAL 0.3,0.05
cd ..;
done;
done
