

# conda activate kmc
gSim=~/git_repos/svsim/scripts/simulate_genome.py
rSim=~/git_repos/wgsim/wgsim

gs=1000000
outName=ref1M.fa

mkfifo FWpipe
mkfifo RWpipe

echo "Writing genome..."
python $gSim $gs $outName

echo "Generating reads and compressing..."
$rSim $outName FWpipe RWpipe -e 0 -1 21 -2 21 -R 0 -r 0 -N $(($gs/1*100)) &
cat FWpipe | pigz -p 3 > $outName.21FW.fq.gz &
cat RWpipe | pigz -p 3 > $outName.21RW.fq.gz


$rSim $outName FWpipe RWpipe -e 0 -1 150 -2 150 -R 0 -r 0 -N $(($gs/130*100)) &
cat FWpipe | pigz -p 3 > $outName.150FW.fq.gz &
cat RWpipe | pigz -p 3 > $outName.150RW.fq.gz 



$rSim $outName FWpipe RWpipe -e 0 -1 1000 -2 1000 -R 0 -r 0 -N $(($gs/980*100)) &
cat FWpipe | pigz -p 3 > $outName.1kFW.fq.gz &
cat RWpipe | pigz -p 3 > $outName.1kRW.fq.gz 


rm FWpipe
rm RWpipe



for i in 150 1k 21
do 
echo "Generating k-mer dump for $i..."
ls $outName.$i?W.fq.gz > readFile 

kmc -k21 -m20G -t6 -ci1 -cs1000000 @readFile $outName.$i.FR .


echo "Generating spectrum for $i..."
kmc_tools transform  $outName.$i.FR histogram  $outName.$i.FR.hist -cx5000000 -ci1


echo "Removing zero lines from $i..."
awk '{ if( $2 != 0 ){ print $0 } }' $outName.$i.FR.hist > $outName.$i.FR.hist.no0 && rm $outName.$i.FR.hist
rm readFile
done

echo "Done."
