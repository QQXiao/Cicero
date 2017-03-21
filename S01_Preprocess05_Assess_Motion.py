#!/usr/bin/python

import glob
import os
import sys
import subprocess

path = '/seastor/helenhelen/Cicero'

# get bold file names
bold_files_learning  = sorted(glob.glob('%s/MOL[0-9][0-9]/data/bold/learning_run[0-9].nii.gz'%(path)))
bold_files_test   = sorted(glob.glob('%s/MOL[0-9][0-9]/data/bold/test_run[0-9].nii.gz'%(path)))
bold_files_swm   = sorted(glob.glob('%s/MOL[0-9][0-9]/data/bold/swm_run[0-9].nii.gz'%(path)))
bold_files_localizer = sorted(glob.glob('%s/MOL[0-9][0-9]/data/localizer/localizer[0-9].nii.gz'%(path)))
bold_files = bold_files_learning + bold_files_test + bold_files_localizer + bold_files_swm

# I'm using a big html file to put all QA info together.  If you have other suggestions, let me know!
if os.path.exists('/seastor/helenhelen/Cicero/QA')==False:
    os.makedirs('%s/QA'%(path))
    
outhtml = '/seastor/helenhelen/Cicero/QA/bold_motion_QA.html'
out_bad_bold_list = '/seastor/helenhelen/Cicero/QA/Subs_lose_gt_40_vol_scrub.txt'

if os.path.isfile("%s"%(out_bad_bold_list))==True:
    os.system("rm %s"%(out_bad_bold_list))
if os.path.isfile("%s"%(outhtml))==True:
    os.system("rm %s"%(outhtml))

for cur_bold in list(bold_files):
    print(cur_bold)
    # Store directory name
    cur_dir = os.path.dirname(cur_bold)

    # strip off .nii.gz from file name (makes code below easier)
    cur_bold_no_nii = cur_bold[:-7]
    splitbold = cur_bold_no_nii.split('/')
    prefix = splitbold[-1]

    #  You can also use fslreorient2std BUT
    #  BUT BUT BUT DO NOT RUN THIS UNLESS YOUR DATA ACTUALLY NEED IT!
    #os.system("fslswapdim %s z -x -y %s_swapped"%(cur_bold_no_nii, cur_bold_no_nii))
    # Once you're confident this works correctly, you can change the above to
    #  overwrite bold.nii.gz (saves disc space)

    # This is used to trim off unwanted volumes
    # DO NOT USE THIS UNLESS YOU'VE DOUBLE CHECKED HOW MANY
    # VOLUMES NEED TO BE TRIMMED (IF ANY)
    # This trims first 2 and I set the max to a number far beyond
    # the number of TRs
    # Correct filename here to use output of previous step (if used)
    #os.system("fslroi %s %s_trimmed 2 300"%(cur_bold_no_nii, cur_bold_no_nii))
    # Once you're confident this works correctly, you can change the above to
    #   overwrite bold.nii.gz

    # Assessing motion.  This is what takes the longest
    # Check current literature to see if this thresh (0.9) is
    #  acceptable
    # I got it from here: http://www.ncbi.nlm.nih.gov/pubmed/23861343
    # Also, consider using FSL's FIX to clean your data
    if os.path.isdir("%s/motion_assess/"%(cur_dir))==False:
      os.system("mkdir %s/motion_assess"%(cur_dir))

    os.system("fsl_motion_outliers -i %s -o %s/motion_assess/%s_confound.txt --fd --thresh=0.6 -p %s/motion_assess/%s_fd_plot -v > %s/motion_assess/%s_outlier_output.txt"%(cur_bold_no_nii, cur_dir, prefix, cur_dir, prefix, cur_dir, prefix))

    # Put confound info into html file for review later on
    os.system("cat %s/motion_assess/%s_outlier_output.txt >> %s"%(cur_dir, prefix, outhtml))
    os.system("echo '<p>=============<p>FD plot %s <br><IMG BORDER=0 SRC=%s/motion_assess/%s_fd_plot.png WIDTH=100%s></BODY></HTML>' >> %s"%(cur_bold_no_nii, cur_dir, prefix, '%', outhtml))

    # Last, if we're planning on modeling out scrubbed volumes later
    #   it is helpful to create an empty file if confound.txt isn't
    #   generated (i.e. no scrubbing needed).  It is basically a
    #   place holder to make future scripting easier
    if os.path.isfile("%s/motion_assess/%s_confound.txt"%(cur_dir, prefix))==False:
      os.system("touch %s/motion_assess/%s_confound.txt"%(cur_dir, prefix))

    # Very last, create a list of subjects who exceed a threshold for
    #  number of scrubbed volumes.  This should be taken seriously.  If
    #  most of your scrubbed data are occurring during task, that's
    #  important to consider (e.g. subject with 20 volumes scrubbed
    #  during task is much worse off than subject with 20 volumes
    #  scrubbed during baseline.
    # These data have about 182 volumes and I'd hope to keep 140
    #  DO NOT USE 140 JUST BECAUSE I AM.  LOOK AT YOUR DATA AND
    #  COME TO AN AGREED VALUE WITH OTHER RESEARCHERS IN YOUR GROUP
    output = subprocess.check_output("grep -o 1 %s/motion_assess/%s_confound.txt | wc -l"%(cur_dir, prefix), shell=True)
    num_scrub = [int(s) for s in output.split() if s.isdigit()]
    if num_scrub[0]>40:
        with open(out_bad_bold_list, "a") as myfile:
          myfile.write("%s\n"%(cur_bold))
