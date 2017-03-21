basedir='/seastor/helenhelen/Cicero'
roi_name=("CA1" "CA2" "DG" "CA3" "head" "tail" "MISC" "subiculum" "ERC" "PRC")
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
		ldir=$basedir/${SUB}/data/anatomy/sub_hipp/left
		rdir=$basedir/${SUB}/data/anatomy/sub_hipp/right
		resultdir=$basedir/${SUB}/data/anatomy/sub_hipp/bi
		mkdir ${resultdir} -p
		for ((n=0; n<=9; n++))
		#for ((n=9; n<=9; n++))
		do
		roi=${roi_name[${n}]}
		lfile=${ldir}/${roi}.nii.gz
		rfile=${rdir}/${roi}.nii.gz
		fslmaths $lfile -add $rfile -bin ${resultdir}/${roi}.nii.gz
		done
done

