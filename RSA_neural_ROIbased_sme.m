function RSA_neural_ROIbased_sme(subs,remD)
%%%%%%%%%
%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
datadir=sprintf('%s/pattern/ROI_based/ref_space/raw',basedir);
zdir=sprintf('%s/pattern/ROI_based/ref_space/z',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero

% basedir='/Users/xiaoqian/Documents/experiment/Cicero';
% behavdir=sprintf('%s/exp-scripts/Mol/Results_scan',basedir);
% datadir=sprintf('%s/data/pattern/ROI_based/ref_space/raw',basedir);
% addpath /Users/xiaoqian/Documents/experiment/Cicero/scripts/pattern
%%%%%%%%%
% subs=1;remD=0;
iSub=subs;
%get roi name
[roi_name]=gen_roi_name();
%get index
[idx_sme]=get_idx_sme(subs,remD);
%get fMRI data
    for roi=1:length(roi_name);
        txx=[];xx=[];tmp_xx=[];u=[];
        tmp_xx=load(sprintf('%s/sub%02d_%s.txt',datadir,iSub,roi_name{roi}));
        txx=tmp_xx(4:end,:);
        size_all=size(txx,2);
        for j=1:size_all
            a=txx(:,j);
            ta=a';
            b = diff([0 a'==0 0]);
            res = find(b==-1) - find(b==1);
            u(j)=sum(res>=6);
        end
        txx(:,find(u>=1))=[];
        xx=txx;
        data_all=xx;
    %%analysis
        cc=1-pdist(data_all(:,:),'correlation');
        rs_SME_ERS(roi,1)=mean(cc(idx_sme{3,1,1,1}));%hit wl
        rs_SME_ERS(roi,2)=mean(cc(idx_sme{3,1,1,2}));%hit bl
        rs_SME_ERS(roi,3)=mean(cc(idx_sme{3,1,2,1}));%same loci wl
        rs_SME_ERS(roi,4)=mean(cc(idx_sme{3,1,2,2}));%same loc bl
        rs_SME_ERS(roi,5)=mean(cc(idx_sme{3,1,3,1}));%dis1 wl
        rs_SME_ERS(roi,6)=mean(cc(idx_sme{3,1,3,2}));%dis2 bl
        rs_SME_ERS(roi,7)=mean(cc(idx_sme{3,1,4,1}));%wrong wl
        rs_SME_ERS(roi,8)=mean(cc(idx_sme{3,1,4,2}));%wrong bl
   end %end roi
    rs_SME_ERS_z=0.5*(log(1+rs_SME_ERS)-log(1-rs_SME_ERS));

eval(sprintf('save %s/rs_SME_ERS_sub%02d rs_SME_ERS_z', zdir, iSub));
end %end func
