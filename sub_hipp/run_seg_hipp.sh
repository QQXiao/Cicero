#!sh/bin/
basedir=/seastor/helenhelen/Cicero
#ASHS_ROOT=~/DQ/project/git/SleeplessInSeattle/ashs
#for m in 1
for ((m=1; m<=31; m++))
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
datadir=$basedir/${SUB}/data/anatomy
resultdir=$basedir/${SUB}/data/anatomy/seg_hipp
mkdir $resultdir -p
ori_T2=${datadir}/coronal_ND.nii.gz
tra_T2=${datadir}/coronal_ND_r.nii.gz
#fslswapdim ${ori_T2} RL IS AP ${tra_T2}
fsl_sub -q verylong.q $ASHS_ROOT/bin/ashs_main.sh -a $ASHS_ROOT/atlas_upennpmc -g ${datadir}/highres_brain.nii.gz -f ${tra_T2} -w $resultdir
#$ASHS_ROOT/bin/ashs_main.sh -a $ASHS_ROOT/atlas_upennpmc -g ${datadir}/highres_brain.nii.gz -f ${datadir}/coronal_ND.nii.gz -w $resultdir
done
