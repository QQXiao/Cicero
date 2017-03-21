basedir='/seastor/helenhelen/Cicero'
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz
resultdir=$basedir/transforms
m=$1
#for ((m=5; m<=21; m++))
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
# n2h
e2h_affine=$resultdir/e2h/sub${SUB}
fsl_sub ANTS 3 -m MI[$highres_file,$ref_file,1,32] -o ${e2h_affine}_ --rigid-affine true -i 0
