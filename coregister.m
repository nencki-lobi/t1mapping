function src=coregister(ref,src,estimate,interp)
    switch nargin
        case 2
            estimate=0;
            interp=4;
        case 3
            interp=4;   %default 4th degree spline / 0 for NN
    end
    if(estimate)
        clear matlabbatch;
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = cellstr(ref);
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = cellstr(src);
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = interp;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
    else
        clear matlabbatch;
        matlabbatch{1}.spm.spatial.coreg.write.ref = cellstr(ref);
        matlabbatch{1}.spm.spatial.coreg.write.source = cellstr(src);
        matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = interp;
        matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    end
    spm_jobman('initcfg')
    spm_jobman('run', matlabbatch);
    
    [pathstr,name,ext] = fileparts(src);
    src=spm_vol(fullfile(pathstr,['r',name,ext]));
end