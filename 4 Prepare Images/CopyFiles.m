% Copy CHARMED files to new folders for statistical analysis

clc
clear all
warning off

session = [1,2,3];             

for ss = 1:numel(session)
if ss == 1
    sbj_num = [2,3,5,7,9,11,12,13,14,16,19,21,22,24,25,28,29,30,31,32,33]; %-----> define subjects for session
    %sbj_num = [2,3,5,  7,  9,  11,12,13,14,  16,  19,  21,22,23,24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
    %sbj_num = [2,3,5,  7,8,9,10,11,12,13,14,15,16,   19,20,21,22,   24,25,   27,28,29,30,31,32,33];
    S1_sbj_num = numel(sbj_num);
elseif ss == 2
    sbj_num = [2,3,5,7,9,11,12,13,14,16,19,21,22,24,25,28,29,30,31,32,33];       
    %sbj_num = [2,3,5,  7  ,9,  11,12,13,14,  16,  19,  21,22,23,24,25,26,27,28,29,30,31,32,33];    
    %sbj_num =  [2,3,5,6,7,  9,  11,12,13,14,   16,17,19,20,21,22,23,   25,   27,28,29,30,31,32,33];
    S2_sbj_num = numel(sbj_num);
elseif ss == 3
    sbj_num = [2,3,      11,12,13,14,16,19,21,   24,25,28,29,30,31,32,33];      
    %sbj_num = [2,3,            11,12,13,14,  16,  19,  21,   23,24,25,26,27,28,29,30,31,32,33];      
    %sbj_num =  [2,            10,11,12,13,14,15,16,17,19,   21,   23,24,25,26,   28,29,30,   32,33];      
    S3_sbj_num = numel(sbj_num);
end

for s = 1:numel(sbj_num)
    %% Find files
dir_data = '/cubric/collab/354_sleepms/CHARMED_preprocessing/';
cd(dir_data)
    
name  = dir(sprintf('*p%d',sbj_num(s)));
fname = name(1).name;
    
dir_ppnt = [dir_data fname '/'];
cd(dir_ppnt)
session_name=dir('*_SOLID_CHARMED_IRLLS');% for Fr
%session_name = dir('*_SOLID_DTInonlinear_maxb1500');% for MD/FA
for K = 1 : length(session_name)
    fname = session_name(K).name;
    name    = sprintf('S%d_SOLID_CHARMED_IRLLS',session(ss)); %Fr
    %name   = sprintf('S%d_SOLID_DTInonlinear_maxb1500',session(ss));%MD/FA
    if strcmp(fname(1:end), name); break; end
end

dir_session = [dir_ppnt fname '/']; 
cd(dir_session);

% Find images of interest
data_folder = dir('*_volumes');
data_folder = data_folder(1).name;
    
dir_datafolder = [dir_session data_folder '/'];
cd(dir_datafolder)

% Find images of interest

%MD
% MD_folder = dir;
% MD_nii = dir('sw*_fslDTIfit_maxb1500_MD.nii'); % select the first image
% MD_nii = MD_nii(1).name;
% MDnii_file = [dir_datafolder MD_nii];

%FA
% MD_folder = dir;
% FA_nii = dir('sw*_fslDTIfit_maxb1500_FA.nii'); % select the first image
% FA_nii = FA_nii(1).name;
% FAnii_file = [dir_datafolder FA_nii];

%Fr
MD_folder = dir;
Fr_nii = dir('sw*FRtot.nii'); % select the first image
Fr_nii = Fr_nii(1).name;
Frnii_file = [dir_datafolder Fr_nii];
    
% Copying file from respective path
source = dir_datafolder;
%destination = '/cubric/data/c1813013';

if ss == 1
destinationFA = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S1';
destinationMD = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S1';
destinationFr ='/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S1';
elseif ss == 2   
destinationFA = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S2';
destinationMD = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S2';
destinationFr ='/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S2';
elseif ss == 3
destinationFA = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S3';
destinationMD = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S3';
destinationFr ='/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S3';
end

%filenameFA = FAnii_file;
%filenameMD = MDnii_file;
filenameFr = Frnii_file;

ppntname  = sprintf('p%d',sbj_num(s));
currentsession = sprintf('S%d',session(ss));
%newfilenameFA = [ppntname '_' currentsession '_swFA.nii'];
%newfilenameMD = [ppntname '_' currentsession '_swMD.nii'];
newfilenameFr = [ppntname '_' currentsession '_swFr.nii'];

%fsourceFA = filenameFA;
%fsourceMD = filenameMD;
fsourceFr = filenameFr;

%fdestinationFA = fullfile(destinationFA,newfilenameFA);
%fdestinationMD = fullfile(destinationMD,newfilenameMD);
fdestinationFr = fullfile(destinationFr,newfilenameFr);

%copyfile(fsourceFA, fdestinationFA);
%copyfile(fsourceMD, fdestinationMD);
copyfile(fsourceFr, fdestinationFr);

end
end