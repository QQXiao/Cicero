#!sh/bin/
    memD=0
    #matlab -nodesktop -nosplash -r "ps_across_roi($memD);quit;"
    fsl_sub -q short.q matlab -nodesktop -nosplash -r "ps_across_roi($memD);quit;"
