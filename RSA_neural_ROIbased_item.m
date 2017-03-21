function RSA_neural_ROIbased_item(subs,remD)
%%%%%%%%%
%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
datadir=sprintf('%s/pattern/ROI_based/ref_space/raw',basedir);
zdir=sprintf('%s/pattern/ROI_based/ref_space/me/z',basedir);
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
%get fMRI data
for t=1:60
 %get index
[idx_item_ERS,idx_rs,...
 idx_rt_ERS,idx_rt_ln,idx_rt_mem...
 list_wid]...
=get_idx_item(subs,remD,t);
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
        %item-specific
        item_ERS(t,roi,1)=mean(cc(idx_item_ERS{1}));
        item_ERS(t,roi,2)=mean(cc(idx_item_ERS{2}));
        % spacital representation
        rs_ln(t,roi,1)=mean(cc(idx_rs{1,1,1}));%within run within loci
        rs_ln(t,roi,2)=mean(cc(idx_rs{1,1,2}));%within run between loci within same category
        rs_ln(t,roi,3)=mean(cc(idx_rs{1,2,1}));%between runs within loci
        rs_ln(t,roi,4)=mean(cc(idx_rs{1,2,2}));%between runs between loci within same category

        rs_mem(t,roi,1)=mean(cc(idx_rs{2,1,1}));%within run within loci
        rs_mem(t,roi,2)=mean(cc(idx_rs{2,1,2}));%within run between loci within same category
        rs_mem(t,roi,3)=mean(cc(idx_rs{2,2,1}));%between runs within loci
        rs_mem(t,roi,4)=mean(cc(idx_rs{2,2,2}));%between runs between loci within same category
        
        rs_ERS(t,roi,1)=mean(cc(idx_rs{3,1,1}));%within run within loci
        rs_ERS(t,roi,2)=mean(cc(idx_rs{3,1,2}));%within run between loci
        
        % temporal representation
        rt_ERS(t,roi,1)=mean(cc(idx_rt_ERS{1})); %sDE:10
        rt_ERS(t,roi,2)=mean(cc(idx_rt_ERS{2})); %lDE:20
        rt_ln(t,roi,1)=mean(cc(idx_rt_ln{1})); %sDE
        rt_ln(t,roi,2)=mean(cc(idx_rt_ln{2})); %lDE
        rt_mem(t,roi,1)=mean(cc(idx_rt_mem{1})); %sDE
        rt_mem(t,roi,2)=mean(cc(idx_rt_mem{2})); %lDE
                      
        % activity
        act(t,roi,1)=data_all(list_wid(1:60)==t);%encoding
        act(t,roi,2)=data_all(list_wid(61:end)==t);%retrieval
   end %end roi
    item_ERS_z=0.5*(log(1+item_ERS)-log(1-item_ERS));
    rs_ln_z=0.5*(log(1+rs_ln)-log(1-rs_ln));
    rs_mem_z=0.5*(log(1+rs_mem)-log(1-rs_mem));
    rs_ERS_z=0.5*(log(1+rs_ERS)-log(1-rs_ERS));
    rt_ERS_z=0.5*(log(1+rt_ERS)-log(1-rt_ERS));
    rt_ln_z=0.5*(log(1+rt_ln)-log(1-rt_ln));
    rt_mem_z=0.5*(log(1+rt_mem)-log(1-rt_mem));

eval(sprintf('save %s/item_ERS_sub%02d item_ERS_z', zdir, iSub));
eval(sprintf('save %s/rs_ln_sub%02d rs_ln_z', zdir, iSub));
eval(sprintf('save %s/rs_mem_sub%02d rs_mem_z', zdir, iSub));
eval(sprintf('save %s/rs_ERS_sub%02d rs_ERS_z', zdir, iSub));
eval(sprintf('save %s/rt_ERS_sub%02d rt_ERS_z', zdir, iSub));
eval(sprintf('save %s/rt_ln_sub%02d rt_ln_z', zdir, iSub));
eval(sprintf('save %s/rt_mem_sub%02d rt_mem_z', zdir, iSub));
eval(sprintf('save %s/act_sub%02d act', zdir, iSub));
end %end func
