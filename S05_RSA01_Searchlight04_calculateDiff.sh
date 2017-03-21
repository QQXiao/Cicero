basedir=/seastor/helenhelen/Cicero
datadir=$basedir/pattern/Searchlight_RSM/ref_space/each_cond
resultdir=$basedir/pattern/Searchlight_RSM/ref_space/diff
mkdir -p $resultdir

cd $datadir
for ((m=1; m<=31; m++))
#for m in 1 2 4 5
do
    if [ ${m} -lt 10 ];
    then
       s=0${m}
    else
        s=${m}
    fi
    fslmaths item_ERS_wi_sub${s}.nii.gz -sub item_ERS_bi_sub${s}.nii.gz ${resultdir}/item_ERS_sub${s}
    ##1. Neural representation of spatial context: Within Loci > Across Loci
    # ln mem
    for c in ln mem
    do
        for p in wr cr
        do
            fslmaths rs_${c}_wl_${p}_sub${s} -sub rs_${c}_bl_${p}_sub${s} $resultdir/rs_${c}_${p}_sub${s}
            #fsl_sub fslmaths rs_${c}_wl_${p}_sub${s} -sub rs_${c}_bl_${p}_sub${s} $resultdir/rs_${c}_${p}_sub${s}
        done
    done
    # ERS
    fslmaths rs_ERS_wl_sub${s} -sub rs_ERS_bl_sub${s} $resultdir/rs_ERS_sub${s}

    ##3. Neural representation of temporal context: Sequential Neighbors > Long Distance Pairs
    for ld in rt_ERS rt_ln rt_mem rt
    do
        fslmaths ${ld}_sED_sub${s} -sub ${ld}_lED_sub${s} $resultdir/${ld}_sub${s}
    done
done
