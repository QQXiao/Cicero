ANTSPATH=/opt/fmritools/ANTs/antsbin/bin/
basedir='/seastor/helenhelen/Cicero'
resultdir=$basedir/transforms
#m=$1
for m in 2
#for m in 1 2 4 5
    #1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
#for ((m=5; m<=21; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
t2e_affine=$resultdir/t2e/sub${SUB}_Affine.txt

t2h_affine=$resultdir/t2h/sub${SUB}_0GenericAffine.mat
h2e_affine=$resultdir/h2e/sub${SUB}_Affine.txt
ComposeMultiTransform 3 $resultdir/t2e/sub${SUB}_Affine.txt -R ${h2e_affine} ${h2e_affine} ${t2h_affine}
done
