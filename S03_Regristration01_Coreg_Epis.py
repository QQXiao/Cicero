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

# Check directories, remove useless dir in previous processing
#checklist = [patterndir,bolddir,transformdir]
#for cur_dir in list(checklist):
#    if os.path.exists(cur_dir) == False:
#        os.makedirs(cur_dir)
#checklist = [rawdir,refdir,e2refdir,aligndir]
#for cur_dir in list(checklist):
#    if os.path.exists(cur_dir) == True:
#        shutil.rmtree(cur_dir)
#        os.makedirs(cur_dir)
#    elif os.path.exists(cur_dir) == False:
#        os.makedirs(cur_dir)

# get feat dirs
feat_dir_encoding = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                         'mol_encoding_run[0-9].feat')))
feat_dir_retrieval = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                        'mol_test_run[0-9].feat')))
feat_dir_swm = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                        'swm_run[0-9].feat')))
feat_dir_plocalizer = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                          'plocalizer.feat')))
feat_dir_ilocalizer = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                          'ilocalizer.feat')))
feat_dirs = feat_dir_encoding + feat_dir_retrieval + feat_dir_swm + feat_dir_plocalizer + feat_dir_ilocalizer

# define reference run
refrun = 'mol_test_run1'

# part1
for cur_featdir in list(feat_dirs):
    splitdir = cur_featdir.split('/')
    iSub = splitdir[4]
    iRun  = splitdir[-1][:-5]
    print 'Processing %s %s ...'%(iSub, iRun)
    # example func for across run alignment
    src = opj(basedir,iSub,'analysis','%s.feat'%(iRun),'reg',
              'example_func.nii.gz')
    dst = opj(refdir,'%s_%s_example_func.nii.gz'%(iSub, iRun))
    subprocess.call('ln -s %s %s'%(src, dst), shell=True)
    # filtered_func_data for each run
    src = opj(basedir,iSub,'analysis','%s.feat'%(iRun),
              'filtered_func_data.nii.gz')
    dst = opj(rawdir,'%s_%s_native.nii.gz'%(iSub, iRun))
    subprocess.call('ln -s %s %s'%(src, dst), shell=True)

    # coregistration epi runs, use test1 as reference
    if iRun != refrun:
        invol = opj(refdir,'%s_%s_example_func.nii.gz'%(iSub, iRun))
        refvol = opj(refdir,'%s_mol_test_run1_example_func.nii.gz'%(iSub))
        #outprefix = '%s/%s_%s_2ref_'%(e2refdir,iSub,iRun)
        outprefix = opj(e2refdir,'%s_%s_2ref_'%(iSub, iRun))
        outnifit = '%sWarped.nii.gz'%(outprefix)
        logdir = e2refdir
        logfile = 'epi2refepi_%s_%s'%(iSub, iRun)
        # calculate each epi run to referance run (example_func)
        # generate affine transform matrix for later use
        do_epi2ref = ('fsl_sub -q veryshort.q ' +
                      '-l %s '%(logdir) +
                      '-N %s '%(logfile) +
                      'antsRegistration ' +
                      '--dimensionality 3 ' +
                      '--float 0 ' +
                      '--output [%s,%s] '%(outprefix,outnifit) +
                      '--interpolation Linear ' +
                      '--winsorize-image-intensities [0.005,0.995] ' +
                      '--use-histogram-matching 0 ' +
                      '--initial-moving-transform [%s,%s,1] '%(refvol,invol) +
                      '--transform Rigid[0.1] ' +
                      '--metric MI[%s,%s,1,32,Regular,0.25] '%(refvol,invol) +
                      '--convergence [1000x500x250x100,1e-6,10] ' +
                      '--shrink-factors 8x4x2x1 ' +
                      '--smoothing-sigmas 3x2x1x0vox ' +
                      '--transform Affine[0.1] ' +
                      '--metric MI[%s,%s,1,32,Regular,0.25] '%(refvol,invol) +
                      '--convergence [1000x500x250x100,1e-6,10] ' +
                      '--shrink-factors 8x4x2x1 ' +
                      '--smoothing-sigmas 3x2x1x0vox ')
        subprocess.call(do_epi2ref, shell=True)

# check status
while True:
    time.sleep(30)
    num = subprocess.check_output('qstat | grep epi2ref | wc -l',
                                  shell=True)
    if int(num[:-1]) == 0:
        break

# part2
for cur_featdir in list(feat_dirs):
    splitdir = cur_featdir.split('/')
    iSub = splitdir[4]
    iRun  = splitdir[-1][:-5]
    # apply transformation to each epi data, get aligned functional data
    if iRun != refrun:
        infile = opj(rawdir,'%s_%s_native.nii.gz'%(iSub, iRun))
        reffile = opj(refdir,'%s_mol_test_run1_example_func.nii.gz'%(iSub))
        outfile = opj(aligndir,'%s_%s_native.nii.gz'%(iSub, iRun))
        transmatrix = opj(e2refdir,'%s_%s_2ref_0GenericAffine.mat'%(iSub, iRun))
        logdir = e2refdir
        logfile = 'applytransform_%s_%s'%(iSub, iRun)
        apply_transform = ('fsl_sub -q veryshort.q ' +
                           '-l %s '%(logdir) +
                           '-N %s '%(logfile) +
                           'antsApplyTransforms ' +
                           '--dimensionality 3 ' +
                           '--input-image-type 3 ' +
                           '--input %s '%(infile) +
                           '--reference-image %s '%(reffile) +
                           '--output %s '%outfile +
                           '--transform %s '%(transmatrix) +
                           '--float 1')
        subprocess.call(apply_transform, shell=True)
    elif iRun == refrun:
        infile = opj(rawdir,'%s_%s_native.nii.gz'%(iSub, iRun))
        outfile = opj(aligndir,'%s_%s_native.nii.gz'%(iSub, iRun))
        shutil.copy2(infile, outfile)

# check status
while True:
    time.sleep(30)
    num = subprocess.check_output('qstat | grep applytrans | wc -l',
                                  shell=True)
    if int(num[:-1]) == 0:
        break
# end
print 'All process should been done!'
