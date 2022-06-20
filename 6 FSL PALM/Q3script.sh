#!/bin/bash

# FSL PALM: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM
# Non-Parametric Combination (NPC) for joint inference over multiple modalities

# Q3: Control analysis
# Check the relationship between microstructural plasticity and participants' sex,
# baseline performance and random and sequence blocks, and general sleep patterns

# Remember to change mask, sessionlist, 4D images folder, and the settings below

permutations="1000"
questionList="Q3"

maptype="MWFT1"
modality1="MWF" #MD_flipped or MWF
modality2="T1_flipped" #Fr or T1_flipped

covList="Sex
Learning
Random
PSQI"

#maskList="rGM05mask
#ReslicedToMDROIprecuneusLR
#ReslicedToMDROIallCerebellum
#ReslicedToMDROIhippo+parahippoLR
#ReslicedtoMDROIcaudateputamen2
#ReslicedtoMDROIprecentral+postcentral
#rWM05mask"

maskList="GM05mask
precun
cerebellum
hippo
striatum
ssm
"
#WM05mask

for question in $questionList; do
for map in $maptype; do
for cov in $covList; do
for mask in $maskList; do

# Find the GLM directory
studyDir=/cubric/collab/354_sleepms/PALM/GLM/"$question"/"$map"/"$cov"

# Create output directory
analysisDir=/cubric/collab/354_sleepms/PALM/Results/"$question"/"$map"/"$question"_"$map"_concordant_"$cov"_"$mask"
mkdir -p $analysisDir
outDir=$analysisDir/results
mkdir -p $outDir

# Move GLM to results directory
cp $studyDir/*.mat $analysisDir/"$question"_"$maptype".mat
cp $studyDir/*.con $analysisDir/"$question"_"$maptype".con

# Select mask
#imcp /home/c1813013/Desktop/pick_atlas/"$mask".nii $analysisDir/brain_mask.nii
imcp /cubric/collab/354_sleepms/PALM/Masks/"$mask".nii $analysisDir/brain_mask.nii

# Copy 4D files and create results folder
imcp /cubric/collab/354_sleepms/PALM/Data/"$question"/"$map"/"$modality1"/merged_"$modality1".nii.gz $analysisDir/merged_"$modality1".nii.gz
imcp /cubric/collab/354_sleepms/PALM/Data/"$question"/"$map"/"$modality2"/merged_"$modality2".nii.gz $analysisDir/merged_"$modality2".nii.gz
mkdir -p $outDir/"$map"

# Set up the stats
inputData1=$analysisDir/merged_"$modality1".nii.gz
inputData2=$analysisDir/merged_"$modality2".nii.gz

mask=$analysisDir/brain_mask.nii.gz
stat_mat=$analysisDir/"$question"_"$maptype".mat
stat_con=$analysisDir/"$question"_"$maptype".con

# Volume analysis
palm -i $inputData1 -i $inputData2 -o $outDir/"$maptype" -m $mask -d $stat_mat -t $stat_con -C 1.75 -n $permutations -corrmod -noniiclass -save1-p -npc
#palm -i $inputData1 -i $inputData2 -o $outDir/"$maptype" -m $mask -d $stat_mat -t $stat_con -C 1.75 -n $permutations -corrmod -noniiclass -save1-p -npc -concordant
#palm -i $inputData1 -i $inputData2 -o $outDir/"$map" -m $mask -d $stat_mat -t $stat_con -C 2 -n $permutations -corrmod -noniiclass -save1-p -npc
#npc is actually spitting out 1 pvalue for combined modalities

done
done
done
done
