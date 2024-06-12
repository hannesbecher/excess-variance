

for i in *outCPois.fa;
do
# conda activate kmc
echo Processing $i ...
echo Writing to $i.kmc ...
kmc -k21 -fm $i $i.kmc .
echo Writing histogram ...
kmc_tools transform $i.kmc histogram $i.hist

done
