#CHECK for outliers

Question="Q1"
Modality="MDFr"
Test="S1_PCA" #'S1_PCA' #"S2S3_CBS4"
Filename="PCA_sexagePSQIrandlearningN2" #'PCA_sexagePSQIrandlearningNoP125000' #"CBcovNoP12_S2S3_CBS4_CBcovNoP125000"
FilenameData='S1_swMD' #'S1_swMD' #"S2S3"
Mask='ssm' #"cerebellum" #'precun'
contrast="2"
DataFolder="withoutP12" #"CBcovNoP12" "withoutP12"
resultsFolder=/cubric/collab/354_sleepms/PALM/Results/"$Question"/"$Modality"
cd $resultsFolder
# for MDFr, S1S2
#ppntList="p2 p11 p13 p14 p16 p19 p21 p22 p24 p25 p28 p29 p30 p31 p32 p33"

# for MDFr, S2S3
#ppntList="p2 p11 p13 p14 p16 p19 p21 p24 p25 p28 p29 p30 p31 p32 p33"

# for MDFr, Q1 (S1)
ppntList="p2 p11 p13 p14 p16 p19 p21 p22 p24 p25 p28 p29 p30 p31 p32 p33"


#Create a folder where the data will be saved
OutliersFolder=/cubric/collab/354_sleepms/PALM/Results/"$Question"/"$Modality"/RawDatapoint/"$Filename"/"$Mask"
mkdir -p $OutliersFolder

cd $OutliersFolder

#Find raw data
#Q2
#RawDataMD=/cubric/collab/354_sleepms/PALM/Data/"$Question"/"$Modality"/"$DataFolder"/"$Test"/MD_flipped
#RawDataFr=/cubric/collab/354_sleepms/PALM/Data/"$Question"/"$Modality"/"$DataFolder"/"$Test"/Fr

#Q1
RawDataMD=/cubric/collab/354_sleepms/PALM/Data/"$Question"/"$Modality"/withoutP12/MD_flipped
RawDataFr=/cubric/collab/354_sleepms/PALM/Data/"$Question"/"$Modality"/withoutP12/Fr

#Find stat result:
#multimodal
SigResult=/cubric/collab/354_sleepms/PALM/Results/"$Question"/"$Modality"/"$Question"_"$Modality"_"$Filename"_"$Mask"/results/"$Modality"_clustere_npc_fisher_fwep_c"$contrast".nii.gz
#_unimodalMask
#SigResult=/cubric/collab/354_sleepms/PALM/Results/"$Question"/"$Modality"/"$Question"_"$Modality"_"$Filename"_"$Mask"/results/"$Modality"_clustere_tstat_mfwep_m1_c"$contrast".nii.gz


#threshold at 0.95
fslmaths $SigResult -thr 0.95 $OutliersFolder/thresh.nii
thresh=$OutliersFolder/thresh.nii.gz

#replacee NaNs with 0
#fslmaths $thresh -nan $mcDESPOToutliers/nan0.nii
#nan0=$mcDESPOToutliers/nan0.nii.gz

#binarise image
fslmaths $thresh -bin $OutliersFolder/binarisedMask.nii
binarisedMask=$OutliersFolder/binarisedMask.nii.gz

#if the above doesnt work. unzip thresh and create a mask in spm
#binarisedMask=$OutliersFolder/mask.nii

#mask individual participant images with the brain_mask & get the averagde

mkdir -p $OutliersFolder/MaskedPpnt

#MD
for ppnt in $ppntList; do
#Q2
ppntFile=$RawDataMD/minus1_"$ppnt"_"$FilenameData".nii #<---- change end of file name
#Q1
#ppntFile=$RawDataMD/minus1_"$ppnt"_"$FilenameData".nii #<---- change end of file name
fslmaths $binarisedMask -mul $ppntFile $OutliersFolder/MaskedPpnt/"$ppnt"_MD
maskedPpnt=$OutliersFolder/MaskedPpnt/"$ppnt"_MD
fslmeants -i $maskedPpnt >> $OutliersFolder/MaskedPpnt/av_MD.txt -m $binarisedMask

done

#Fr

for ppnt in $ppntList; do

ppntFile=$RawDataFr/"$ppnt"_S1_swFr.nii #<---- change end of file name
fslmaths $binarisedMask -mul $ppntFile $OutliersFolder/MaskedPpnt/"$ppnt"_Fr
maskedPpnt=$OutliersFolder/MaskedPpnt/"$ppnt"_Fr
fslmeants -i $maskedPpnt >> $OutliersFolder/MaskedPpnt/av_Fr.txt -m $binarisedMask

done
