#!/bin/bash
# FSL randomise: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Randomise/UserGuide
# nonparametric permutation inference on neuroimaging data.

#Remember to change mask, sessionlist, sex and the settings below

permutations="5000"
maptype="Fr"
analysisList="onewayTtest"
name="SEXglasserprecun5000"

#All possible combinations
#sessionList="S1S2_CBS2
#S2S3_CBS2
#S1S3_CBS2
#S1S2_CBS3
#S2S3_CBS3
#S1S3_CBS3
#S1S2_CBS4
#S2S3_CBS4
#S1S3_CBS4
#S1S2_N2
#S2S3_N2
#S1S3_N2
#S1S2_N3
#S2S3_N3
#S1S3_N3
#S1S2_REM
#S2S3_REM
#S1S3_REM
#S1S2
#S2S3
#S1S3"

#Selected combinations
sessionList="S2S3_CBS2
S1S3_CBS3
S2S3_CBS4
S2S3_N2"

for session in $sessionList; do

for analysis in $analysisList; do

#Find the GLM directory
studyDir=/cubric/collab/354_sleepms/CHARMED_stats/GLM_forFr_sex/"$session"_"$analysis"

#Create output directory
for map in $maptype; do
analysisDir=/cubric/collab/354_sleepms/CHARMED_stats/"$map"/"$session"_"$analysis"_"$name"
done
mkdir -p $analysisDir
outDir=$analysisDir/results
mkdir -p $outDir

#Move GLM files to output directory
cp $studyDir/*.mat $analysisDir/"$session"_"$analysis".mat
cp $studyDir/*.con $analysisDir/"$session"_"$analysis".con
# cp $studyDir/"$analysis".grp $analysisDir/"$session"_"$analysis".grp

# Choose your brain_mask

# Whole brain mask
#imcp /home/c1813013/spm12/tpm/ReslicedToMDmask_ICV.nii $analysisDir/brain_mask.nii
# Precuneus mask
#imcp /home/c1813013/Desktop/pick_atlas/ReslicedToMDROIprecuneusLR.nii $analysisDir/brain_mask.nii
# Cerebellum mask
#imcp /home/c1813013/Desktop/pick_atlas/ReslicedToMDROIallCerebellum.nii $analysisDir/brain_mask.nii
# Hippocampus mask
#imcp /home/c1813013/Desktop/pick_atlas/ReslicedToMDROIhippo+parahippoLR.nii $analysisDir/brain_mask.nii
# Dorsal striatum
#imcp /home/c1813013/Desktop/pick_atlas/ReslicedtoMDROIcaudateputamen2.nii $analysisDir/brain_mask.nii
# sensorimotr cortex
#imcp /home/c1813013/Desktop/pick_atlas/ReslicedtoMDROIprecentral+postcentral.nii $analysisDir/brain_mask.nii
#glasser Precuneus
imcp /home/c1813013/Desktop/GlasserAtlas/MDreslicedglasser_27_207.nii $analysisDir/brain_mask.nii
#WM spherical Precuneus (30 mm radius)
#imcp /home/c1813013/Desktop/Spherical_masks/ReslicedtoFA30LRprecun_sphereWMbin.nii $analysisDir/brain_mask.nii

# Copy 4D files and create results folder
for map in $maptype; do
imcp /cubric/collab/354_sleepms/CHARMED_preprocessing/FinalFSLDTI/"$map"/"$session"/merged_"$map"_"$session".nii.gz $analysisDir/merged_"$map"_"$session".nii.gz
mkdir -p $outDir/"$map"
done

# Set up the stats
inputData1=$analysisDir/merged_"$map"_"$session".nii.gz

mask=$analysisDir/brain_mask.nii
stat_mat=$analysisDir/"$session"_"$analysis".mat
stat_con=$analysisDir/"$session"_"$analysis".con

# Volume analysis
randomise -i $inputData1 -o $outDir/"$map" -m $mask -d $stat_mat -t $stat_con -T -n $permutations

done

done
