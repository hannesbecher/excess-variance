# using svsim from https://github.com/mfranberg/svsim
# conda activate biopython

echo Simulating genome...
python ../../svsim/scripts/simulate_genome.py 1000000 genome.fa

echo Making reads...
python script_oneRead.py genome.fa

echo Done.
