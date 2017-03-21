basedir=/seastor/helenhelen/Cicero
resultdir=$basedir/pattern/singleTrial_Tmap/all
datadir=$basedir/pattern/singleTrial_Tmap
rundir=$basedir/pattern/singleTrial_Tmap/run

#substart=$1
#subend=$2
#for ((m = $substart; m <= $subend; m++))
#for m in 1 2 3 4 5 6 7 8
    #1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
for ((m=1; m<=31; m++))
#for m in 13
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
#merege file
#for c in encoding test
#do
#fslmerge -t ${rundir}/${SUB}_${c}.nii.gz ${datadir}/${SUB}_*_${c}_run*.nii.gz
#done #c
fslmerge -t ${resultdir}/${sub}.nii.gz ${rundir}/${SUB}_*.nii.gz
done #sub
