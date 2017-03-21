basedir='/seastor/helenhelen/Cicero'
affinedir=$basedir/transforms/c2e
#for ((m=1; m<=31; m++))
for m in 3 17 23 26
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
    SUBDIR=$basedir/${SUB}
    reffile=${SUBDIR}/analysis/mol_test_run1.feat/reg/example_func.nii.gz
    for d in left right
    do
        datadir=$basedir/${SUB}/data/anatomy/sub_hipp/${d}
        resultdir=$basedir/${SUB}/roi_ref/sub_hipp/${d}
        mkdir ${resultdir} -p
        cd $datadir
        for i in *.nii.gz
        do
            roiname=`echo $i|sed -e "s/.nii.gz//g"`
            WarpTimeSeriesImageMultiTransform 4 ${i} $resultdir/${i} -R $reffile $affinedir/${sub}_Affine.txt
        done
    done
done

