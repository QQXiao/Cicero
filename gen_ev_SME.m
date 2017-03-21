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
subs=[1:12]
d=[0:1:31];
dur=2;
for i=1:length(subs);
    iSub=subs(i);
    resultfile=sprintf('/seastor/helenhelen/Cicero/MOL%02d/behav',iSub);
% load testing data
    for iRun = 1:2
        test_filename = ls(sprintf('%s/sub%02d_testing_run%d*.mat',behavdir,iSub,iRun));
        eval(sprintf('load %s',test_filename));
        behav_run=AllTrialInfos;
        if i~=first_sub
        behav_run.Distance(strcmp(behav_run.Distance,{'not sure'}))={'30'};
        behav_run.Distance(strcmp(behav_run.Distance,{'n/a'}))={'31'};
        behav_run.d=str2double(behav_run.Distance);
        else
        behav_run.Distance(strcmp(behav_run.Distance,{'Not sure'}))={30};
        behav_run.Distance(strcmp(behav_run.Distance,{'n/a'}))={31};
        behav_run.d=cell2mat(behav_run.Distance);
        end
        tmp1=behav_run(behav_run.d==0,'AOnset'); %% onset;
        tmp2=[table2array(tmp1),ones(size(tmp1))*dur ones(size(tmp1))];
        outputfile=sprintf('%s/rem_run%d.txt',resultfile,iRun);
        eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
        tmp1=behav_run(behav_run.d==1,'AOnset'); %% onset;
        tmp2=[table2array(tmp1),ones(size(tmp1))*dur ones(size(tmp1))];
        outputfile=sprintf('%s/dis1_run%d.txt',resultfile,iRun);
        eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
        tmp1=behav_run(behav_run.d>=2,'AOnset'); %% onset;
        tmp2=[table2array(tmp1),ones(size(tmp1))*dur ones(size(tmp1))];
        outputfile=sprintf('%s/forg_run%d.txt',resultfile,iRun);
        eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
end %end run
end %sub
%eval(sprintf('save %s/rs_ln_sub%02d rs_ln_z', zdir, iSub));
end %end func
