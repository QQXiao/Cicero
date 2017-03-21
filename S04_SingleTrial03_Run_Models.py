#!/opt/fmritools/pylib/anaconda/bin/python

import os
import glob
import time
import subprocess

# Set this to the directory all of the Sub### directories live in
basedir = '/seastor/helenhelen/Cicero'

# Set this to the directory where you'll dump all the fsf files
fsfdir = '%s/scripts/fsf/fsf'%(basedir)

# learning
fsf_files = sorted(glob.glob("%s/encoding_sub[1-9][0-9]_run[0-2].fsf"%(fsfdir)))
for fsf_file in list(fsf_files):
    os.system('feat %s'%(fsf_file))

# testing
fsf_files = sorted(glob.glob("%s/test_sub[1-9][0-9]_run[0-2].fsf"%(fsfdir)))
for fsf_file in list(fsf_files):
    os.system('feat %s'%(fsf_file))

# swm
#fsf_files = sorted(glob.glob("%s/swm_sub[0-9][0-9]_run[0-4].fsf"%(fsfdir)))
#for fsf_file in list(fsf_files):
#    os.system('feat %s'%(fsf_file))

# plocalizer
#fsf_files = sorted(glob.glob("%s/plocalizer_sub[0-9][0-9].fsf"%(fsfdir)))
#for fsf_file in list(fsf_files):
#    os.system('feat %s'%(fsf_file))

# plocalizer
#fsf_files = sorted(glob.glob("%s/ilocalizer_sub[0-9][0-9].fsf"%(fsfdir)))
#for fsf_file in list(fsf_files):
#    os.system('feat %s'%(fsf_file))


print 'All feat jobs has been done!\n'
