%%%%%%%%%
basedir='/seastor/helenhelen/Cicero';
behavdir='/seastor/Projects/Cicero/exp-scripts/Mol/Results_scan';
%behavdir='/Users/xiaoqian/Documents/experiment/Cicero/exp-scripts/Mol/Results_scan';
addpath /seastor/helenhelen/scripts/NIFTI
addpath /home/helenhelen/DQ/project/git/SleeplessInSeattle/Cicero
%%%%%%%%%
dur=2;
%%%%%%%%%
subs=[9:31];
for iSub=subs;
    resultfile=sprintf('%s/MOL%02d/behav/SingleTrial',basedir,iSub);
    for iRun = 1:2
        %%encoding
        encoding_filename = ls(sprintf('%s/sub%02d_encoding_run%d*.mat',behavdir,iSub,iRun));
        eval(sprintf('load %s',encoding_filename));
        tmp1=AllTrialInfos.Onset; %% onset;
        tmp2=[tmp1,ones(size(tmp1))*dur ones(size(tmp1))];
        outputfile=sprintf('%s/encoding_run%d_all.txt',resultfile,iRun);
        eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
        %erro trial
        tmp1=AllGabor.AOnset(strcmp(AllGabor.Score,{'wrong'}));
        tmp2=[tmp1,ones(size(tmp1))*0.5 ones(size(tmp1))];
        tmp2=[0 0 0;tmp2];
        outputfile=sprintf('%s/encoding_run%d_err.txt',resultfile,iRun);
        eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
    
        %%retrieval    
        test_filename = ls(sprintf('%s/sub%02d_testing_run%d*.mat',behavdir,iSub,iRun));
        eval(sprintf('load %s',test_filename));
        tmp1=AllTrialInfos.Onset; %% onset;
        tmp2=[tmp1,ones(size(tmp1))*dur ones(size(tmp1))];
        outputfile=sprintf('%s/test_run%d_all.txt',resultfile,iRun);
        eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));
        %erro trial
        tmp1=AllGabor.AOnset(strcmp(AllGabor.Score,{'wrong'}));
        tmp2=[tmp1,ones(size(tmp1))*0.5 ones(size(tmp1))];
        tmp2=[0 0 0;tmp2];
        outputfile=sprintf('%s/test_run%d_err.txt',resultfile,iRun);
        eval(sprintf('save %s tmp2 -tabs -ascii',outputfile));   
    end %run
end %sub
