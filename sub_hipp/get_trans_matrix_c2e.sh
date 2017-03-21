basedir='/seastor/helenhelen/Cicero'
resultdir=$basedir/transforms
for ((m=1; m<=31; m++))
do
#for ((m=5; m<=21; m++))
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
highres_file=$basedir/MOL${SUB}/data/anatomy/highres_brain.nii.gz
coronal_file=$basedir/MOL${SUB}/data/anatomy/coronal_ND_r.nii.gz
ref_file=$basedir/MOL${SUB}/data/bold/ref.nii.gz
SUBDIR=$basedir/MOL${SUB}
h2e_affine=$resultdir/h2e/sub${SUB}_Affine.txt
c2h_affine=$resultdir/c2h/sub${SUB}_Affine.txt
c2e_affine=$resultdir/c2e/sub${SUB}_Affine.txt
# calculate coronal_mean to ORIG transforms
#fsl_sub ANTS 3 -m MI[${highres_file},${coronal_file},1,32] -o ${c2h_affine} --rigid-affine true -i 0
fsl_sub ComposeMultiTransform 3 ${c2e_affine} -R ${h2e_affine} ${h2e_affine} ${c2h_affine}
done
