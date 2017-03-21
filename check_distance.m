function RSA_neural(subs)
%subs=1;
%%%%%%%%%
TTN=30*4
%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
behavdir='/seastor/Projects/Cicero/exp-scripts/Mol/Results_scan';
%behavdir='/seastor/zhifang/Project-Cicero/exp-scripts/Mol/Results_scan';
addpath /seastor/helenhelen/scripts/NIFTI
%%%%%%%%%
all_dis=[];
first_sub=[1 2 4 5];
subs=[1:31]
d=[0:1:31];
for i=1:length(subs);
    iSub=subs(i);
% load testing data
    data_test=[];
    for iRun = 1:2
        test_filename = ls(sprintf('%s/sub%02d_testing_run%d*.mat',behavdir,iSub,iRun));
        eval(sprintf('load %s',test_filename));
        data_test=[data_test;AllTrialInfos];
        behav_run=AllTrialInfos;
        if i~=first_sub
        behav_run.Distance(strcmp(behav_run.Distance,{'not sure'}))={'30'};
        behav_run.Distance(strcmp(behav_run.Distance,{'n/a'}))={'31'};
        dis_run=str2double(behav_run.Distance);
        else
        behav_run.Distance(strcmp(behav_run.Distance,{'Not sure'}))={30};
        behav_run.Distance(strcmp(behav_run.Distance,{'n/a'}))={31};
        dis_run=cell2mat(behav_run.Distance);
        end
        for id=1:length(d);
            c_dis_run(iSub,id,iRun)=sum(dis_run==d(id));
        end
    end %end run
    behav=data_test;
    if i~=first_sub
    behav.Distance(strcmp(behav.Distance,{'not sure'}))={'30'};
    behav.Distance(strcmp(behav.Distance,{'n/a'}))={'31'};
    dis=str2double(behav.Distance);
    else
    %dis=cell2mat(behav.Distance);
    behav.Distance(strcmp(behav.Distance,{'Not sure'}))={30};
    behav.Distance(strcmp(behav.Distance,{'n/a'}))={31};
    dis=cell2mat(behav.Distance);
    end
    all_dis(:,iSub)=dis;
    for id=1:length(d);
        c_dis(iSub,id)=sum(all_dis(:,iSub)==d(id));
    end
end %sub
eval(sprintf('save %s/dis c_dis c_dis_run', basedir));
end %end func
