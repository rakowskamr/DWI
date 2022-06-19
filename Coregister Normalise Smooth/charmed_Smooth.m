% Smooth CHARMED images using 8mm kernel

% 8mm because thats what I used for fMRI and VBM, 6mm would be consistent
% with Monica's paper

clc
clear all
warning off

session = [1,2,3];  

for ss = 1:numel(session)
if ss == 1
    sbj_num = [2,3,5,7,9,11,12,13,14,16,19,21,22,24,25,28,29,30,31,32,33]; %-----> define subjects for session
    %sbj_num = [2,3,5,  7,8,9,10,11,12,13,14,15,16,   19,20,21,22,   24,25,   27,28,29,30,31,32,33];
    S1_sbj_num = numel(sbj_num);
elseif ss == 2
    sbj_num = [2,3,5,7,9,11,12,13,14,16,19,21,22,24,25,28,29,30,31,32,33];    
    %sbj_num =  [2,3,5,6,7,  9,  11,12,13,14,   16,17,19,20,21,22,23,   25,   27,28,29,30,31,32,33];
    S2_sbj_num = numel(sbj_num);
elseif ss == 3
    sbj_num = [2,3,      11,12,13,14,16,19,21,   24,25,28,29,30,31,32,33];      
    %sbj_num =  [2,            10,11,12,13,14,15,16,17,19,   21,   23,24,25,26,   28,29,30,   32,33];      
    
    S3_sbj_num = numel(sbj_num);
end

%Subjects excluded:
% all sessions: p1 (didnt hear sounds), p4 (withdrew), p18 (left-handed, no learning)
% S1: none
% S2: none
% S3: p5,p6,p7,p8,p9 (lockdown), p22 (online)

% initialise spm
%spm('defaults','fmri');
%spm_jobman('initcfg');

for s = 1:numel(sbj_num) % participants
fprintf(['\n Analysing participant: ' num2str(sbj_num(s)) ', Session: ' num2str(ss) '\n']);
clear matlabbatch 
tic

%% Find files
dir_data = '/cubric/collab/354_sleepms/CHARMED_preprocessing/';
cd(dir_data)
    
name  = dir(sprintf('*p%d',sbj_num(s)));
fname = name(1).name;
    
dir_ppnt = [dir_data fname '/'];
cd(dir_ppnt)
session_name = dir('*_SOLID_CHARMED_IRLLS');
for K = 1 : length(session_name)
    fname = session_name(K).name;
    name    = sprintf('S%d_SOLID_CHARMED_IRLLS',session(ss));
    if strcmp(fname(1:end), name); break; end
end

dir_session = [dir_ppnt fname '/']; % this is correct
cd(dir_session);

% Find images of interest
data_folder = dir('*_volumes');
data_folder = data_folder(1).name;
    
dir_datafolder = [dir_session data_folder '/'];
cd(dir_datafolder)

% MD = _MD.nii
%MD_folder = dir;
% MD_name = dir('*MDero.nii.gz'); % select the first image
% MD_name = MD_name(1).name;
% gunzip(MD_name)

% MD_nii = dir('w*_fslDTIfit_maxb1500_MD.nii'); % select the first image
% MD_nii = MD_nii(1).name;
% MDnii_file = [dir_datafolder MD_nii ',1'];

% FA = FA
%FA_folder = dir;
% FA_name = dir('FAero.nii.gz'); % select the first image
% FA_name = FA_name(1).name;
% gunzip(FA_name)

%FA_nii = dir('w*_fslDTIfit_maxb1500_FA.nii'); % select the first image
%FA_nii = FA_nii(1).name;
%FAnii_file = [dir_datafolder FA_nii ',1'];

% Fr = FRtot
%Fr_folder = dir;
% Fr_name = dir('w*FRtot.nii'); % select the first image
% Fr_name = Fr_name(1).name;
 %gunzip(Fr_name)

 Fr_folder = dir;
 Fr_nii = dir('w*FRtot.nii'); % select the first image
 Fr_nii = Fr_nii(1).name;
 Frnii_file = [dir_datafolder Fr_nii ',1'];

matlabbatch{1}.spm.spatial.smooth.data = {%MDnii_file
                                          %FAnii_file};
                                          Frnii_file}
                                          %         };
matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8]; % <-------- or 6? (eg. auditory, small structures, need to smooth less) or 8 (eg. face group, bigger structures like hippocampus can smooth more)
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';

spm_jobman('run',matlabbatch);
toc
end 
end

