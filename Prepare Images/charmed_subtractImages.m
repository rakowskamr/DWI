% Subtracting images for charmed
% i.e. S1-S2, S2-S3, S1-S3

clc
clear all
warning off
metric = 3; % 1 = FA, 2 = MD, 3 = Fr
comparison_to_analyse = 3; % <--- 1 = S1S2, 2 = S2S3, 3 = S1S3

if metric == 1 && comparison_to_analyse == 1
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S1S2';
elseif metric == 1 && comparison_to_analyse == 2
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S2S3';
elseif metric == 1 && comparison_to_analyse == 3
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S1S3';

elseif metric == 2 && comparison_to_analyse == 1
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S1S2';
elseif metric == 2 && comparison_to_analyse == 2
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S2S3';
elseif metric == 2 && comparison_to_analyse == 3
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S1S3';

elseif metric == 3 && comparison_to_analyse == 1
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S1S2';
elseif metric == 3 && comparison_to_analyse == 2
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S2S3';
elseif metric == 3 && comparison_to_analyse == 3
results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S1S3';

end


%% Initialise spm
%spm('defaults','fmri');
%spm_jobman('initcfg');
%% Identify data
if metric == 1
data_dir = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA';
cd(data_dir)
FA_S1 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S1';
FA_S2 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S2';
FA_S3 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FA/S3';
elseif metric == 2
data_dir = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD';
cd(data_dir)
MD_S1 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S1';
MD_S2 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S2';
MD_S3 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MD/S3';
elseif metric == 3
data_dir = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr';
cd(data_dir)
Fr_S1 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S1';
Fr_S2 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S2';
Fr_S3 = '/cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Fr/S3';
end

%% Identify sessions

if comparison_to_analyse == 1 % S1S2
   % S1S2_sbj = [2,3,5,  7,  9,   11,12,...
   %            13,14,  16,  19,  21,22,23,   ...
   %            24,25,26,27,28,29,30,31,32,33]; %-----> define subjects for session
   S1S2_sbj = [2,3,5,7,9,11,12,13,14,16,19,21,22,24,25,28,29,30,31,32,33]; %-----> define subjects for session
   
   S1S2_sbj_num = numel(S1S2_sbj);
    
        for s = 1:numel(S1S2_sbj)
            p_nb = S1S2_sbj(s);
            p_nb = mat2str(p_nb);
            
            if metric == 1
            S1S2_S1_dir_FA{s,1} = [FA_S1 '/p' p_nb '_S1_swFA.nii,1'];
            S1S2_S2_dir_FA{s,1} = [FA_S2 '/p' p_nb '_S2_swFA.nii,1'];
            elseif metric ==2
            S1S2_S1_dir_MD{s,1} = [MD_S1 '/p' p_nb '_S1_swMD.nii,1'];
            S1S2_S2_dir_MD{s,1} = [MD_S2 '/p' p_nb '_S2_swMD.nii,1'];
            elseif metric ==3
            S1S2_S1_dir_Fr{s,1} = [Fr_S1 '/p' p_nb '_S1_swFr.nii,1'];
            S1S2_S2_dir_Fr{s,1} = [Fr_S2 '/p' p_nb '_S2_swFr.nii,1'];
            
            end 
    end 
    
    
  elseif comparison_to_analyse == 2 %S2S3
    %S2S3_sbj = [2,3,           11,12,...
     %          13,14,  16,  19,  21,   23,   ...
     %          24,25,26,27,28,29,30,31,32,33];   
    
   S2S3_sbj = [2,3,      11,12,13,14,16,19,21,   24,25,28,29,30,31,32,33];      
    
    S2S3_sbj_num = numel(S2S3_sbj);
    
       for s = 1:numel(S2S3_sbj)
            p_nb = S2S3_sbj(s);
            p_nb = mat2str(p_nb);
            if metric == 1
            S2S3_S2_dir_FA{s,1} = [FA_S2 '/p' p_nb '_S2_swFA.nii,1'];
            S2S3_S3_dir_FA{s,1} = [FA_S3 '/p' p_nb '_S3_swFA.nii,1'];
            elseif metric == 2
            S2S3_S2_dir_MD{s,1} = [MD_S2 '/p' p_nb '_S2_swMD.nii,1'];
            S2S3_S3_dir_MD{s,1} = [MD_S3 '/p' p_nb '_S3_swMD.nii,1'];
            elseif metric == 3
            S2S3_S2_dir_Fr{s,1} = [Fr_S2 '/p' p_nb '_S2_swFr.nii,1'];
            S2S3_S3_dir_Fr{s,1} = [Fr_S3 '/p' p_nb '_S3_swFr.nii,1'];
            
            end
       end 
        
elseif comparison_to_analyse == 3 %S1S3
    %S1S3_sbj = [2,3,           11,12,...
    %           13,14,  16,  19,  21,   23,   ...
    %           24,25,26,27,28,29,30,31,32,33];      
   S1S3_sbj = [2,3,      11,12,13,14,16,19,21,   24,25,28,29,30,31,32,33];      
    
   S1S3_sbj_num = numel(S1S3_sbj);
    
     for s = 1:numel(S1S3_sbj)
            p_nb = S1S3_sbj(s);
            p_nb = mat2str(p_nb);
            if metric == 1
            S1S3_S1_dir_FA{s,1} = [FA_S1 '/p' p_nb '_S1_swFA.nii,1'];
            S1S3_S3_dir_FA{s,1} = [FA_S3 '/p' p_nb '_S3_swFA.nii,1'];
            elseif metric == 2
            S1S3_S1_dir_MD{s,1} = [MD_S1 '/p' p_nb '_S1_swMD.nii,1'];
            S1S3_S3_dir_MD{s,1} = [MD_S3 '/p' p_nb '_S3_swMD.nii,1'];
            elseif metric == 3
            S1S3_S1_dir_Fr{s,1} = [Fr_S1 '/p' p_nb '_S1_swFr.nii,1'];
            S1S3_S3_dir_Fr{s,1} = [Fr_S3 '/p' p_nb '_S3_swFr.nii,1'];
            
            end
        end 
    
end


%Participants excluded:
% all sessions: p1 (didnt hear sounds), p4 (withdrew)
% S1: none
% S2: none
% S3: p5,p6,p7,p8,p9 (lockdown), p22 (online)
% Notes: % S2: p24 (mprage twice)

%% Identify subject

if comparison_to_analyse == 1
    sbj_num = S1S2_sbj;
elseif comparison_to_analyse == 2
    sbj_num = S2S3_sbj;
 elseif comparison_to_analyse == 3
    sbj_num = S1S3_sbj;
end

for s = 1:numel(sbj_num) % participants
clear matlabbatch 

fprintf('Running P%d \n',sbj_num(s))

% Divide smwc1 by global value

%matlabbatch{1}.spm.util.imcalc.input = {'/Volumes/Macintosh/Users/mindthecat/Documents/MRI_PILOT1/20191204_analyse_pilot/functional/f2019-12-04_09-50-105943-00003-00003-1.nii,1'};


if comparison_to_analyse == 1 && metric == 1
    image1 = S1S2_S1_dir_FA(s,1);
    image2 = S1S2_S2_dir_FA(s,1);
    new_name = sprintf('p%d_FA_S1S2',sbj_num(s));
elseif comparison_to_analyse == 2 && metric == 1
    image1 = S2S3_S2_dir_FA(s,1);
    image2 = S2S3_S3_dir_FA(s,1);
    new_name = sprintf('p%d_FA_S2S3',sbj_num(s));
elseif comparison_to_analyse == 3 && metric == 1
    image1 = S1S3_S1_dir_FA(s,1);
    image2 = S1S3_S3_dir_FA(s,1);
    new_name = sprintf('p%d_FA_S1S3',sbj_num(s));
    
elseif comparison_to_analyse == 1 && metric == 2
    image1 = S1S2_S1_dir_MD(s,1);
    image2 = S1S2_S2_dir_MD(s,1);
    new_name = sprintf('p%d_MD_S1S2',sbj_num(s));
elseif comparison_to_analyse == 2 && metric == 2
    image1 = S2S3_S2_dir_MD(s,1);
    image2 = S2S3_S3_dir_MD(s,1);
    new_name = sprintf('p%d_MD_S2S3',sbj_num(s));
elseif comparison_to_analyse == 3 && metric == 2
    image1 = S1S3_S1_dir_MD(s,1);
    image2 = S1S3_S3_dir_MD(s,1);
    new_name = sprintf('p%d_MD_S1S3',sbj_num(s));


elseif comparison_to_analyse == 1 && metric == 3
    image1 = S1S2_S1_dir_Fr(s,1);
    image2 = S1S2_S2_dir_Fr(s,1);
    new_name = sprintf('p%d_Fr_S1S2',sbj_num(s));
elseif comparison_to_analyse == 2 && metric == 3
    image1 = S2S3_S2_dir_Fr(s,1);
    image2 = S2S3_S3_dir_Fr(s,1);
    new_name = sprintf('p%d_Fr_S2S3',sbj_num(s));
elseif comparison_to_analyse == 3 && metric == 3
    image1 = S1S3_S1_dir_Fr(s,1);
    image2 = S1S3_S3_dir_Fr(s,1);
    new_name = sprintf('p%d_Fr_S1S3',sbj_num(s));

end

image1 = str2mat(image1);
image2 = str2mat(image2);

matlabbatch{1}.spm.util.imcalc.input = {image1;image2};
matlabbatch{1}.spm.util.imcalc.output = new_name;

cd(results_folder)
matlabbatch{1}.spm.util.imcalc.outdir = {''}; % will save to current directory

matlabbatch{1}.spm.util.imcalc.expression = 'i1-i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});

matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch);


end % end participant
