#!/sh/bin
basedir=/seastor/helenhelen/Cicero
refdir=$basedir/group/set_model/sub26_cope1.gfeat
resultdir=$basedir/pattern/Searchlight_RSM/standard_space/group
mkdir -p $resultdir
datadir=$basedir/pattern/Searchlight_RSM/standard_space/sub/rt
cd $datadir
for c in rt
do
#dirname=`echo $c|sed -e "s/.nii.gz//g"`
#prefix=`echo $dirname|cut -d "_" -f1-3`
ddir=${resultdir}/${c}
mkdir -p $ddir
cd $ddir
fslmerge -t allsub $datadir/${c}_sub*
mv allsub.nii.gz filtered_func_data.nii.gz
cp $refdir/mask.nii.gz .
cp $refdir/bg_image.nii.gz .
cp $refdir/design.* .
# run command
flameo --cope=filtered_func_data --mask=mask --dm=design.mat --tc=design.con --cs=design.grp --runmode=ols
# thresh
easythresh logdir/zstat1 mask 2.3 0.05 bg_image zstat1
easythresh logdir/zstat2 mask 2.3 0.05 bg_image zstat2
done #end c
