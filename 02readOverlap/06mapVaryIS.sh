

# conda activate vagrantSim #(contains bwa-mem2)

for IS in 200 250 300 350 400 450 500
do

#bwa-mem2 index ref1M.fa
bwa-mem2 mem -t 6 ref1M.fa ref1M.fa.IS$IS.FW.fq.gz ref1M.fa.IS$IS.RW.fq.gz | samtools view -b > ref1M.fa.IS$IS"r.bam"

done
echo "Sorting..."
for i in *0r.bam; do samtools sort -@4 -o ${i%.*}s.bam $i; done
echo "Computing BAM stats..."
for i in *0rs.bam; do samtools stats $i > $i.stats; done


echo "Done."


