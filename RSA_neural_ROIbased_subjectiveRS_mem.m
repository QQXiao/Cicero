function RSA_neural_ROIbased(subs,remD)
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
% subs=1;remD=0;
iSub=subs;
%sub~=1,3,4,5,9,13,14,15,17,18,27,28,31
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
        % spacital representation
        rs_mem(roi,1)=mean(cc(idx_rs{2,1,1}));%within run within loci
        rs_mem(roi,2)=mean(cc(idx_rs{2,1,2}));%within run between loci within same category
        rs_mem(roi,3)=mean(cc(idx_rs{2,1,3}));%within run within loci Report within loci
        rs_mem(roi,4)=mean(cc(idx_rs{2,2,1}));%between runs within loci 
        rs_mem(roi,5)=mean(cc(idx_rs{2,2,2}));%between runs between loci within same category
        rs_mem(roi,6)=mean(cc(idx_rs{2,2,3}));%between runs within loci Report within loci
   end %end roi
    rs_mem_z=0.5*(log(1+rs_mem)-log(1-rs_mem));

eval(sprintf('save %s/rs_subjective_mem_sub%02d rs_mem_z', zdir, iSub));
end %end func
