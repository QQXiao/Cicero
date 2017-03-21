function allsubs()
basedir='/seastor/helenhelen/Cicero';
datadir=sprintf('%s/pattern/ROI_based/ref_space/me/z',basedir);
resultdir=sprintf('%s/pattern/ROI_based/ref_space/me',basedir);
addpath /seastor/helenhelen/scripts/NIFTI

%get roi name
[roi_name]=gen_roi_name();

%subs=[1:31];
subs=setdiff([1:31],[9 13]);%lack of remembered items
%subs=setdiff([1:31],[9 11 13 28]);%lack of remembered items & no T2 for 11 and 28
s=subs';
for roi=1:length(roi_name)
ars_ln=[];ars_mem=[];ars_ERS=[];art_ERS=[];art_ln=[];art_mem=[];aitem_ERS=[];aact=[];
all_rs_ln=[];all_rs_mem=[];all_rs_ERS=[];all_rt_ERS=[];all_rt_ln=[];all_rt_mem=[];all_item_ERS=[];all_act=[];

    for sub=subs
        load(sprintf('%s/item_ERS_sub%02d',datadir,sub));
        load(sprintf('%s/rs_ln_sub%02d',datadir,sub));
        load(sprintf('%s/rs_mem_sub%02d',datadir,sub));
        load(sprintf('%s/rs_ERS_sub%02d',datadir,sub));
        load(sprintf('%s/rt_ERS_sub%02d',datadir,sub));
        load(sprintf('%s/rt_ln_sub%02d',datadir,sub));
        load(sprintf('%s/rt_mem_sub%02d',datadir,sub));
        load(sprintf('%s/act_sub%02d',datadir,sub));

         %all_item_ERS=[all_item_ERS;[sub*ones(60,1) [1:60]' squeeze(item_ERS_z(:,roi,:))]];
         %all_rs_ln=[all_rs_ln;[sub*ones(60,1) [1:60]' squeeze(rs_ln_z(:,roi,:)]];
         %all_rs_mem=[all_rs_mem;[sub*ones(60,1) [1:60]' squeeze(rs_mem_z(:,roi,:))]];
         %all_rs_ERS=[all_rs_ERS;[sub*ones(60,1) [1:60]' squeeze(rs_ERS_z(:,roi,:))]];
         %all_rt_ERS=[all_rt_ERS;[sub*ones(60,1) [1:60]' squeeze(rt_ERS_z(:,roi,:))]];
         %all_rt_ln=[all_rt_ln;[sub*ones(60,1) [1:60]' squeeze(rt_ln_z(:,roi,:))]];
         %all_rt_mem=[all_rt_mem;[sub*ones(60,1) [1:60]' squeeze(rt_mem_z(:,roi,:))]];
         all_item_ERS=[all_item_ERS;squeeze(item_ERS_z(:,roi,:))];
         all_rs_ln=[all_rs_ln;squeeze(rs_ln_z(:,roi,:))];
         all_rs_mem=[all_rs_mem;squeeze(rs_mem_z(:,roi,:))];
         all_rs_ERS=[all_rs_ERS;squeeze(rs_ERS_z(:,roi,:))];
         all_rt_ERS=[all_rt_ERS;squeeze(rt_ERS_z(:,roi,:))];
         all_rt_ln=[all_rt_ln;squeeze(rt_ln_z(:,roi,:))];
         all_rt_mem=[all_rt_mem;squeeze(rt_mem_z(:,roi,:))];

         all_act=[all_act;[sub*ones(60,1) [1:60]' squeeze(act(:,roi,:))]];
        end %end sub
        aitem_ERS=all_item_ERS;
        ars_ln=all_rs_ln;
        ars_mem=all_rs_mem;
        ars_ERS=all_rs_ERS;
        art_ERS=all_rt_ERS;
        art_ln=all_rt_ln;
        art_mem=all_rt_mem;
        aact=all_act;
    file_name=sprintf('%s/item_ERS_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s aitem_ERS -ascii',file_name));
    file_name=sprintf('%s/rs_ln_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s ars_ln -ascii',file_name));
    file_name=sprintf('%s/rs_mem_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s ars_mem -ascii',file_name));
    file_name=sprintf('%s/rs_ERS_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s ars_ERS -ascii',file_name));
    file_name=sprintf('%s/rt_ERS_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s art_ERS -ascii',file_name));
    file_name=sprintf('%s/rt_ln_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s art_ln -ascii',file_name));
    file_name=sprintf('%s/rt_mem_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s art_mem -ascii',file_name));
    file_name=sprintf('%s/act_%s.txt', resultdir,roi_name{roi});
    eval(sprintf('save %s aact -ascii',file_name));
end %end roi
end%end function
