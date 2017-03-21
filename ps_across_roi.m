function RSA_neural_ROIbased(remD)
%%%%%%%%%
%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
datadir=sprintf('%s/pattern/ROI_based/ref_space/raw',basedir);
zdir=sprintf('%s/pattern/ROI_based/ref_space/across_roi',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero

% basedir='/Users/xiaoqian/Documents/experiment/Cicero';
% behavdir=sprintf('%s/exp-scripts/Mol/Results_scan',basedir);
% datadir=sprintf('%s/data/pattern/ROI_based/ref_space/raw',basedir);
% addpath /Users/xiaoqian/Documents/experiment/Cicero/scripts/pattern
%%%%%%%%%
% subs=1;remD=0;
subs=setdiff(1:31,[1,11,13,28]);
%get roi name
[ch_roi_name,c_roi_name,s_roi_name]=gen_roi_name();
roi_name=s_roi_name;

%%
for iSub=subs;
    %%
    %get index
    [idx_item_ERS,idx_rs,...
    idx_rt_ERS,idx_rt_ln,idx_rt_mem,idx_rt]...
    =get_idx(iSub,remD);
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
        %item-specific
        item_ERS{roi,1}=cc(idx_item_ERS{1});
        item_ERS{roi,2}=cc(idx_item_ERS{2});
        % spacital representation
        rs_ln{roi,1}=cc(idx_rs{1,1,1});%within run within loci
        rs_ln{roi,2}=cc(idx_rs{1,1,2});%within run between loci within same category
        rs_ln{roi,3}=cc(idx_rs{1,2,1});%between runs within loci
        rs_ln{roi,4}=cc(idx_rs{1,2,2});%between runs between loci within same category

        rs_mem{roi,1}=cc(idx_rs{2,1,1});%within run within loci
        rs_mem{roi,2}=cc(idx_rs{2,1,2});%within run between loci within same category
        rs_mem{roi,3}=cc(idx_rs{2,2,1});%between runs within loci
        rs_mem{roi,4}=cc(idx_rs{2,2,2});%between runs between loci within same category

        rs_ERS{roi,1}=cc(idx_rs{3,1,1});%within run within loci
        rs_ERS{roi,2}=cc(idx_rs{3,1,2});%within run between loci

        % temporal representation
        rt_ERS{roi,1}=cc(idx_rt_ERS{1}); %sDE:10
        rt_ERS{roi,2}=cc(idx_rt_ERS{2}); %lDE:20
        rt_ln{roi,1}=cc(idx_rt_ln{1}); %sDE
        rt_ln{roi,2}=cc(idx_rt_ln{2}); %lDE
        rt_mem{roi,1}=cc(idx_rt_mem{1}); %sDE
        rt_mem{roi,2}=cc(idx_rt_mem{2}); %lDE
        rt{roi,1}=cc(idx_rt{1}); %sDE
        rt{roi,2}=cc(idx_rt{2}); %lDE
    end %end roi
    cc_across_roi_item_ERS(iSub,1,:)=1-pdist(cell2mat(item_ERS(:,1)),'correlation');
    cc_across_roi_item_ERS(iSub,2,:)=1-pdist(cell2mat(item_ERS(:,2)),'correlation');

    cc_across_roi_rs_ln(iSub,1,:)=1-pdist(cell2mat(rs_ln(:,1)),'correlation');
    cc_across_roi_rs_ln(iSub,2,:)=1-pdist(cell2mat(rs_ln(:,2)),'correlation');
    cc_across_roi_rs_ln(iSub,3,:)=1-pdist(cell2mat(rs_ln(:,3)),'correlation');
    cc_across_roi_rs_ln(iSub,4,:)=1-pdist(cell2mat(rs_ln(:,4)),'correlation');

    cc_across_roi_rs_mem(iSub,1,:)=1-pdist(cell2mat(rs_mem(:,1)),'correlation');
    cc_across_roi_rs_mem(iSub,2,:)=1-pdist(cell2mat(rs_mem(:,2)),'correlation');
    cc_across_roi_rs_mem(iSub,3,:)=1-pdist(cell2mat(rs_mem(:,3)),'correlation');
    cc_across_roi_rs_mem(iSub,4,:)=1-pdist(cell2mat(rs_mem(:,4)),'correlation');

    cc_across_roi_rs_ERS(iSub,1,:)=1-pdist(cell2mat(rs_ERS(:,1)),'correlation');
    cc_across_roi_rs_ERS(iSub,2,:)=1-pdist(cell2mat(rs_ERS(:,2)),'correlation');

    cc_across_roi_rt_ln(iSub,1,:)=1-pdist(cell2mat(rt_ln(:,1)),'correlation');
    cc_across_roi_rt_ln(iSub,2,:)=1-pdist(cell2mat(rt_ln(:,2)),'correlation');

    cc_across_roi_rt_mem(iSub,1,:)=1-pdist(cell2mat(rt_mem(:,1)),'correlation');
    cc_across_roi_rt_mem(iSub,2,:)=1-pdist(cell2mat(rt_mem(:,2)),'correlation');

    cc_across_roi_rt_ERS(iSub,1,:)=1-pdist(cell2mat(rt_ERS(:,1)),'correlation');
    cc_across_roi_rt_ERS(iSub,2,:)=1-pdist(cell2mat(rt_ERS(:,2)),'correlation');
    cc_across_roi_rt(iSub,1,:)=1-pdist(cell2mat(rt(:,1)),'correlation');
    cc_across_roi_rt(iSub,2,:)=1-pdist(cell2mat(rt(:,2)),'correlation');
end %end sub
    item_ERS_z=0.5*(log(1+cc_across_roi_item_ERS)-log(1-cc_across_roi_item_ERS));
    rs_ln_z=0.5*(log(1+cc_across_roi_rs_ln)-log(1-cc_across_roi_rs_ln));
    rs_mem_z=0.5*(log(1+cc_across_roi_rs_mem)-log(1-cc_across_roi_rs_mem));
    rs_ERS_z=0.5*(log(1+cc_across_roi_rs_ERS)-log(1-cc_across_roi_rs_ERS));

    rt_ln_z=0.5*(log(1+cc_across_roi_rt_ln)-log(1-cc_across_roi_rt_ln));
    rt_mem_z=0.5*(log(1+cc_across_roi_rt_mem)-log(1-cc_across_roi_rt_mem));
    rt_ERS_z=0.5*(log(1+cc_across_roi_rt_ERS)-log(1-cc_across_roi_rt_ERS));
    rt_z=0.5*(log(1+cc_across_roi_rt)-log(1-cc_across_roi_rt));

    item_ERS_wi=squeeze(item_ERS_z(:,1,:));
    item_ERS_bi=squeeze(item_ERS_z(:,2,:));
    rs_ERS_wl=squeeze(rs_ERS_z(:,1,:));
    rs_ERS_bl=squeeze(rs_ERS_z(:,2,:));
    rs_ln_wl_wr=squeeze(rs_ln_z(:,1,:));
    rs_ln_bl_wr=squeeze(rs_ln_z(:,2,:));
    rs_ln_wl_br=squeeze(rs_ln_z(:,3,:));
    rs_ln_bl_br=squeeze(rs_ln_z(:,4,:));
    rs_mem_wl_wr=squeeze(rs_mem_z(:,1,:));
    rs_mem_bl_wr=squeeze(rs_mem_z(:,2,:));
    rs_mem_wl_br=squeeze(rs_mem_z(:,3,:));
    rs_mem_bl_br=squeeze(rs_mem_z(:,4,:));
    rt_ERS_sed=squeeze(rt_ERS_z(:,1,:));
    rt_ERS_led=squeeze(rt_ERS_z(:,2,:));
    rt_ln_sed=squeeze(rt_ln_z(:,1,:));
    rt_ln_led=squeeze(rt_ln_z(:,2,:));
    rt_mem_sed=squeeze(rt_mem_z(:,1,:));
    rt_mem_led=squeeze(rt_mem_z(:,2,:));
    rt_s=squeeze(rt_z(:,1,:));
    rt_l=squeeze(rt_z(:,2,:));

eval(sprintf('save %s/item_ERS_wi.txt item_ERS_wi -ascii', zdir));
eval(sprintf('save %s/item_ERS_bi.txt item_ERS_bi -ascii', zdir));
eval(sprintf('save %s/rs_ERS_wl.txt rs_ERS_wl -ascii', zdir));
eval(sprintf('save %s/rs_ERS_bl.txt rs_ERS_bl -ascii', zdir));
eval(sprintf('save %s/rs_ln_wl_wr.txt rs_ln_wl_wr -ascii', zdir));
eval(sprintf('save %s/rs_ln_bl_wr.txt rs_ln_bl_wr -ascii', zdir));
eval(sprintf('save %s/rs_ln_wl_br.txt rs_ln_wl_br -ascii', zdir));
eval(sprintf('save %s/rs_ln_bl_br.txt rs_ln_bl_br -ascii', zdir));
eval(sprintf('save %s/rs_mem_wl_wr.txt rs_mem_wl_wr -ascii', zdir));
eval(sprintf('save %s/rs_mem_bl_wr.txt rs_mem_bl_wr -ascii', zdir));
eval(sprintf('save %s/rs_mem_wl_br.txt rs_mem_wl_br -ascii', zdir));
eval(sprintf('save %s/rs_mem_bl_br.txt rs_mem_bl_br -ascii', zdir));
eval(sprintf('save %s/rt_ERS_sed.txt rt_ERS_sed -ascii', zdir));
eval(sprintf('save %s/rt_ERS_led.txt rt_ERS_led -ascii', zdir));
eval(sprintf('save %s/rt_ln_sed.txt rt_ln_sed -ascii', zdir));
eval(sprintf('save %s/rt_ln_led.txt rt_ln_led -ascii', zdir));
eval(sprintf('save %s/rt_mem_sed.txt rt_mem_sed -ascii', zdir));
eval(sprintf('save %s/rt_mem_led.txt rt_mem_led -ascii', zdir));
eval(sprintf('save %s/rt_s.txt rt_s -ascii', zdir));
eval(sprintf('save %s/rt_l.txt rt_l -ascii', zdir));
end %end func
