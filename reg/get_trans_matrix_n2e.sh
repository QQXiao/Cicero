basedir='/seastor/helenhelen/Cicero'
patterndir=$basedir/pattern
refdir=$patterndir/data/bold/example_func
rawdir=$patterndir/data/bold/raw_bold
aligndir=$patterndir/data/bold/aligned_bold
resultdir=$basedir/transforms/n2e
m=$1
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
SUBDIR=$basedir/MOL${SUB}

refvol=${SUBDIR}/analysis/mol_test_run1.feat/reg/example_func.nii.gz
for c in encoding test
do
    for r in 1 2
    do
        nativefile=${SUBDIR}/analysis/mol_${c}_run${r}.feat/filtered_func_data.nii.gz
        examplefile=${SUBDIR}/analysis/mol_${c}_run${r}.feat/reg/example_func.nii.gz

        rawfile=${rawdir}/MOL${SUB}_mol_${c}_run${r}_native.nii.gz
        efile=${refdir}/MOL${SUB}_mol_${c}_run${r}_example_func.nii.gz

        #cp $nativefile $rawfile
        #cp $examplefile $efile

        n2e_affine=$resultdir/MOL${SUB}_mol_${c}_run${r}
        ANTS 3 -m MI[$refvol,$efile,1,32] -o ${n2e_affine}_ --rigid-affine true -i 0
    done
done
