

# USAGE python script_poisson.py [ll] [infile]
from Bio import SeqIO
import numpy as np
import sys



ll = float(sys.argv[1]) # Poisson lambda
pp = float(sys.argv[2]) # probability read is sampled at all
infile = sys.argv[3]
outfile = infile + "_" + str(pp) + "_" + str(ll) + "_outCPois.fa"

# to count input recods
c = 0

# open out file
with open(outfile, "w") as of:
# loop over FQ records in infile
    for sr in SeqIO.parse(infile, "fasta"):
        if np.random.uniform() < pp:
            c += 1
            dd = np.random.poisson(ll)
            repC = 0
            for rep in range(dd):
                repC += 1
                sr.id = "%08d_%d" % (c, repC)
                sr.description = sr.id
                sr.name = sr.id
        
                SeqIO.write(sr, of, "fasta")
