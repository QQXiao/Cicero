#!sh/bin/
for ((sub=1; sub<=31; sub++))
#for sub in 23
#for sub in 3 17 23 26
do
    memD=0
    matlab -nodesktop -nosplash -r "RSA_neural_ROIbased($sub,$memD);quit;"
    #fsl_sub -q short.q matlab -nodesktop -nosplash -r "RSA_neural_ROIbased($sub,$memD);quit;"
done
#for ((sub=1; sub<=31; sub++))
#do
#    memD=0
#    if [ $sub -ne 3 ] && [ $sub -ne 7 ] && [ $sub -ne 9 ] && [ $sub -ne 13 ] && [ $sub -ne 15 ] && [ $sub -ne 22 ] && [ $sub -ne 28 ] && [ $sub -ne 30 ];
#    then
#        fsl_sub -q short.q matlab -nodesktop -nosplash -r "RSA_neural_ROIbased_sme24($sub,$memD);quit;"
#    fi
    #if [ $sub -ne 6 ] && [ $sub -ne 7 ] && [ $sub -ne 9 ] && [ $sub -ne 13 ] && [ $sub -ne 10 ] && [ $sub -ne 11 ] && [ $sub -ne 14 ] && [ $sub -ne 26 ] && [ $sub -ne 27 ] && [ $sub -ne 22 ] && [ $sub -ne 30 ] ;
    #then
    #    fsl_sub -q short.q matlab -nodesktop -nosplash -r "RSA_neural_ROIbased_sme34($sub,$memD);quit;"
    #fi
    #if [ $sub -ne 7 ] && [ $sub -ne 9 ] && [ $sub -ne 13 ] && [ $sub -ne 22 ] && [ $sub -ne 30 ];
    #then
    #    fsl_sub -q short.q matlab -nodesktop -nosplash -r "RSA_neural_ROIbased_sme14($sub,$memD);quit;"
    #fi
#done
#for ((sub=1; sub<=31; sub++))
#do
#    if [ $sub = 1 ] || [ $sub = 2 ] || [ $sub = 4 ] || [ $sub = 5 ];
#    then
#        fsl_sub -q short.q matlab -nodesktop -nosplash -r "RSA_neural_ROIbased_First4($sub);quit;"
#    else
#        fsl_sub -q short.q matlab -nodesktop -nosplash -r "RSA_neural_ROIbased($sub);quit;"
#    fi
#done
