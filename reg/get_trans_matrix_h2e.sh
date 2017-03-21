basedir='/seastor/helenhelen/Cicero'
resultdir=$basedir/transforms
m=$1
#for ((m=9; m<=31; m++))
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
highres_file=$basedir/MOL${SUB}/data/anatomy/highres_brain.nii.gz
ref_file=$basedir/pattern/data/bold/example_func/MOL${SUB}_mol_test_run1_example_func.nii.gz
SUBDIR=$basedir/MOL${SUB}
h2e_affine=$resultdir/h2e/sub${SUB}
fsl_sub ANTS 3 -m MI[$ref_file,$highres_file,1,32] -o ${h2e_affine}_ --rigid-affine true -i 0
