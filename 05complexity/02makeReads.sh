# make reads using wgsim (must be in path)
# USAGE: bash 02makeReads.sh [number of reads]


echo Producing $1 read pairs with wgsim... # for debug

wgsim -e 0 -N $1 -r 0 -R 0 -1 150 -2 150 genome.fa fw$1.fq rw$1.fq

echo wgsim done.
