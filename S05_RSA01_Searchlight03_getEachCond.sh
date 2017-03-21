#substar=$1
#subend=$2
#for ((sub = $substar; sub <= $subend; sub++))
for ((sub = 1; sub <= 31; sub++))
#for sub in 1 2 4 5
do
    matlab -nodesktop -nosplash -r "get_each_cond($sub);quit;"
#fsl_sub matlab -nodesktop -nosplash -r "get_each_cond($sub);quit;"
done
