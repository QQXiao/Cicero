basedir=/seastor/helenhelen/Cicero
datadir=$basedir/data_singletrial/TR/ref_space/run
resultdir=$basedir/pattern/TR/data/ref_space/all
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
fsl_sub fslmerge -t $resultdir/sub${SUB} $datadir/*_sub${SUB}.nii.gz
done #sub
