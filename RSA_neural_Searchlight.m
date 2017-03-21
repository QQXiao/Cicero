function RSA_neural_Searchlight(subs,remD)
%%%%%%%%%
xlength =  124;
ylength =  124;
zlength =  90;
radius  =  2;     % the cubic size is (2*radius+1) by (2*radius+1) by (2*radius+1)
step    =  1;     % compute accuracy map for every STEP voxels in each dimension
epsilon =  1e-6;
TTN=30*4;
%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
behavdir='/seastor/Projects/Cicero/exp-scripts/Mol/Results_scan';
datadir=sprintf('%s/pattern/singleTrial_Tmap/all',basedir);
rdir=sprintf('%s/pattern/Searchlight_RSM/ref_space/r',basedir);
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero
%%%%%%%%%
% subs=1;remD=0;
iSub=subs;
%get roi name
[ch_roi_name,c_roi_name,s_roi_name]=gen_roi_name();
if subs==11 || subs==28;
    roi_name=c_roi_name;
else
    roi_name=ch_roi_name;
end

clear ori_data;
%%%%%%%%%
item_ERS=zeros(xlength,ylength,zlength,2);
rs_ln=zeros(xlength,ylength,zlength,4);
rs_mem=zeros(xlength,ylength,zlength,4);
rs_ERS=zeros(xlength,ylength,zlength,2);
rt_ERS=zeros(xlength,ylength,zlength,2);
rt_ln=zeros(xlength,ylength,zlength,2);
rt_mem=zeros(xlength,ylength,zlength,2);
rt=zeros(xlength,ylength,zlength,2);
%%%%%%%%%

%get index
[idx_item_ERS,idx_rs,...
idx_rt_ERS,idx_rt_ln,idx_rt_mem,idx_rt]...
=get_idx(subs,remD);
%get fMRI data
data_file=sprintf('%s/sub%02d.nii.gz',datadir,iSub);
data_all=load_nii_zip(data_file);
ori_data=load_nii_zip(data_file);
data=data_all.img;
for k=radius+1:step:xlength-radius
    for j=radius+1:step:ylength-radius
        for i=radius+1:step:zlength-radius
            data_ball = data(k-radius:k+radius,j-radius:j+radius,i-radius:i+radius,:); % define small cubic for memory data
            a=size(data_ball);
            b=a(1)*a(2)*a(3);
            u=[];
            v_data = reshape(data_ball,b,TTN);
            u=sum(v_data==0)/TTN;
            if sum(std(v_data(:,:))==0)>epsilon | u>=0.125
                rs_ln(k,j,i,:)=10;
                rs_mem(k,j,i,:)=10;
                rs_ERS(k,j,i,:)=10;
                md_ln(k,j,i,:)=10;
                md_ERS(k,j,i,:)=10;
                rt_ERS(k,j,i,:)=10;
            else
                xx=v_data';
                data_all=xx;
                %%analysis
                cc=1-pdist(data_all(:,:),'correlation');

                %item-specific
                item_ERS(k,j,i,1)=mean(cc(idx_item_ERS{1}));
                item_ERS(k,j,i,2)=mean(cc(idx_item_ERS{2}));
                % spacital representation
                rs_ln(k,j,i,1)=mean(cc(idx_rs{1,1,1}));%within run within loci
                rs_ln(k,j,i,2)=mean(cc(idx_rs{1,1,2}));%within run between loci within same category
                rs_ln(k,j,i,3)=mean(cc(idx_rs{1,2,1}));%between runs within loci
                rs_ln(k,j,i,4)=mean(cc(idx_rs{1,2,2}));%between runs between loci within same category

                rs_mem(k,j,i,1)=mean(cc(idx_rs{2,1,1}));%within run within loci
                rs_mem(k,j,i,2)=mean(cc(idx_rs{2,1,2}));%within run between loci within same category
                rs_mem(k,j,i,3)=mean(cc(idx_rs{2,2,1}));%between runs within loci
                rs_mem(k,j,i,4)=mean(cc(idx_rs{2,2,2}));%between runs between loci within same category

                rs_ERS(k,j,i,1)=mean(cc(idx_rs{3,1,1}));%within run within loci
                rs_ERS(k,j,i,2)=mean(cc(idx_rs{3,1,2}));%within run between loci

                % temporal representation
                rt_ERS(k,j,i,1)=mean(cc(idx_rt_ERS{1})); %sDE:10
                rt_ERS(k,j,i,2)=mean(cc(idx_rt_ERS{2})); %lDE:20
                rt_ln(k,j,i,1)=mean(cc(idx_rt_ln{1})); %sDE
                rt_ln(k,j,i,2)=mean(cc(idx_rt_ln{2})); %lDE
                rt_mem(k,j,i,1)=mean(cc(idx_rt_mem{1})); %sDE
                rt_mem(k,j,i,2)=mean(cc(idx_rt_mem{2})); %lDE

                rt(k,j,i,1)=mean(cc(idx_rt{1}));
                rt(k,j,i,2)=mean(cc(idx_rt{2}));
            end %end if
        end %end i
    end %end j
end %end k
cd (rdir)
filename=sprintf('item_ERS_sub%02d.nii',iSub);
ori_data.img=squeeze(item_ERS(:,:,:,:));
ori_data.hdr.dime.dim(5)=2; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('rs_ln_sub%02d.nii',iSub);
ori_data.img=squeeze(rs_ln(:,:,:,:));
ori_data.hdr.dime.dim(5)=4; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('rs_mem_sub%02d.nii',iSub);
ori_data.img=squeeze(rs_mem(:,:,:,:));
ori_data.hdr.dime.dim(5)=4; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('rs_ERS_sub%02d.nii',iSub);
ori_data.img=squeeze(rs_ERS(:,:,:,:));
ori_data.hdr.dime.dim(5)=2; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('rt_ERS_sub%02d.nii',iSub);
ori_data.img=squeeze(rt_ERS(:,:,:,:));
ori_data.hdr.dime.dim(5)=2; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('rt_ln_sub%02d.nii',iSub);
ori_data.img=squeeze(rt_ln(:,:,:,:));
ori_data.hdr.dime.dim(5)=2; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('rt_mem_sub%02d.nii',iSub);
ori_data.img=squeeze(rt_mem(:,:,:,:));
ori_data.hdr.dime.dim(5)=2; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));

filename=sprintf('rt_sub%02d.nii',iSub);
ori_data.img=squeeze(rt(:,:,:,:));
ori_data.hdr.dime.dim(5)=2; % dimension chagne to 6
save_untouch_nii(ori_data, filename);
system(sprintf('gzip -f %s',filename));
end %end func
