% Coregister and normalise CHARMED images
% coregister TED_brain to T1
% use y_T1 image (coregistered to MNI) created during fMRI analysis to
% normalise the coregistered images of interest to it

clc
clear all
warning off

session = [1,2,3];  

for ss = 1:numel(session)
if ss == 1
    sbj_num = [];
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    S1_sbj_num = numel(sbj_num);
elseif ss == 2
    sbj_num = [2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33];    
    sbj_num = [];
    S2_sbj_num = numel(sbj_num);
elseif ss == 3
    sbj_num = [];
    sbj_num = [2,3,          10,11,12,13,14,15,16,17,19,20,21,   23,24,25,26,27,28,29,30,31,32,33];      
    S3_sbj_num = numel(sbj_num);
end


for s = 1:numel(sbj_num) % participants
fprintf(['\n Analysing participant: ' num2str(sbj_num(s)) ', Session: ' num2str(ss) '\n']);
clear matlabbatch compS_file comp_file compB02_file compB01_file
tic

%% Find files
dir_data = '/cubric/collab/354_sleepms/CHARMED_preprocessing/';
cd(dir_data)
    
name  = dir(sprintf('*p%d',sbj_num(s)));
fname = name(1).name;
    
dir_ppnt = [dir_data fname '/'];
cd(dir_ppnt)
session_name = dir('*_SOLID_DTInonlinear_maxb1500');
for K = 1 : length(session_name)
    fname = session_name(K).name;
    name    = sprintf('S%d_SOLID_DTInonlinear_maxb1500',session(ss));
    if strcmp(fname(1:end), name); break; end
end

dir_session = [dir_ppnt fname '/']; % this is correct
cd(dir_session);

% Find images of interest
data_folder = dir('*_volumes');
data_folder = data_folder(1).name;
    
dir_datafolder = [dir_session data_folder '/'];
cd(dir_datafolder)

% TED brain for reference

TED_folder = dir;
TED_name = dir('*TED.nii.gz'); % select the first image
TED_name = TED_name(1).name;

gunzip(TED_name)

TED_nii = dir('*TED.nii'); % select the first image
TED_nii = TED_nii(1).name;
TEDnii_file = [dir_datafolder TED_nii ',1'];

% MD = _MD.nii

MD_folder = dir;
MD_name = dir('*_fslDTIfit_maxb1500_MD.nii.gz'); % select the first image
MD_name = MD_name(1).name;
gunzip(MD_name)

MD_nii = dir('*_fslDTIfit_maxb1500_MD.nii'); % select the first image
MD_nii = MD_nii(1).name;
MDnii_file = [dir_datafolder MD_nii ',1'];

% FA = FA
FA_folder = dir;
FA_name = dir('*_fslDTIfit_maxb1500_FA.nii.gz'); % select the first image
FA_name = FA_name(1).name;
gunzip(FA_name)

FA_nii = dir('*_fslDTIfit_maxb1500_FA.nii'); % select the first image
FA_nii = FA_nii(1).name;
FAnii_file = [dir_datafolder FA_nii ',1'];

% Fr = FRtot
% Fr_folder = dir;
% Fr_name = dir('*_FRtot.nii.gz'); % select the first image
% Fr_name = Fr_name(1).name;
% gunzip(Fr_name)
% 
% Fr_nii = dir('*_FRtot.nii'); % select the first image
% Fr_nii = Fr_nii(1).name;
% Frnii_file = [dir_datafolder Fr_nii ',1'];

%T1 image
dir_rawdata = '/home/c1813013/Desktop/data/';
cd(dir_rawdata)
    
Tname  = dir(sprintf('*p%d',sbj_num(s)));
Tfname = Tname(1).name;

Tdir_ppnt = [dir_rawdata Tfname '/'];
cd(Tdir_ppnt)
Tsession_name = dir('S*');
for K = 1 : length(Tsession_name)
    Tfname = Tsession_name(K).name;
    name    = sprintf('S%d',session(ss));
    if strcmp(Tfname(1:2), name); break; end
end

Tdir_session = [Tdir_ppnt Tfname '/']; 
cd(Tdir_session);

% Find structural data
cd(Tdir_session);
Ts_folder = dir('*mprage');
Ts_folder = Ts_folder(1).name;
    
Tdir_sfolder = [Tdir_session Ts_folder '/'];
cd(Tdir_sfolder)
 
% T1 original
Ts_name = dir('*mprage*nii');
Ts_name = Ts_name(1).name;
 
T1nii_file = [Tdir_sfolder Ts_name ',1'];

% y_T1
Tys_name = dir('y*mprage*nii');
Tys_name = Tys_name(1).name;
 
T1ynii_file = [Tdir_sfolder Tys_name];

% c1
c1_name = dir('c1*mprage*nii');
c1_name = c1_name(1).name;
 
c1nii_file = [Tdir_sfolder c1_name];

%c2
c2_name = dir('c2*mprage*nii');
c2_name = c2_name(1).name;
 
c2nii_file = [Tdir_sfolder c2_name];
%c3
c3_name = dir('c3*mprage*nii');
c3_name = c3_name(1).name;
 
c3nii_file = [Tdir_sfolder c3_name];

%Add GM, WM, CSF
matlabbatch{1}.spm.util.imcalc.input = {c1nii_file
                                        c2nii_file
                                        c3nii_file};
matlabbatch{1}.spm.util.imcalc.output = 'T1brainimage';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i1+i2+i3';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

%Create T1 brain mask
matlabbatch{2}.spm.util.imcalc.input(1) = cfg_dep('Image Calculator: ImCalc Computed Image: T1brainimage', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.spm.util.imcalc.output = 'T1brainmask';
matlabbatch{2}.spm.util.imcalc.outdir = {''};
matlabbatch{2}.spm.util.imcalc.expression = 'i1>0.5';
matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{2}.spm.util.imcalc.options.mask = 0;
matlabbatch{2}.spm.util.imcalc.options.interp = 1;
matlabbatch{2}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch);
clear matlabbatch

%T1brainmask
T1brainmask_name = dir('T1brainmask*nii');
T1brainmask_name = T1brainmask_name(1).name;
 
T1brainmasknii_file = [Tdir_sfolder T1brainmask_name];

matlabbatch{1}.spm.util.imcalc.input = {T1brainmasknii_file
                                        T1nii_file};
matlabbatch{1}.spm.util.imcalc.output = 'T1brain';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = ' i1.*i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

matlabbatch{2}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Image Calculator: ImCalc Computed Image: T1brain', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
   
matlabbatch{2}.spm.spatial.coreg.estimate.source = {TEDnii_file};
    
matlabbatch{2}.spm.spatial.coreg.estimate.other = {MDnii_file
                                                   FAnii_file};
                                                   %Frnii_file
                                                   %};
     
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

matlabbatch{3}.spm.spatial.normalise.write.subj.def(1) = {T1ynii_file};
matlabbatch{3}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{3}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{3}.spm.spatial.normalise.write.woptions.vox = [2 2 2]; %resolution
matlabbatch{3}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{3}.spm.spatial.normalise.write.woptions.prefix = 'w';

spm_jobman('run',matlabbatch);

end
end