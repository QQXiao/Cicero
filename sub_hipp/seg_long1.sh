basedir=/seastor/helenhelen/Cicero
for m in 3
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
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 0 36 -1 -1 ${datadir}/h${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 37 5 -1 -1 ${datadir}/b${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 42 -1 -1 -1 ${datadir}/t${r}.nii.gz
        done
    done
done

for m in 17
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
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 0 21 -1 -1 ${datadir}/h${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 22 5 -1 -1 ${datadir}/b${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 28 -1 -1 -1 ${datadir}/t${r}.nii.gz
        done
    done
done

for m in 23
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
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 0 27 -1 -1 ${datadir}/h${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 28 5 -1 -1 ${datadir}/b${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 33 -1 -1 -1 ${datadir}/t${r}.nii.gz
        done
    done
done

for m in 26
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
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 0 21 -1 -1 ${datadir}/h${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 27 6 -1 -1 ${datadir}/b${r}.nii.gz
            fslmaths ${datafile} -bin -roi -1 -1 -1 -1 33 -1 -1 -1 ${datadir}/t${r}.nii.gz
        done
    done
done

