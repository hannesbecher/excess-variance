# conda activate biopython

# depth is dd

# proportion of starting positions sampled 
for pp in 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1
do

# expected mapping depth
for dd in 10 20 30 40 50 60
do


ll=`echo "scale=6; $dd / 150 / $pp" | bc -l`



echo Prop of start sites is $pp. Lambda for depth "$dd"X is $ll.

# to Poisson-sample reads from "raw" read file 
python script_complexPoisson.py $ll $pp genome.fa.reads.fa
done

done
