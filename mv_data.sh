#/bin/sh
basedir=/seastor/helenhelen/Cicero
substart=$1
subend=$2
for ((m=substart; m<=subend; m++))
#for m in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=MOL0${m}
    else
        SUB=MOL${m}
    fi
    echo $SUB
#datadir=${basedir}/${SUB}/behav/SingleTrial
#rm $datadir/*.txt
#    for f in bi left right
#    do
#        datadir=${basedir}/${SUB}/data/anatomy/sub_hipp/${f}
#        rm $datadir/Warp*
#    done
for r in 1 2
do
datadir=${basedir}/${SUB}/analysis/mol_test_run${r}.feat/betaseries
rm $datadir/*.nii.gz
done
done
