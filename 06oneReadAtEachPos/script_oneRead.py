

# USAGE python script_poisson.py [ll] [infile]
from Bio import SeqIO
import numpy as np
import sys




infile = sys.argv[1]
outfile = infile + ".reads.fa"

rec = SeqIO.read(infile, "fasta")
seqString = str(rec.seq)
ll = len(rec) # Genome length


rl = 150

rcMax = ll-rl

print(f"Genome length is {ll}. Making {rcMax} reads.")

rc=0

# open out file
with open(outfile, "w") as of:
# loop over FQ records in infile
    while rc < rcMax:
        #if c > 10: break # for debug
        if rc % 10000 == 0: print(rc)
        read = seqString[rc:rc+151]
        of.write(f">{rc:08d}\n{read}\n")
        rc += 1
