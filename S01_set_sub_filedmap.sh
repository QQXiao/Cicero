#!/bin/bash
basedir=/seastor/helenhelen/Cicero
#datadir=/seastor/Projects/Cicero/dicom
datadir=/seastor/Projects/Cicero/sourcedata
DATAROOT=$basedir/raw
MATLAB=matlab2013b

cd $datadir
#for i in *9* *10* *11* *12*
for i in MOL*
#for i in *.tar.gz
do
        dirname=`echo $i`
        subid=`echo $dirname|cut -d "_" -f3`
        if [ ! -d $subid ]
        then
		#mkdir -p $basedir/$subid/data
		#mkdir -p $basedir/$subid/data/raw
		#mkdir -p $basedir/$subid/analysis
		#mkdir -p $basedir/$subid/behav
		#tar xf $i
		#dcm2nii -n -g -o $basedir/$subid/data/raw $dirname

		bolddir=$basedir/$subid/data/bold
		#mkdir ${bolddir}
		anatomydir=$basedir/$subid/data/anatomy
		#mkdir ${anatomydir}
		fieldmapdir=$basedir/$subid/data/fieldmap
		#mkdir ${filedmapdir}
		restdir=$basedir/$subid/data/rest
		#mkdir ${restdir}
		localizerdir=$basedir/$subid/data/localizer
		#mkdir ${localizerdir}

		niidir=$basedir/$subid/data/raw
	 	cd $niidir
		#cp *rest* $restdir/resting.nii.gz
	 	#cp *localizer1* $localizerdir/localizer_run1.nii.gz
	 	#cp *localizer2* $localizerdir/localizer_run2.nii.gz
		#cp *encoding1* ${bolddir}/encoding_run1.nii.gz
		#cp *encoding2* ${bolddir}/encoding_run2.nii.gz
		#cp *testing1* ${bolddir}/test_run1.nii.gz
		#cp *testing2* ${bolddir}/test_run2.nii.gz
		#cp *swm1* ${bolddir}/swm_run1.nii.gz
		#cp *swm2* ${bolddir}/swm_run2.nii.gz
		#cp *swm3* ${bolddir}/swm_run3.nii.gz
		#cp *swm4* ${bolddir}/swm_run4.nii.gz

		#coronal=`ls *T2coronals028*`
		#fslreorient2std $coronal ${anatomydir}/coronal_ND.nii.gz
		#coronal=`ls *T2coronals029*`
		#fslreorient2std $coronal ${anatomydir}/coronal.nii.gz

		for f in *grefield*
    		do
        	nvols=`fslnvols $f`
        		if [ "$nvols" -eq "2" ]
        		then
            			fslroi $f tmp.nii.gz 0 1
            			mv tmp.nii.gz ${fieldmapdir}/fieldmap_mag.nii.gz
	    			bet ${fieldmapdir}/fieldmap_mag.nii.gz ${fieldmapdir}/fieldmap_mag_brain.nii.gz -R -m -f 0.3
       			fi

            if [ "$nvols" -eq "1" ]
            then
                cp $f ${fieldmapdir}/fieldmap_phase.nii.gz
            fi
    		done

		 #prepare fieldmap for FEAT GLM analyses
		#fsl_prepare_fieldmap SIEMENS ${filedmapdir}/fieldmap_phase ${filedmapdir}/fieldmap_mag_brain ${filedmapdir}/fieldmap_rads 2.46

		#highres structure image for whole brain
         	#cp co*.nii.gz ${anatomydir}/highres.nii.gz
         	#fslorient -swaporient ${anatomydir}/highres.nii.gz
	 	#bet ${anatomydir}/highres.nii.gz ${anatomydir}/highres_brain.nii.gz -f 0.25 -R
	 	#bet ${anatomydir}/highres.nii.gz ${anatomydir}/highres_brain.nii.gz -m  -f 0.2 -R -B
		# generate a tight mask for fieldmap use
		#fsl_sub bet ${anatomydir}/highres.nii.gz 3d_brain_tight.nii.gz -m -f 0.3 -R -B
       	fi
done
