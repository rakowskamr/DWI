# DTI FIT in FSL, generates MD, FA images

#!/bin/sh bash

echo "RUNNING DTIFIT"

# definitions
preproDir=/cubric/collab/354_sleepms/CHARMED_preprocessing
rawdataDir=/home/c1813013/Desktop/data

#subjectList="p2 p3 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 p31 p32 p33"
#timeList="S1"

subjectList="p2 p3 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 p31 p32 p33"
timeList="S2"

#subjectList="p2 p3 p10 p11 p12 p13 p14 p15 p16 p17 p19 p20 p21 p23 p24 p25 p26 p27 p28 p29 p30 p31 p32 p33"
#timeList="S3"

for subj in $subjectList; do
  for time in $timeList; do

echo "  subj: $subj$time"

subjPreproDir=$preproDir/"$subj"/"$time"_SOLID_DTInonlinear_maxb1500/"$subj"_volumes
subjRawdataDir=$rawdataDir/*"$subj"/"$time"_*/*_CHARMED_AP

echo $subjPreproDir
echo $subjRawdataDir

echo "****  extracting relevant shells   ****"

rawdata=$subjPreproDir/*_gibbsCorrSubVoxShift_TED.nii.gz
bvec=$subjRawdataDir/*.bvec
bval=$subjRawdataDir/*.bval

cd /cubric/collab/354_sleepms
chmod +x compute_DTI_martyna.csh
cd $subjRawdataDir
/cubric/collab/354_sleepms/compute_DTI_martyna.csh -i $rawdata -b $bval -r $bvec

echo "****  running dti fit   ****"
subjExtractedBvalsDir=$rawdataDir/*"$subj"/"$time"_*/*_CHARMED_AP/output*
echo $subjExtractedBvalsDir

data=$subjExtractedBvalsDir/DWIseries.nii.gz
mask=$subjPreproDir/*_gibbsCorrSubVoxShift_TED_brain_mask.nii.gz
output=$subjPreproDir/"$subj"_"$time"_fslDTIfit_maxb1500
bvec=$subjExtractedBvalsDir/DTI_bvec
bval=$subjExtractedBvalsDir/DTI_bval

dtifit --data=`echo $data` \
--mask=`echo $mask` \
--out=`echo $output` \
--bvecs=`echo $bvec` \
--bvals=`echo $bval`

done
done

echo "DTIFIT done"
