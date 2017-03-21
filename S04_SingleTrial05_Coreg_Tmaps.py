#!/opt/fmritools/pylib/anaconda/bin/python
from os.path import join as opj
import os
import glob
import subprocess
import shutil
import time

# define directory
basedir = '/seastor/helenhelen/Cicero'
patterndir = '%s/pattern'%(basedir)
tmapdir = '%s/singleTrial_Tmap'%(patterndir)
e2refdir = '%s/transforms/epi2refepi'%(basedir)
refdir = '%s/pattern/data/bold/example_func'%(basedir)
logdir = '%s/scripts'%(basedir)

# check directory
if os.path.exists(tmapdir) == False:
    os.makedirs(tmapdir)

# define reference run
refrun = 'mol_test_run1'

# loop for tmap
tmaplist = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                'mol_*.feat','betaseries',
                                'ev1_lss_tmap.nii.gz')))
for cur_tmap in tmaplist:
    iSub = cur_tmap.split('/')[4]
    iRun = cur_tmap.split('/')[6].split('.')[0]

    # apply transformation to each tmap, get aligned tmap
    if iRun != refrun:
        infile = cur_tmap
        reffile = opj(refdir,'%s_mol_test_run1_example_func.nii.gz'%(iSub))
        outfile = opj(tmapdir,'%s_%s_tmap.nii.gz'%(iSub, iRun))
        transmatrix = opj(e2refdir,'%s_%s_2ref_0GenericAffine.mat'%(iSub, iRun))
        logfile = 'Coreg_%s_%s'%(iSub, iRun)
        apply_transform = ('fsl_sub -q short.q ' +
                           '-l %s '%(logdir) +
                           '-N %s '%(logfile) +
                           'antsApplyTransforms ' +
                           '--dimensionality 3 ' +
                           '--input-image-type 3 ' +
                           '--input %s '%(infile) +
                           '--reference-image %s '%(reffile) +
                           '--output %s '%(outfile) +
                           '--transform %s '%(transmatrix) +
                           '--float 1')
        subprocess.call(apply_transform, shell=True)
    elif iRun == refrun:
        infile = cur_tmap
        outfile = opj(tmapdir,'%s_%s_tmap.nii.gz'%(iSub, iRun))
        shutil.copy2(infile, outfile)

# check status
while True:
    time.sleep(60)
    num = subprocess.check_output('qstat | grep Coreg_ | wc -l', shell=True)
    if int(num[:-1]) == 0:
        break

# clean up
print 'All jobs has been done. Please check the log files!\n'
while 1:
    res = raw_input('Clean up log files? y/n\n')
    if res == 'y':
        junklist = sorted(glob.glob('%s/Coreg_*.*'%(logdir)))
        for junk in list(junklist):
            os.remove(junk)
        print 'Log files has been cleaned.'
        break
    elif res == 'n':
        print 'Log files will not be cleaned.'
        break
