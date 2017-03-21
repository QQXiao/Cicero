#!/bin/sh
basedir='/seastor/helenhelen/Cicero'
datadir=$basedir/pattern/Searchlight_RSM/ref_space/diff
resultdir=$basedir/pattern/Searchlight_RSM/standard_space/sub
mkdir $resultdir -p
affinedir=$basedir/transforms/e2t
templatefile=/opt/fmritools/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz
for ((m=1; m<=31; m++))
#for m in 1 2 4 5
    #3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
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

    cd ${datadir}
    for c in *_${sub}.nii.gz
	do
        dirname=`echo $c|sed -e "s/.nii.gz//g"`
        #prefix=`echo $dirname|cut -d "_" -f1-3`
        WarpImageMultiTransform 3 ${c} $resultdir/${dirname}.nii.gz -R $templatefile $affinedir/${sub}_Affine.txt
        #fsl_sub WarpImageMultiTransform 3 ${c} $resultdir/${dirname}.nii.gz -R $templatefile $affinedir/${sub}_Affine.txt
	done
done
