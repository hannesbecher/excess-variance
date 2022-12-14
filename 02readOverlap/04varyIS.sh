

# conda activate kmc
gSim=~/git_repos/svsim/scripts/simulate_genome.py
rSim=~/git_repos/wgsim/wgsim

gs=1000000
outName=ref1M.fa


echo "Writing genome..."
#python $gSim $gs $outName

for IS in 200 250 300 350 400 450 500
do

mkfifo FWpipe
mkfifo RWpipe


echo "Generating reads with IS $i and compressing..."
$rSim $outName FWpipe RWpipe -e 0 -1 150 -2 150 -d $IS -R 0 -r 0 -N $(($gs/130*100)) &
cat FWpipe | pigz -p 3 > $outName.IS$IS.FW.fq.gz &
cat RWpipe | pigz -p 3 > $outName.IS$IS.RW.fq.gz


rm FWpipe
rm RWpipe

echo "Generating k-mer dump for IS $i..."
ls $outName.IS$IS.?W.fq.gz > readFile 

kmc -k21 -m20G -t6 -ci1 -cs1000000 @readFile $outName.IS$IS.FR .

echo "Generating spectrum for IS $i..."
kmc_tools transform  $outName.IS$IS.FR histogram  $outName.IS$IS.FR.hist -cx5000000 -ci1


echo "Removing zero lines from IS $i..."
awk '{ if( $2 != 0 ){ print $0 } }' $outName.IS$IS.FR.hist > $outName.IS$IS.FR.hist.no0 && rm $outName.IS$IS.FR.hist
rm readFile
done

echo "Done."
