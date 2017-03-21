#!/opt/fmritools/pylib/anaconda/bin/python
from os.path import join as opj
import os
import glob
import shutil
import scipy.io as sio
import pandas as pd
import numpy as np
import itertools

basedir = '/seastor/helenhelen/Cicero'
behavdir = '/seastor/Projects/Cicero/exp-scripts'
#behavdir = '/seastor/zhifang/Project-Cicero/exp-scripts'
resultdir = '%s/Results'%(basedir)
# define subject list
SubjectList = sorted(glob.glob(opj(basedir,'MOL[0-9][0-9]')))

# loop for subjects
for cur_sub in SubjectList:
	iSub = cur_sub.split('/')[-1]
	isub = iSub.split('MOL')[1]
	cur_dir = opj(basedir,iSub,'behav','SingleTrial')
	if os.path.exists(cur_dir) == False:
		os.makedirs(cur_dir)

	# load behavior data
	moldir = opj(behavdir,'Mol/Results_scan')
	for iRun in (1,2):
		encodingfile = glob.glob(opj(moldir,'sub%s_encoding_run%s_[0-9]*.tsv'%(isub,iRun)))
		testfile = glob.glob(opj(moldir,'sub%s_testing_run%s_[0-9]*.tsv'%(isub,iRun)))
		encoding = pd.read_csv(encodingfile[0], sep='\t')
		test = pd.read_csv(testfile[0], sep='\t')
		#encoding_gabor = pd.read_csv(encodingfile[1], sep='\t')
		#test_gabor = pd.read_csv(testfile[1], sep='\t')
		#encoding
		filename = opj(cur_dir,'encoding_run%d_all.txt'%(iRun))
		onset=encoding.AOnset
		ev = pd.DataFrame({'Onset':onset.values,
                        'Duration':[2.0]*onset.shape[0],
                        'Weight':[1.0]*onset.shape[0]},
                        columns=['Onset','Duration','Weight'])
		ev.to_csv(filename, sep='\t', header=False, index=False,
			float_format='%.4f')
		##encoding gabor erro
		#filename = opj(cur_dir,'learning_run%d_err.txt'%(iRun))
		#wrong_file=encoding_gabor.loc[(encoding_gabor.Rightness=='wrong')]
		#onset=wrong_file.AOnset
		#ev = pd.DataFrame({'Onset':onset.values,
                #        'Duration':[2.0]*onset.shape[0],
                #        'Weight':[1.0]*onset.shape[0]},
                #        columns=['Onset','Duration','Weight'])
		#ev.to_csv(filename, sep='\t', header=False, index=False,
	#		float_format='%.4f')
		#test
		filename = opj(cur_dir,'test_run%d_all.txt'%(iRun))
		onset=test.AOnset
		ev = pd.DataFrame({'Onset':onset.values,
                        'Duration':[2.0]*onset.shape[0],
                        'Weight':[1.0]*onset.shape[0]},
                        columns=['Onset','Duration','Weight'])
		ev.to_csv(filename, sep='\t', header=False, index=False,
			float_format='%.4f')
		##test gabor erro
		#filename = opj(cur_dir,'test_run%d_err.txt'%(iRun))
		#wrong_file=test_gabor.loc[(test_gabor.Rightness=='wrong')]
		#onset=wrong_file.AOnset
		#ev = pd.DataFrame({'Onset':onset.values,
                #        'Duration':[2.0]*onset.shape[0],
                #        'Weight':[1.0]*onset.shape[0]},
                #        columns=['Onset','Duration','Weight'])
		#ev.to_csv(filename, sep='\t', header=False, index=False,
		#	float_format='%.4f')
	#
	localizerdir = opj(behavdir,'FuncLocalizer/Results')
	pfile = glob.glob(opj(localizerdir,'sub%s_localizer_perc*.tsv'%(isub)))
	ifile = glob.glob(opj(localizerdir,'sub%s_localizer_imag*.tsv'%(isub)))
	perc = pd.read_csv(pfile[0], sep='\t')
	imag = pd.read_csv(ifile[0], sep='\t')
	#perc
	filename = opj(cur_dir,'plocalizer_all.txt')
	onset=perc.AOnset
	ev = pd.DataFrame({'Onset':onset.values,
		'Duration':[2.0]*onset.shape[0],
		'Weight':[1.0]*onset.shape[0]},
		columns=['Onset','Duration','Weight'])
	ev.to_csv(filename, sep='\t', header=False, index=False,
		float_format='%.4f')
	#imag
	filename = opj(cur_dir,'ilocalizer_all.txt')
	onset=imag.AOnset
	ev = pd.DataFrame({'Onset':onset.values,
		'Duration':[2.0]*onset.shape[0],
		'Weight':[1.0]*onset.shape[0]},
		columns=['Onset','Duration','Weight'])
	ev.to_csv(filename, sep='\t', header=False, index=False,
		float_format='%.4f')

	#swm
	swmdir = opj(behavdir,'SpatialWM/Results_scan')
	for iRun in (1,2,3,4):
		swmfile = glob.glob(opj(swmdir,'sub%s_spatialwm_run%s*.tsv'%(isub,iRun)))
		swm = pd.read_csv(swmfile[0], sep='\t')
		#encoding
		filename = opj(cur_dir,'swm_run%d_all.txt'%(iRun))
		onset=swm.AOnset_DP
		ev = pd.DataFrame({'Onset':onset.values,
                        'Duration':[2.0]*onset.shape[0],
                        'Weight':[1.0]*onset.shape[0]},
                        columns=['Onset','Duration','Weight'])
		ev.to_csv(filename, sep='\t', header=False, index=False,
			float_format='%.4f')
		##encoding gabor erro

