#!sh/bin/
#for ((sub=1; sub<=31; sub++))
m=$1
for sub in ${m}
do
    remD=0
    if [ $sub -ne  9 ] && [ $sub -ne 13 ]
    then
        matlab -nodesktop -nosplash -r "RSA_neural_Searchlight($sub,$remD);quit;"
        #fsl_sub -q verylong.q matlab -nodesktop -nosplash -r "RSA_neural_Searchlight($sub,$remD);quit;"
    fi
done
