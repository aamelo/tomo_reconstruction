for i in $1
do
ls *.txt | awk -F '_' '{print $1,$2,$3,$4,$5,$6,$7}' | sort -n -k 3 | awk 'FNR==6 {print FILENAME, $0}' *ali_DW.txt | sort -g -t "_" -k 3 >defocus_value_$i.txt
done
