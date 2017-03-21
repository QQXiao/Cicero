#!/bin/sh
basedir=/seastor/helenhelen/Cicero
scriptdir=/seastor/helenhelen/Cicero/scripts/fsf/design
outputdir=/seastor/helenhelen/Cicero/scripts/fsf/fsf

substart=$1
subend=$2

for ((m = $substart; m <= $subend; m++))
do
#sed -e "s/cope1/cope${m}/g" $scriptdir/sme_mol_test_3rd.fsf > $outputdir/sme_mol_test_cope${m}_3rd.fsf
feat $outputdir/sme_mol_test_cope${m}_3rd.fsf
done
