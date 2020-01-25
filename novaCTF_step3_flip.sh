for i in $1; do for j in $(seq 0 $2);
do

cd bits_$(printf %03d $i);
clip flipyz bits_$(printf %03d $i)_corrected_stack.st_$j bits_$(printf %03d $i)_corrected_stack_flipped.st_$j;
cd ..;

done
done
