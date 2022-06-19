#!/bin/bash

#change mask, sessionlist, 4D images folder, and the settings below

permutations="5000"
questionList="Q2"

maptype="MDFr"

modality1="MD_flipped" #MD_flipped or MWF
modality2="Fr" #Fr or T1_flipped

name="CBcovNoP125000" #change this and studyDir and Data directory!!!!

#maskList="rGM05mask
#ReslicedToMDROIprecuneusLR
#ReslicedToMDROIallCerebellum
#ReslicedToMDROIhippo+parahippoLR
#ReslicedtoMDROIcaudateputamen2
#ReslicedtoMDROIprecentral+postcentral
#"
#rWM05mask

maskList="precun
ssm
striatum"
#WM05mask

CBcovList="CBcovNoP12"
#noCBcov"

sessionList="S2S3_CBS2
"

for question in $questionList; do
for map in $maptype; do
for session in $sessionList; do
for CBcov in $CBcovList; do
for mask in $maskList; do
# find the GLM directory

studyDir=/cubric/collab/354_sleepms/PALM/GLM/"$question"/"$map"/"$CBcov"/"$session"
#studyDir=/cubric/collab/354_sleepms/PALM/GLM/"$question"/"$maptype"/noCBcov/"$session"


# make results directory
analysisDir=/cubric/collab/354_sleepms/PALM/Results/"$question"/"$map"/"$question"_"$map"_"$CBcov"_"$session"_"$name"_"$mask" #added $map

mkdir -p $analysisDir
outDir=$analysisDir/results
mkdir -p $outDir

# move GLM to results directory
cp $studyDir/*.mat $analysisDir/"$question"_"$maptype".mat
cp $studyDir/*.con $analysisDir/"$question"_"$maptype".con

# select mask
#imcp /home/c1813013/Desktop/pick_atlas/"$mask".nii $analysisDir/brain_mask.nii
imcp /cubric/collab/354_sleepms/PALM/Masks/"$mask".nii $analysisDir/brain_mask.nii

# copy 4D files and create results folder
imcp /cubric/collab/354_sleepms/PALM/Data/"$question"/"$map"/"$CBcov"/"$session"/"$modality1"/merged_"$modality1".nii.gz $analysisDir/merged_"$modality1".nii.gz
imcp /cubric/collab/354_sleepms/PALM/Data/"$question"/"$map"/"$CBcov"/"$session"/"$modality2"/merged_"$modality2".nii.gz $analysisDir/merged_"$modality2".nii.gz
mkdir -p $outDir/"$map"

# set up the stats
inputData1=$analysisDir/merged_"$modality1".nii.gz
inputData2=$analysisDir/merged_"$modality2".nii.gz

mask=$analysisDir/brain_mask.nii.gz
stat_mat=$analysisDir/"$question"_"$maptype".mat
stat_con=$analysisDir/"$question"_"$maptype".con

# Volume analysis

#parallel 5000 perm
#randomise_parallel -i $inputData1 -o $outDir/MD -m $mask -d $stat_mat -t $stat_con -T -n 5000

#not parallel 1000 perm
palm -i $inputData1 -i $inputData2 -o $outDir/"$maptype" -m $mask -d $stat_mat -t $stat_con -C 1.75 -n $permutations -corrmod -noniiclass -save1-p -npc
#palm -i $inputData1 -i $inputData2 -o $outDir/"$map" -m $mask -d $stat_mat -t $stat_con -C 2 -n $permutations -corrmod -noniiclass -save1-p -npc
#npc is actually spitting out 1 pvalue for combined modalities
#randomise -i $inputData1          -o $outDir/"$map" -m $mask -d $stat_mat -t $stat_con -T -n $permutations

done
done
done
done
done
