

# USAGE python script_fixed_dupl.py [ll] [infile]
from Bio import SeqIO
import numpy as np
import sys



ll = int(sys.argv[1])
infile = sys.argv[2]
outfile = infile + ".outFix.fa"

# to count input recods
c = 0

# open out file
with open(outfile, "w") as of:
# loop over FQ records in infile
    for sr in SeqIO.parse(infile, "fastq"):
        #if c > 10: break # for debug
        c += 1

        repC = 0
        for rep in range(ll):
            repC += 1
            sr.id = "%08d_%d" % (c, repC)
            sr.description = sr.id
            sr.name = sr.id
        
            SeqIO.write(sr, of, "fasta")
