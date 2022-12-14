# conda activate vagrantSim

bwa-mem2 index ref1M.fa
bwa-mem2 mem -t 6 ref1M.fa ref1M.fa.21FW.fq.gz ref1M.fa.21RW.fq.gz | samtools view -b > ref1M.fa.21r.bam
bwa-mem2 mem -t 6 ref1M.fa ref1M.fa.1kFW.fq.gz ref1M.fa.1kRW.fq.gz | samtools view -b > ref1M.fa.1kr.bam
bwa-mem2 mem -t 6 ref1M.fa ref1M.fa.150FW.fq.gz ref1M.fa.150RW.fq.gz | samtools view -b > ref1M.fa.150r.bam

echo "Sorting..."
for i in *r.bam; do samtools sort -@4 -o ${i%.*}s.bam $i; done
echo "Computing BAM stats..."
for i in *rs.bam; do samtools stats $i > $i.stats; done
echo "Done."
