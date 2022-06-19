# auto merge MD for MDFr

questionList="Q1
Q2
Q3"

questionList="Q1"
analysisList="MWFT1" #MDFr MWFT1
modalityList="FA" #MD_flipped Fr MWF T1 T1_flipped

for question in $questionList; do
  for analysis in $analysisList; do
    for modality in $modalityList; do

cd /cubric/collab/354_sleepms/PALM/Data/$question/"$analysis"/withoutP12/$modality

ls
fslmerge -t merged_$modality /cubric/collab/354_sleepms/PALM/Data/$question/"$analysis"/withoutP12/"$modality"/*.nii


done
done
done


questionList="Q2"
analysisList="MWFT1" #MDFr MWFT1
modalityList="FA" #MD_flipped Fr MWF T1 T1_flipped

for question in $questionList; do
  for analysis in $analysisList; do
    for modality in $modalityList; do

cd /cubric/collab/354_sleepms/PALM/Data/"$question"/"$analysis"/CBcovN2/S1S2_CBS2/"$modality"

ls
fslmerge -t merged_$modality /cubric/collab/354_sleepms/PALM/Data/"$question"/"$analysis"/CBcovN2/S1S2_CBS2/"$modality"/*.nii


done
done
done


questionList="Q3"
analysisList="MWFT1" #MDFr MWFT1
modalityList="FA" #MD_flipped Fr MWF T1 T1_flipped

for question in $questionList; do
  for analysis in $analysisList; do
    for modality in $modalityList; do

cd /cubric/collab/354_sleepms/PALM/Data/"$question"/"$analysis"/"$modality"

ls
fslmerge -t merged_$modality /cubric/collab/354_sleepms/PALM/Data/"$question"/"$analysis"/"$modality"/*.nii


done
done
done
