#!/opt/fmritools/pylib/anaconda/bin/python
from os.path import join as opj
import os
import glob
import scipy.io as sio
import pandas as pd

basedir = '/seastor/helenhelen/Cicero'
designdir = '%s/scripts/fsf/design'%(basedir)
fsfdir = '%s/scripts/fsf/fsf'%(basedir)
outdir = '%s/singletrial'%(fsfdir)
# Check directory
#if os.path.exists(outdir)==False:
#    os.makedirs(outdir)
#os.system('rm %s/*.fsf'%(outdir))

# encoding
modellist = sorted(glob.glob(opj(basedir,'MOL[0-9][0-9]','behav',
                                 'SingleTrial',
                                 'encoding_run[1-2]_all.txt')))
for cur_model in list(modellist):
	iSub = cur_model.split('/')[4]
	isub = 'sub' +iSub.split('MOL')[1]
	irun = cur_model.split('/')[-1].split('_')[1]
	#irun = opj('run%d'%(iRun))
	replacements = {'sub09':isub,'run1':irun,'MOL09':iSub}
	# open template .fsf
	with open("%s/mol_encoding_design.fsf"%(designdir)) as infile:
        # open a new .fsf file
		with open("%s/encoding_%s_%s.fsf"%(fsfdir,isub,irun),'w') as outfile:
			for line in infile:
                		for src, target in replacements.iteritems():
                    			line = line.replace(src, target)
                		outfile.write(line)

# testing
modellist = sorted(glob.glob(opj(basedir,'MOL[0-9][0-9]','behav',
                                 'SingleTrial',
                                 'test_run[1-2]_all.txt')))
for cur_model in list(modellist):
	iSub = cur_model.split('/')[4]
	isub = 'sub' +iSub.split('MOL')[1]
	irun = cur_model.split('/')[-1].split('_')[1]
	#irun = opj('run%d'%(iRun))
	replacements = {'sub09':isub,'run1':irun,'MOL09':iSub}
	# open template .fsf
    	with open("%s/mol_test_design.fsf"%(designdir)) as infile:
        # open a new .fsf file
        	with open("%s/test_%s_%s.fsf"%(fsfdir,isub,irun),'w') as outfile:
            		for line in infile:
                		for src, target in replacements.iteritems():
                    			line = line.replace(src, target)
                		outfile.write(line)

# localizer
modellist = sorted(glob.glob(opj(basedir,'MOL[0-9][0-9]','behav',
                                 'SingleTrial',
                                 'plocalizer_all.txt')))
for cur_model in list(modellist):
	iSub = cur_model.split('/')[4]
	isub = 'sub' +iSub.split('MOL')[1]
	#irun = opj('run%d'%(iRun))
	replacements = {'sub01':isub,'MOL01':iSub}
	# open template .fsf
    	with open("%s/plocalizer_design.fsf"%(designdir)) as infile:
        # open a new .fsf file
        	with open("%s/plocalizer_%s.fsf"%(fsfdir,isub),'w') as outfile:
            		for line in infile:
                		for src, target in replacements.iteritems():
                    			line = line.replace(src, target)
				outfile.write(line)
# localizer
modellist = sorted(glob.glob(opj(basedir,'MOL[0-9][0-9]','behav',
                                 'SingleTrial',
                                 'ilocalizer_all.txt')))
for cur_model in list(modellist):
	iSub = cur_model.split('/')[4]
	isub = 'sub' +iSub.split('MOL')[1]
	#irun = opj('run%d'%(iRun))
	replacements = {'sub01':isub,'MOL01':iSub}
	# open template .fsf
    	with open("%s/ilocalizer_design.fsf"%(designdir)) as infile:
        # open a new .fsf file
        	with open("%s/ilocalizer_%s.fsf"%(fsfdir,isub),'w') as outfile:
            		for line in infile:
                		for src, target in replacements.iteritems():
                    			line = line.replace(src, target)
				outfile.write(line)
# swm
modellist = sorted(glob.glob(opj(basedir,'MOL[0-9][0-9]','behav',
                                 'SingleTrial',
                                 'swm_run[1-4]_all.txt')))
for cur_model in list(modellist):
	iSub = cur_model.split('/')[4]
	isub = 'sub' +iSub.split('MOL')[1]
	irun = cur_model.split('/')[-1].split('_')[1]
	#irun = opj('run%d'%(iRun))
	replacements = {'sub01':isub,'run1':irun,'MOL01':iSub}
	# open template .fsf
    	with open("%s/swm_design.fsf"%(designdir)) as infile:
        # open a new .fsf file
        	with open("%s/swm_%s_%s.fsf"%(fsfdir,isub,irun),'w') as outfile:
            		for line in infile:
                		for src, target in replacements.iteritems():
                    			line = line.replace(src, target)
				outfile.write(line)
