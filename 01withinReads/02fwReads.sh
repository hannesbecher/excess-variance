

# conda activate kmc
gSim=~/git_repos/svsim/scripts/simulate_genome.py
rSim=~/git_repos/wgsim/wgsim

gs=1000000
outName=ref1M.fa

echo "Writing genome..."
#python $gSim $gs $outName

echo "Generating reads..."
#$rSim $outName $outName.21FW.fq $outName.21RW.fq -e 0 -1 21 -2 21 -R 0 -r 0 -N $(($gs/1*20))
#$rSim $outName $outName.130FW.fq $outName.130RW.fq -e 0 -1 150 -2 150 -R 0 -r 0 -N $(($gs/130*20))
$rSim $outName $outName.980FW.fq $outName.980RW.fq -e 0 -1 980 -2 1 -R 0 -r 0 -N $(($gs/980*20))



echo "Generating k-mer dumps..."
kmc -k21 -m20G -t6 -ci1 -cs1000000 $outName.21FW.fq $outName.21FW .
kmc -k21 -m20G -t6 -ci1 -cs1000000 $outName.130FW.fq $outName.130FW . 
kmc -k21 -m20G -t6 -ci1 -cs1000000 $outName.980FW.fq $outName.980FW . 


echo "Generating spectra..."
kmc_tools transform  $outName.21FW histogram  $outName.21FW.hist -cx5000000 -ci1
kmc_tools transform  $outName.130FW histogram  $outName.130FW.hist -cx5000000 -ci1
kmc_tools transform  $outName.980FW histogram  $outName.980FW.hist -cx5000000 -ci1


echo "Removing zero lines..."
awk '{ if( $2 != 0 ){ print $0 } }' $outName.21FW.hist > $outName.21FW.hist.no0 && rm $outName.21FW.hist
awk '{ if( $2 != 0 ){ print $0 } }' $outName.130FW.hist > $outName.130FW.hist.no0 && rm $outName.130FW.hist
awk '{ if( $2 != 0 ){ print $0 } }' $outName.980FW.hist > $outName.980FW.hist.no0 && rm $outName.980FW.hist

echo "Done."
