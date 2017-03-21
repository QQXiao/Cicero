#!/opt/fmritools/pylib/anaconda/bin/python
from os.path import join as opj
import os
import glob
import subprocess
import shutil
import time

basedir = '/seastor/helenhelen/Cicero'
#fsdir = '%s/FreeSurferResults'%(basedir)
#patterndir = '%s/pattern'%(basedir)
#anatdir = '%s/Anatomy_FS'%(patterndir)
#anatlpidir = '%s/orig_lpi'%(anatdir)
#bolddir = '%s/Bold_Data'%(patterndir)
transformdir = '%s/transforms'%(basedir)
a2sdir = '%s/anat2standard'%(transformdir)

# Check directory, remove useless dir in previous processing
#checklist = [patterndir,bolddir,transformdir]
#for cur_dir in list(checklist):
#    if os.path.exists(cur_dir) == False:
#        os.makedirs(cur_dir)
#checklist = [anatdir,anatlpidir,a2sdir]
#for cur_dir in list(checklist):
#    if os.path.exists(cur_dir) == True:
#        shutil.rmtree(cur_dir)
#        os.makedirs(cur_dir)
#    elif os.path.exists(cur_dir) == False:
#        os.makedirs(cur_dir)

# get subjects list
Subjlist = sorted(glob.glob('%s/MOL[0-9][0-9]'%(basedir)))
for cur_sub in list(Subjlist):
    iSub = cur_sub.split('/')[-1]
    anatdir='%s/data/anatomy'%(cur_sub)
    # convert anatomy data from freesurfer results
    # orig
    #infile = opj(fsdir,'FS_%s'%(iSub),'mri','orig.mgz')
    #outfile = opj(anatlpidir,'%s_orig.nii.gz'%(iSub))
    #subprocess.call('mri_convert %s %s'%(infile, outfile), shell=True)
    #outfile_ras = opj(anatdir,'%s_orig.nii.gz'%(iSub))
    #subprocess.call('fslreorient2std %s %s'%(outfile, outfile_ras),shell=True)
    # orig (brain)
    #infile = opj(fsdir,'FS_%s'%(iSub),'mri','brain.mgz')
    #outfile = opj(anatdir,'%s_orig_brain.nii.gz'%(iSub))
    #subprocess.call('mri_convert %s %s'%(infile, outfile), shell=True)
    #subprocess.call('fslreorient2std %s %s'%(outfile, outfile),shell=True)
    # parcels
    #infile = opj(fsdir,'FS_%s'%(iSub),'mri','aparc+aseg.mgz')
    #outfile = opj(anatdir,'%s_aparc+aseg.nii.gz'%(iSub))
    #subprocess.call('mri_convert %s %s'%(infile, outfile), shell=True)
    #subprocess.call('fslreorient2std %s %s'%(outfile, outfile),shell=True)
    # brain mask
    #infile = opj(fsdir,'FS_%s'%(iSub),'mri','brainmask.mgz')
    #outfile = opj(anatdir,'%s_brainmask.nii.gz'%(iSub))
    #subprocess.call('mri_convert %s %s'%(infile, outfile), shell=True)
    #subprocess.call('fslreorient2std %s %s'%(outfile, outfile),shell=True)

    # calculate anat to MNI152 template transform
    reffile = opj('/opt','fmritools','fsl','data','standard',
                       'MNI152_T1_2mm_brain.nii.gz')
    infile = opj(anatdir,'highres_brain.nii.gz')
    outprefix = opj(a2sdir,'%s_anat2standard_'%(iSub))
    outnifit = '%sWarped.nii.gz'%(outprefix)
    logdir = a2sdir
    logfile = 'anat2standard_%s'%(iSub)
    do_anat2standard = ('fsl_sub ' +
                        '-l %s '%(logdir) +
                        '-N %s '%(logfile) +
                        'antsRegistration ' +
                        '--dimensionality 3 ' +
                        '--float 0 ' +
                        '--output [%s,%s] '%(outprefix,outnifit) +
                        '--interpolation Linear ' +
                        '--winsorize-image-intensities [0.005,0.995] ' +
                        '--use-histogram-matching 0 ' +
                        '--initial-moving-transform [%s,%s,1] '%(reffile,infile) +
                        '--transform Rigid[0.1] ' +
                        '--metric MI[%s,%s,1,32,Regular,0.25] '%(reffile,infile) +
                        '--convergence [1000x500x250x100,1e-6,10] ' +
                        '--shrink-factors 8x4x2x1 ' +
                        '--smoothing-sigmas 3x2x1x0vox ' +
                        '--transform Affine[0.1] ' +
                        '--metric MI[%s,%s,1,32,Regular,0.25] '%(reffile,infile) +
                        '--convergence [1000x500x250x100,1e-6,10] ' +
                        '--shrink-factors 8x4x2x1 ' +
                        '--smoothing-sigmas 3x2x1x0vox ' +
                        '--transform SyN[0.1,3,0] ' +
                        '--metric CC[%s,%s,1,4] '%(reffile,infile) +
                        '--convergence [100x70x50x20,1e-6,10] ' +
                        '--shrink-factors 8x4x2x1 ' +
                        '--smoothing-sigmas 3x2x1x0vox')
    subprocess.call(do_anat2standard, shell=True)

# check status
while True:
    time.sleep(120)
    num = subprocess.check_output('qstat | grep anat2stand | wc -l',
                                  shell=True)
    if int(num[:-1]) == 0:
        break
# end
print 'All process should been done!'
