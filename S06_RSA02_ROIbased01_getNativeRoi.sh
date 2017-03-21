basedir='/seastor/helenhelen/Cicero'
affinedir=$basedir/transforms/t2e
roidir=/seastor/helenhelen/roi/Cicero
#for m in 1 2 4 5
for m in 2
#3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
resultdir=$basedir/MOL${SUB}/roi_ref
mkdir -p $resultdir
reffile=$basedir/pattern/data/bold/example_func/MOL${SUB}_mol_test_run1_example_func.nii.gz
cd $roidir
#for roi in WB.nii.gz
for roi in *
do
roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
WarpImageMultiTransform 3 ${roi} $resultdir/${roi_prefix}.nii.gz -R $reffile $affinedir/sub${SUB}_Affine.txt
#fsl_sub -q verylong.q WarpImageMultiTransform 3 ${roi} $resultdir/${roi_prefix}.nii.gz -R $reffile $affinedir/sub${SUB}_Affine.txt
done
done
