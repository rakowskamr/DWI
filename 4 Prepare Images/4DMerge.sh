#Merge participant images to create 4D file for each modality,
# to use as an input in the design matrix

# Select sessions of interest

#sessionList="S1_CBS2
#S1_CBS3
#S1_CBS4
#S1_N2
#S1_N3
#S1_REM"

#sessionList="S2_CBS2
#S2_CBS3
#S2_CBS4
#S2_N2
#S2_N3
#S2_REM"

#sessionList="S3_CBS2
#S3_CBS3
#S3_CBS4
#S3_N2
#S3_N3
#S3_REM"

sessionList="S1_CBS2
S1_CBS3
S1_CBS4
S2_CBS2
S2_CBS3
S2_CBS4
S3_CBS2
S3_CBS3
S3_CBS4
S1_N2
S1_N3
S1_REM"

#Merge FA images
for session in $sessionList; do

cd /cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FAindvidual/$session
ls
fslmerge -t merged_FA_$session /cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/FAindvidual/$session/*.nii

done

#Merge MD images
for session in $sessionList; do

cd /cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MDindividual/$session
ls
fslmerge -t merged_MD_$session /cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/MDindividual/$session/*.nii

done

#Merge Fr images
for session in $sessionList; do

cd /cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Frindividual/$session
ls
fslmerge -t merged_Fr_$session /cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/Frindividual/$session/*.nii

done
