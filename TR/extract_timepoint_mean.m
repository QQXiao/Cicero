function extract_timepoint(subs)
dur=1.5;
basedir='/seastor/helenhelen/Cicero';
labeldir='/seastor/Projects/Cicero/exp-scripts/Mol/Results_scan';
datadir=sprintrf('%s/pattern/data/bold/aligned_bold',basdir);
resultdir=sprintf('%s/pattern/TR/data/ref_space/sep',basedir);
mkdir(resultdir);
addpath /seastor/helenhelen/scripts/NIFTI
sub=subs
TN=30;
for r=1:2
    etmp=[];rtmp=[];
    elabelfilename=ls(sprintf('%s/sub%02d_encoding_run%d_*.mat',labeldir,sub,r));
    eval(sprintf('load %s',elabelfilename));
    etmp=AllTrialInfos;
    niifile=sprintf('%s/MOL%02d_mol_encoding_run%d_native.nii.gz',datadir,sub,r);
    all_data=load_nii_zip(niifile);
    all_data.img=zscore(all_data.img,0,4); % normalize along the time dimension
    onset=etmp.AOnset);
    all_data1=all_data.img(:,:,:,fix((onset+4)/2))/2+all_data.img(:,:,:,fix((onset+6)/2))/2;
    filename=sprintf('%s/sub%02d_encoding_run%d.nii',resultdir,sub,r);
    all_data.img=all_data1;
    all_data.hdr.dime.dim(5)=TN; % dimension chagne to
    save_untouch_nii(all_data, filename);
    system(sprintf('gzip -f %s',filename));

    rlabelfilename=ls(sprintf('%s/sub%02d_testing_run%d_*.mat',labeldir,sub,r));
    eval(sprintf('load %s',rlabelfilename));
    rtmp=AllTrialInfos;
    niifile=sprintf('%s/MOL%02d_mol_test_run%d_native.nii.gz',datadir,sub,r);
    all_data=load_nii_zip(niifile);
    all_data.img=zscore(all_data.img,0,4); % normalize along the time dimension
    onset=rtmp.AOnset;
    all_data1=all_data.img(:,:,:,fix((onset+4)/2))*0.4+all_data.img(:,:,:,fix((onset+6)/2))*0.4+all_data.img(:,:,:,fix((onset+8)/2))*0.2;
    filename=sprintf('%s/sub%02d_test_run%d_.nii',resultdir,sub,r);
    all_data.img=all_data1;
    all_data.hdr.dime.dim(5)=TN; % dimension chagne to
    save_untouch_nii(all_data, filename);
    system(sprintf('gzip -f %s',filename));
end
end
