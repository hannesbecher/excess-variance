

# USAGE python script_poisson.py [ll] [infile]
from Bio import SeqIO
import numpy as np
import sys



ll = float(sys.argv[1]) # Poisson lambda
infile = sys.argv[2]
outfile = infile + str(ll) + ".outPois.fa"

# to count input recods
c = 0

# open out file
with open(outfile, "w") as of:
# loop over FQ records in infile
    for sr in SeqIO.parse(infile, "fastq"):
        #if c > 10: break # for debug
        c += 1
        dd = np.random.poisson(ll)
        repC = 0
        for rep in range(dd):
            repC += 1
            sr.id = "%08d_%d" % (c, repC)
            sr.description = sr.id
            sr.name = sr.id
        
            SeqIO.write(sr, of, "fasta")
