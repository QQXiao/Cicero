#!/bin/sh
basedir=/seastor/helenhelen/Cicero
#for m in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 25
for ((m=1; m<=12; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=MOL0${m}
       sub=sub0${m}
    else
        SUB=MOL${m}
        sub=sub${m}
    fi
    echo $SUB
scriptdir=/seastor/helenhelen/Cicero/scripts/fsf/design
outputdir=/seastor/helenhelen/Cicero/scripts/fsf/fsf
#sed -e "s/sub01/${sub}/g" -e "s/MOL01/${SUB}/g" $scriptdir/sme_mol_test_2nd.fsf > $outputdir/sme_mol_test_${sub}_2nd.fsf
fsl_sub feat $outputdir/sme_mol_test_${sub}_2nd.fsf
done
