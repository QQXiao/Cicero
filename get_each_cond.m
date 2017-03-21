function calculate_mean(subs)
addpath /seastor/helenhelen/scripts/NIFTI
basedir='/seastor/helenhelen/Cicero';
datadir=sprintf('%s/pattern/Searchlight_RSM/ref_space/z',basedir);
resultdir=sprintf('%s/pattern/Searchlight_RSM/ref_space/each_cond',basedir);

cps={'item_ERS','rs_ln','rs_mem','rs_ERS','rt_ln','rt_mem','rt_ERS','rt'};

item_ERS_name={'wi','bi'};
rs_ERS_name={'wl','bl'};
rs_ln_name={'wl_wr','bl_wr','wl_cr','bl_cr'};
rs_mem_name={'wl_wr','bl_wr','wl_cr','bl_cr'};

rt_ln_name={'sED','lED'};
rt_mem_name={'sED','lED'};
rt_ERS_name={'sED','lED'};
rt_name={'sED','lED'};

for s=subs
    for ncps=1:length(cps);
    diff = load_nii_zip(sprintf('%s/%s_sub%02d.nii.gz',datadir,cps{ncps},s));
    diff1 = load_nii_zip(sprintf('%s/%s_sub%02d.nii.gz',datadir,cps{ncps},s),1);
    eval(sprintf('ncond=length(%s_name);',cps{ncps}));
    eval(sprintf('cname=%s_name;',cps{ncps}));
        for n=1:ncond
            a=diff.img(:,:,:,n);
            diff1.img=a;
            filename=sprintf('%s/%s_%s_sub%02d.nii',resultdir,cps{ncps},cname{n},s);
            save_untouch_nii(diff1, filename);
            system(sprintf('gzip -f %s',filename));
        end
    end
end %end sub
end %end func
