#!/opt/fmritools/pylib/anaconda/bin/python
from os.path import join as opj
import os
import glob
import subprocess
import shutil
import time

basedir = '/seastor/helenhelen/Cicero'
patterndir = '%s/pattern'%(basedir)
bolddir = '%s/data/bold'%(patterndir)
transformdir = '%s/transforms'%(basedir)
rawdir = '%s/raw_bold'%(bolddir)
refdir = '%s/example_func'%(bolddir)
e2refdir = '%s/epi2refepi'%(transformdir)
aligndir = '%s/aligned_bold'%(bolddir)

e2adir = '%s/e2h'%(transformdir)
a2sdir = '%s/h2t'%(transformdir)

#roihodir = '%s/ROIs/roi_ho2s5'%(patterndir)
#roidir = '%s/ROIs/roi_ho25_native'%(patterndir)
#roiunthrdir = '%s/roi_unthresh'%(roidir)

# Check directory
#checklist = [roidir,roiunthrdir]
#for cur_dir in list(checklist):
#    if os.path.exists(cur_dir) == False:
#        os.makedirs(cur_dir)

#roilist = sorted(glob.glob(opj(roihodir,'*.nii.gz')))
Subjlist = sorted(glob.glob('%s/MOL[0-9][0-9]'%(basedir)))
for cur_sub in list(Subjlist):
    iSub = cur_sub.split('/')[-1]

    # transform HO25 template roi to each subject's native
    epi2anat_mat = opj(e2adir,'%s_epi2anat_0GenericAffine.mat'%(iSub))
    anat2stand_mat = opj(a2sdir,'%s_anat2standard_0GenericAffine.mat'%(iSub))
    anat2stand_warp = opj(a2sdir,'%s_anat2standard_1InverseWarp.nii.gz'%(iSub))
    refvol = opj(refdir,'%s_learning1_example_func.nii.gz'%(iSub))

    for cur_roi in list(roilist):
        outfile = opj(roiunthrdir,'%s_%s'%(iSub,cur_roi.split('/')[-1]))
        do_roi_transform = ('antsApplyTransforms ' +
                            '-d 3 ' +
                            '-i %s '%(cur_roi) +
                            '-r %s '%(refvol) +
                            '-o %s '%(outfile) +
                            '-t [%s,1] '%(epi2anat_mat) +
                            '-t [%s,1] '%(anat2stand_mat) +
                            '-t %s '%(anat2stand_warp) +
                            '--float 1')
        subprocess.call(do_roi_transform, shell=True)
        # thresh the converted roi, 0.5
        infile = opj(roiunthrdir,'%s_%s'%(iSub,cur_roi.split('/')[-1]))
        outfile = opj(roidir,'%s_%s'%(iSub,cur_roi.split('/')[-1]))
        thresh = '0.5'
        do_roi_thresh = ('fslmaths ' +
                         '%s '%(infile) +
                         '-thr %s '%(thresh) +
                         '-bin ' +
                         '%s'%(outfile))
        subprocess.call(do_roi_thresh, shell=True)
