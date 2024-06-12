# conda activate biopython


for cc in 10 5 2 1.5 1 0.95 0.9 0.85 0.8 0.7 0.6 0.51 0.5 0.49 0.2 0.1 0.05 0.02 0.01
do
nn=`echo "1000000*$cc/1" | bc`
ll=`echo "scale=4; 1000000 * 40 / $nn / 150" | bc`

echo \"Complexity\" is $cc.
echo Number of raw reads is $nn.
echo Lambda for 40X is $ll.

bash 02makeReads.sh $nn # the output is fw$nn.fq

# to Poisson-sample reads from "raw" read file of specified complexity
python script_poisson.py $ll fw$nn.fq # go on here, may need to change the python script!

done


#python script_poisson.py 1 0.266666666666667 fw.fq
#python script_poisson.py 0.5 0.533333333333333 fw.fq
#python script_poisson.py 0.2 1.33333333333333 fw.fq
#python script_poisson.py 0.1 2.66666666666667 fw.fq
#python script_poisson.py 0.05 5.33333333333333 fw.fq
#python script_poisson.py 0.02 13.3333333333333 fw.fq
#python script_poisson.py 0.01 26.6666666666667 fw.fq

