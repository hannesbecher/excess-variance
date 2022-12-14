

# conda activate kmc
gSim=~/git_repos/svsim/scripts/simulate_genome.py
rSim=~/git_repos/wgsim/wgsim

gs=1000000
outName=ref1M.fa

mkfifo FWpipe


echo "Writing genome..."
#python $gSim $gs $outName

echo "Generating reads and compressing..."
$rSim $outName FWpipe /dev/null -e 0 -1 21 -2 21 -R 0 -r 0 -N $(($gs/1*100)) &
cat FWpipe | pigz -p 3 > $outName.21FW.fq.gz 



$rSim $outName FWpipe /dev/null -e 0 -1 150 -2 150 -R 0 -r 0 -N $(($gs/130*100)) &
cat FWpipe | pigz -p 3 > $outName.150FW.fq.gz 



$rSim $outName FWpipe /dev/null -e 0 -1 1000 -2 1000 -R 0 -r 0 -N $(($gs/980*100)) &
cat FWpipe | pigz -p 3 > $outName.1kFW.fq.gz 


rm FWpipe



echo "Generating k-mer dumps..."
kmc -k21 -m20G -t6 -ci1 -cs1000000 $outName.21FW.fq.gz $outName.21FW .
kmc -k21 -m20G -t6 -ci1 -cs1000000 $outName.150FW.fq.gz $outName.150FW . 
kmc -k21 -m20G -t6 -ci1 -cs1000000 $outName.1kFW.fq.gz $outName.1kFW . 


echo "Generating spectra..."
kmc_tools transform  $outName.21FW histogram  $outName.21FW.hist -cx5000000 -ci1
kmc_tools transform  $outName.150FW histogram  $outName.150FW.hist -cx5000000 -ci1
kmc_tools transform  $outName.1kFW histogram  $outName.1kFW.hist -cx5000000 -ci1


echo "Removing zero lines..."
awk '{ if( $2 != 0 ){ print $0 } }' $outName.21FW.hist > $outName.21FW.hist.no0 && rm $outName.21FW.hist
awk '{ if( $2 != 0 ){ print $0 } }' $outName.150FW.hist > $outName.150FW.hist.no0 && rm $outName.150FW.hist
awk '{ if( $2 != 0 ){ print $0 } }' $outName.1kFW.hist > $outName.1kFW.hist.no0 && rm $outName.1kFW.hist

echo "Done."
