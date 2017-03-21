basedir=/seastor/helenhelen/Cicero
resultdir=$basedir/pattern/TR/data/ref_space/run
datadir=$basedir/pattern/TR/data/ref_space/sep
mkdir $resultdir -p

for ((m=1; m<=31; m++))
do
    if [ ${m} -lt 10 ];
    then
       SUB=0${m}
    else
        SUB=${m}
    fi
    echo $SUB
#merege file
for c in encoding test
do
fsl_sub fslmerge -t $resultdir/${c}_sub${SUB} $datadir/sub${SUB}_${c}_run*.nii.gz
done #c
done #sub
