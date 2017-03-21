#!/bin/sh
basedir=/seastor/helenhelen/Cicero
designdir=${basdir}/scripts/fsf/glm/design
fsfdir=${basdir}/scripts/fsf/glm/fsf
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
    for c in encoding test
    do
        for ((r=1;r<=2;r++))
        do
            for ((t=1;t<=30;t++))
            do
                sed -e "s/ISR01/${SUB}/g"  -e "s/encoding/${c}/g" -e "s/run1/run${r}/g" -e "s/T1/T${t}/g" $designdir/design.fsf > $fsfdir/single_${c}_${SUB}_run${r}_T${t}.fsf
                #feat $fsfdir/single_${c}_${SUB}_run${r}_T${t}.fsf
            done
        done
    done
done
