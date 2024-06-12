# conda activate biopython

# depth is dd
for dd in 10 20 30 40 50 60
do

ll=`echo "scale=4; $dd / 150" | bc -l`



echo Depth is "$dd"X. Lambda for is $ll.

# to Poisson-sample reads from "raw" read file 
python script_poisson.py $ll genome.fa.reads.fa
done

