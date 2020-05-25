for i in $(seq $1 $2);
do
{
if [ ! -d bits_$(printf %03d $i) ]; then
    echo "Folder not found"
    continue
fi
}
cd bits_$(printf %03d $i);

#TOMOGRAM RECONSTRUCTION
tilt -InputProjections bits_$(printf %03d $i).ali -OutputFile /scratch/melo/tomos/bits_$(printf %03d $i)_full.rec -IMAGEBINNED 1 -TILTFILE bits_$(printf %03d $i).tlt -THICKNESS 2400 -RADIAL 0.15,0.035 -FalloffIsTrueSigma 1 -XAXISTILT 0.0 -SCALE 0.0,0.05 -PERPENDICULAR -MODE 2 -FULLIMAGE 4092,5760 -SUBSETSTART 0,0 -AdjustOrigin -LOCALFILE bits_$(printf %03d $i)local.xf -ActionIfGPUFails 1,2 -XTILTFILE bits_$(printf %03d $i).xtilt -OFFSET 0.0,0.0 -SHIFT 0.0,0.0 -UseGPU 0 -FakeSIRTiterations 200;

#BIN VOLUME
binvol -b 4 /scratch/melo/tomos/bits_$(printf %03d $i)_full.rec bits_$(printf %03d $i)_bin4.rec;

#ROTATE AROUND X-AXIS -90 degrees
clip rotx bits_$(printf %03d $i)_bin4.rec bits_$(printf %03d $i)_bin4_sirtlike_ite200_radial0150_final.rec;

#REMOVE UNBINNED TOMO and TOMO before rotation
rm /scratch/melo/tomos/bits_$(printf %03d $i)_full.rec bits_$(printf %03d $i)_bin4.rec;
cd ..;
done
