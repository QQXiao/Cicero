#!/bin/sh
outputdir=/seastor/helenhelen/Cicero
for ((m=1; m<=12; m++))
#for m in 1
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
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
	for ((r=1;r<=2;r++))
	do
	#sed -e "s/MOL01/${SUB}/g" -e "s/sub01/${sub}/g" -e "s/run1/run${r}/g" $outputdir/scripts/fsf/design/sme_mol_test.fsf > $outputdir/scripts/fsf/sme_mol_test_${sub}_run${r}.fsf
    feat $outputdir/scripts/fsf/sme_mol_test_${sub}_run${r}.fsf
	done
done
