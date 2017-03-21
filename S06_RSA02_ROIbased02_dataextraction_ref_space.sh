#!sh/bin/
basedir=/seastor/helenhelen/Cicero
for m in 3 17 23 26
#for ((m=1; m<=31; m++))
do
    if [ ${m} -lt 10 ];
    then
       sub=sub0${m}
       SUB=MOL0${m}
    else
        sub=sub${m}
        SUB=MOL${m}
    fi
    echo $SUB
#maskdir=$basedir/${SUB}/roi_ref
maskdir=$basedir/${SUB}/roi_ref/sub_hipp
datadir=$basedir/pattern/singleTrial_Tmap/all;
resultdir=$basedir/pattern/ROI_based/ref_space/raw
mkdir $resultdir -p
        for roi in $maskdir/*.nii.gz
        do
        roi_prefix=`basename $roi | sed -e "s/.nii.gz//"`
        fslmeants -i $datadir/${sub}.nii.gz --showall -m $maskdir/${roi_prefix} -o $resultdir/${sub}_${roi_prefix}.txt
        #fsl_sub -q short.q fslmeants -i $datadir/${sub}.nii.gz --showall -m $maskdir/${roi_prefix} -o $resultdir/${sub}_${roi_prefix}.txt
        done # roi
done # sub
