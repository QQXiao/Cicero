#!/opt/fmritools/pylib/anaconda/bin/python
from os.path import join as opj
import os
import glob
import subprocess
import shutil
import time

basedir = '/seastor/zhifang/Testing_effect'
fsdir = '%s/FreeSurferResults'%(basedir)
patterndir = '%s/Pattern'%(basedir)
bolddir = '%s/Bold_Data'%(patterndir)
anatdir = '%s/Anatomy_FS'%(patterndir)
anatlpidir = '%s/orig_lpi'%(anatdir)
exampledir = '%s/example_func'%(bolddir)
transformdir = '%s/Transforms'%(patterndir)
e2adir = '%s/epi2anat'%(transformdir)
bbregdir = '%s/bbreg_epi2anat'%(e2adir)

# Check directory
checklist = [patterndir,bolddir,anatdir,anatlpidir,exampledir,transformdir]
for cur_dir in list(checklist):
    if os.path.exists(cur_dir) == False:
        os.makedirs(cur_dir)
checklist = [e2adir,bbregdir]
for cur_dir in list(checklist):
    if os.path.exists(cur_dir) == True:
        shutil.rmtree(cur_dir)
        os.makedirs(cur_dir)
    elif os.path.exists(cur_dir) == False:
        os.makedirs(cur_dir)

# get subjects list
Subjlist = sorted(glob.glob('%s/Sub[0-9][0-9]'%(basedir)))
for cur_sub in list(Subjlist):
    iSub = cur_sub.split('/')[-1]

    # calculate example_func(learning) to anat transform
    infile = opj(exampledir,'%s_learning1_example_func.nii.gz'%(iSub))
    outfile1 = opj(bbregdir,'%s_epi2anat.dat'%(iSub))
    outfile2 = opj(bbregdir,'%s_epi2anat_fsl.mat'%(iSub))
    logdir = bbregdir
    logfile = 'epi2anat_%s'%(iSub)
    do_bbregister = ('SUBJECTS_DIR=%s; '%(fsdir) +
                     'fsl_sub ' +
                     '-l %s '%(logdir) +
                     '-N %s '%(logfile) +
                     'bbregister ' +
                     '--s FS_%s '%(iSub) +
                     '--mov %s '%(infile) +
                     '--reg %s '%(outfile1) +
                     '--fslmat %s '%(outfile2) +
                     '--init-fsl ' +
                     '--bold')
    subprocess.call(do_bbregister, shell=True)

# check status
while True:
    time.sleep(30)
    num = subprocess.check_output('qstat | grep epi2anat | wc -l',
                                  shell=True)
    if int(num[:-1]) == 0:
        break

# convert affine transform matrix to ITK-format for ANTs use
for cur_sub in list(Subjlist):
    iSub = cur_sub.split('/')[-1]
    reffile = opj(anatlpidir,'%s_orig.nii.gz'%(iSub))
    infile = opj(exampledir,'%s_learning1_example_func.nii.gz'%(iSub))
    fslmat = opj(bbregdir,'%s_epi2anat_fsl.mat'%(iSub))
    itkmat = opj(e2adir,'%s_epi2anat_0GenericAffine.mat'%(iSub))
    do_convert = ('export PATH="/opt/fmritools/c3d/bin":$PATH; ' +
                  'c3d_affine_tool ' +
                  '-ref %s '%(reffile) +
                  '-src %s '%(infile) +
                  '%s '%(fslmat) +
                  '-fsl2ras ' +
                  '-oitk %s'%(itkmat))
    subprocess.call(do_convert, shell=True)
