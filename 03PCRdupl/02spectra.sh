
for i in 300 500
do
#for j in 0.1 0.25 0.4 0.55 0.7
#for j in 1 1.5 2.5 5
for j in 10 20 50
do 
echo "Generating k-mer dump for IS $i dup $j..."
ls ref1M.fa.IS$i.$j.?W.dup.fq.gz > readFile 

kmc -k21 -m20G -t6 -ci1 -cs1000000 @readFile ref1M.fa.IS$i.$j.dup.FR .


echo "Generating spectrum for IS $i dup $j..."
kmc_tools transform  ref1M.fa.IS$i.$j.dup.FR histogram  ref1M.fa.IS$i.$j.dup.FR.hist -cx5000000 -ci1


echo "Removing zero lines from IS $i dup $j..."
awk '{ if( $2 != 0 ){ print $0 } }' ref1M.fa.IS$i.$j.dup.FR.hist > ref1M.fa.IS$i.$j.dup.FR.hist.no0 &&  rm ref1M.fa.IS$i.$j.dup.FR.hist
rm readFile
done
done

#for i in 300 500
#
#do 
#echo "Generating k-mer dump for $i..."
#ls ../02readOverlap/ref1M.fa.IS$i.?W.fq.gz > readFile 

#kmc -k21 -m20G -t6 -ci1 -cs1000000 @readFile ref1M.fa.IS$i.FR .


#echo "Generating spectrum for $i..."
#kmc_tools transform  ref1M.fa.IS$i.FR histogram  ref1M.fa.IS$i.FR.hist -cx5000000 -ci1


#echo "Removing zero lines from $i..."
#awk '{ if( $2 != 0 ){ print $0 } }' ref1M.fa.IS$i.FR.hist > ref1M.fa.IS$i.FR.hist.no0 && rm ref1M.fa.IS$i.FR.hist
#rm readFile
#done


