%% CHARMED modular pipeline
% The pipeline itself was created according to https://wikis.cf.ac.uk/confluence/display/cubric/g%29+Modular+Pipeline+Multishell+DTI+processing
% and is saved in '/cubric/collab/354_sleepms/early_pipelines_analysis/CHARMED_pipeline_Modular.xml'
% This script creates xml files, one per subject/scan to be used as the
% input for ModularPipe(subject, pipeline)

function [] = ModularPipelineBash(sbj_num)

clc
warning off

session = [1,2,3];  
ss = 1;
%sbj_num = 2; % participants

Modular = '/cubric/collab/354_sleepms/early_pipelines_analysis/CHARMED_pipeline_Modular_DTI_CHARMED_IRLLS.xml';

%Make output directory
SubjectName = sprintf('p%i',sbj_num); %e.g. 'p30';
SessionName = sprintf('S%i_SOLID_CHARMED_IRLLS',session(ss));

results_folder = '/cubric/collab/354_sleepms/CHARMED_preprocessing/';
cd(results_folder);
if ~exist(fullfile(results_folder, SubjectName,SessionName),'dir')
    mkdir(SubjectName,SessionName)
end

output_dir = fullfile(results_folder, SubjectName, SessionName, '/');
cd(output_dir)
addpath(genpath('/cubric/collab/354_sleepms/'));


%Find data
dir_data = '/home/c1813013/Desktop/data/';
cd(dir_data)  

name  = dir(sprintf('*p%d',sbj_num));
fname = name(1).name;
dir_ppnt = [dir_data fname '/'];
cd(dir_ppnt)

session_name = dir('S*');
for K = 1 : length(session_name)
    fname = session_name(K).name;
    name  = sprintf('S%d',session(ss));
    if strcmp(fname(1:2), name); break; end
end

dir_session = [dir_ppnt fname '/'];
cd(dir_session);

%find charmed AP
s_folder = dir('*CHARMED_AP');
s_folder = s_folder(1).name;   
folder_DWI = [dir_session s_folder '/'];
cd(folder_DWI)
dir_DWI = dir('*CHARMED*nii');
dir_DWI = dir_DWI(1).name;
DWI = [folder_DWI dir_DWI];

dir_bval = dir('*.bval');
dir_bval = dir_bval(1).name;
bval = [folder_DWI dir_bval];

dir_bvec = dir('*.bvec');
dir_bvec = dir_bvec(1).name;
bvec = [folder_DWI dir_bvec];

%find charmed ref PA
cd(dir_session)   
s_folder = dir('*CHARMED_ref_PA');
s_folder = s_folder(1).name;   
folder_DWIref = [dir_session s_folder '/'];
cd(folder_DWIref)
dir_DWIref = dir('*CHARMED*nii');
dir_DWIref = dir_DWIref(1).name;
ref = [folder_DWIref dir_DWIref];

%Subject
cd(folder_DWI)
BashScriptTempModular2 = fullfile(cd,['Modular_subject_pipeline_' SubjectName '.xml']);

fiddata=fopen(BashScriptTempModular2,'w');
fprintf(fiddata,['<?xml version="1.0"?>\n']);

fprintf(fiddata, ['<dataset>\n']);
fprintf(fiddata,['	<ID>' SubjectName '</ID>\n']);
fprintf(fiddata, ['<outdir/>\n']);
fprintf(fiddata, ['<image>\n']);
fprintf(fiddata,['		<label>DWimage1</label>\n']);
fprintf(fiddata,['		<class>DWimage</class>\n']);
fprintf(fiddata,['		<file>' DWI '</file>\n']);
fprintf(fiddata,['		<bval>' bval '</bval>\n']);
fprintf(fiddata,['		<bvec>' bvec '</bvec>\n']);
fprintf(fiddata,['		<pdir>0 -1 0</pdir>\n']);
fprintf(fiddata,['		<bshape>1</bshape>\n']);
fprintf(fiddata, ['<supp/>\n']);
fprintf(fiddata,['		<delta>24</delta>\n']);
fprintf(fiddata,['		<smalldel>7</smalldel>\n']);
fprintf(fiddata,['		<TE>59</TE>\n']);
fprintf(fiddata,['		<TR>3000</TR>\n']);
fprintf(fiddata, ['<delay/>\n']);
fprintf(fiddata, ['</image>\n']);
fprintf(fiddata, ['<image>\n']);
fprintf(fiddata,['		<label>DWpaRef2</label>\n']);
fprintf(fiddata,['		<class>DWpaRef</class>\n']);
fprintf(fiddata,['		<file>' ref '</file>\n']);
fprintf(fiddata,['		<phase_dir>0 1 0</phase_dir>\n']);
fprintf(fiddata, ['</image>\n']);
fprintf(fiddata, ['</dataset>\n']);

subject = BashScriptTempModular2;

cd(output_dir) %It's really important to be in the output directory
p= ModularPipe(BashScriptTempModular2,Modular);

end