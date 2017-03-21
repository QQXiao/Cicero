basedir=/seastor/helenhelen/Cicero
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
    for f in bi left right
    do
        datadir=$basedir/${SUB}/data/anatomy/sub_hipp/${f}
        for r in CA1 subiculum DG
        do
            datafile=${datadir}/${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 0 38 -1 -1 ${datadir}/h${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 38 6 -1 -1 ${datadir}/b${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 44 -1 -1 -1 ${datadir}/t${r}.nii.gz
        done
    done
done
