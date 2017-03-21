function RSA_neural_ROIbased_subjectiveRS_ERS(subs,remD)
%%%%%%%%%
TTN=30*4; %total trial number: 30 in each encoding/retrieval run; 4 runs in total
%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
behavdir='/seastor/Projects/Cicero/exp-scripts/Mol/Results_scan';
datadir=sprintf('%s/pattern/ROI_based/ref_space/raw',basedir);
zdir=sprintf('%s/pattern/ROI_based/ref_space/z',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero

% basedir='/Users/xiaoqian/Documents/experiment/Cicero';
% behavdir=sprintf('%s/exp-scripts/Mol/Results_scan',basedir);
% datadir=sprintf('%s/data/pattern/ROI_based/ref_space/raw',basedir);
% addpath /Users/xiaoqian/Documents/experiment/Cicero/scripts/pattern
%%%%%%%%%
% subs~=4,9,13,15,28
iSub=subs;
%get roi name
[roi_name]=gen_roi_name();
%get index
[idx_item_ERS,idx_rs,...
idx_rt_ERS,idx_rt_ln]...
=get_idx(subs,remD);
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
        
        rs_ERS(roi,1)=mean(cc(idx_rs{3,1,1}));%within run within loci
        rs_ERS(roi,2)=mean(cc(idx_rs{3,1,2}));%within run between loci
        rs_ERS(roi,3)=mean(cc(idx_rs{3,1,3}));%within run within loci Report within loci
   end %end roi
    rs_ERS_z=0.5*(log(1+rs_ERS)-log(1-rs_ERS));
eval(sprintf('save %s/rs_subjective_ERS_sub%02d rs_ERS_z', zdir, iSub));
end %end func
