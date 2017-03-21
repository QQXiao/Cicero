#!/opt/fmritools/pylib/anaconda/bin/python
from os.path import join as opj
import os
import glob
import subprocess
import shutil
import time

basedir = '/seastor/helenhelen/Cicero'
scriptdir = '/home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero'
logdir = '%s/scripts'%(basedir)

encoding_list = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                     'mol_encoding_run[1-2].feat')))
test_list = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
                                     'mol_test_run[1-2].feat')))
#encoding_list = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
#                                     'mol_encoding_run[1-2].feat')))
#test_list = sorted(glob.glob(opj(basedir,'MOL[1-9][0-9]','analysis',
#                                     'mol_test_run[1-2].feat')))

# learning
for cur_feat in encoding_list:
    iSub = cur_feat.split('/')[4]
    iRun = cur_feat.split('/')[-1].split('.')[0]

    logfile = '%s_en%s'%(iSub,iRun[-1])

    do_lss = ('fsl_sub -q veryshort.q ' +
              '-l %s '%(logdir) +
              '-N %s '%(logfile) +
              'python '
              '%s/H02_Calculate_SingleTrial_BetaSeries.py '%(scriptdir) +
              '--fsldir \'%s\' '%(cur_feat) +
              '--whichevs 1 ' +
              '--numorigev 2 ' +
              '--motpars 1 ' +
              '-tempderiv ' +
              '-lss'
              )
    subprocess.call(do_lss, shell=True)

# test
for cur_feat in test_list:
    iSub = cur_feat.split('/')[4]
    iRun = cur_feat.split('/')[-1].split('.')[0]

    logfile = '%s_te%s'%(iSub,iRun[-1])

    do_lss = ('fsl_sub -q short.q ' +
              '-l %s '%(logdir) +
              '-N %s '%(logfile) +
              'python '
              '%s/H02_Calculate_SingleTrial_BetaSeries.py '%(scriptdir) +
              '--fsldir \'%s\' '%(cur_feat) +
              '--whichevs 1 ' +
              '--numorigev 2 ' +
              '--motpars 1 ' +
              '-tempderiv ' +
              '-lss'
              )
    subprocess.call(do_lss, shell=True)

# check status
while True:
    time.sleep(60)
    num = subprocess.check_output('qstat | grep Sub | wc -l',
                                  shell=True)
    if int(num[:-1]) == 0:
        break

# check files
featlist = encoding_list + test_list
for cur_feat in featlist:
    if not os.path.isfile('%s/betaseries/ev1_lss_tmap.nii.gz'%(cur_feat)):
        print '%s/betaseries/ev1_lss_tmap.nii.gz Not Found!'%(cur_feat)
    if not os.path.isfile('%s/betaseries/ev1_lss_tmap.nii.gz'%(cur_feat)):
        print '%s/betaseries/ev1_lss_betas_normalized.nii.gz Not Found!'%(cur_feat)
    if not os.path.isfile('%s/betaseries/ev1_lss_tmap.nii.gz'%(cur_feat)):
        print '%s/betaseries/ev1_lss.nii.gz Not Found!'%(cur_feat)

while 1:
    res = raw_input('Clean up log files? y/n\n')
    if res == 'y':
        junklist = sorted(glob.glob('%s/MOL[0-9][0-9]_*.*'%(logdir)))
        for junk in list(junklist):
            os.remove(junk)
        print 'Log files has been cleaned.'
        break
    elif res == 'n':
        print 'Log files will not be cleaned.'
        break

print 'All process should been done!'
