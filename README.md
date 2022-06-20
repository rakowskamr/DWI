# DWI_analysis
Analysis pipeline for diffusion-weighted MRI (DWI). 
Input: Multi-shell DWI data (here the Composite Hindered and Restricted Model of Diffusion, CHARMED)
Output: Statistical test results for FA (fractional anisotropy), MD (mean diffusivity), and Fr (restricted water fraction) maps. 

# The analysis step-by-step 

1. Modular pipeline
* CHARMED_pipeline_Modular_DTI_CHARMED_IRLLS.xml - exemplar pre-processing pipeline with the following steps:
  * Supp_human_bet_mask
  * DWI_proc_SOLID - perform Slicewise OutLIer Detection (SOLID) outlier detection on targeted DW images
  * DWI_proc_gibbs_SubVoxShift - full Fourier Gibs ringing correction/artifact removal based on local subvoxel-shifts 
  * DWI_sort_refPA - attaches a refPA object to your data
  * DWI_proc_TED - combined topup, eddy and disco (gradnonlin) correction to (i) estimate susceptibility-induced off-resonance field and correct for the resulting distortions using images with reversed phase-encoding directions, (ii) correct for eddy current distortions and (iii) correct for gradient nonlinearity
  * (optional: DWI_proc_DTI_fit -> choose nonlinear DTI fitting routine & maxb value = 1500!)
  * (optional: DWI_proc_DTI_maps - produce DTI maps from previous fit results)
  * DWI_proc_CHARMED_fit - selection of CHARMED fitting routines used to estimate Fr metric, non-linear least square fitting algorithm is recommended
  * DWI_proc_CHARMED_maps - takes the 15-28 CHARMED parameters and turns them into Fr maps
  * -> output: Fr maps
* Modular_subject_pipeline_p5.xml - exemplar file with subject directories for the analysis
* ModularPipelineBash.m - identifies the .xml files and runs the preprocessing for selected participant
* RunOnClusternew.sh - sends ModularPipelineBash.m to the cluster to preprocess all participants in parallel
* SUBJECTS.txt - list of participants requited for RunOnClusternew.sh to run

2. FSL DTIfit
* compute_DTI_martyna.csh - extract shells with b < 1500 s/mm2 (only for multishell data)
* dtifit_fsl_bmax1500.sh - fit diffusion tensor model to the data to generate MD and FA maps
* -> output: MD/FA maps

3. Coregister, normalise, smooth in SPM
* CoregisterNormalise.m - extract the brain from a T1w image and coregister DWI images with participant's own brain extracted T1w image; normalise the output to MNI space
* Smooth.m - smooth with 8 mm Gaussian kernel
* -> output: swFA/MD/FR

4. Prepare images
* CopyFiles.m - Copy files to the FinalFSLDTI folder (S1, S2, S3)
* SubtractImages.m - Subtract sessions and put the subtraction files in the relevant folders (S1S2, S2S3, S1S3)
* 4DMerge.sh - Merge images into a single 4D file using fslmerge
  * The 4D file will be used as the only image for the design matrix so each design matrix needs to have a separate 4D file
  * fslmerge merges the files in its own order, check the order with with ‘ls’. That order needs to match the order of participants in the design matrix
* -> 4D file

FSL-GUI-STEP: Create General Linear Model (GLM) and design matrix using FSL GUI
* open FSL > MISC > GLM setup > higher level
* use 1 EV for a simple 1-way t-test; 2 EVs for 1 way t-test with covs
* to run a correlation, set EV1 as 1 for everyone; set EV2 as the actual covariate value
* set the contrast to either [1] or [0 1] (or negative 1)
* -> design matrix

5. Run FSL Randomise (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Randomise/UserGuide)
* Randomise.sh - nonparametric permutation inference on neuroimaging data
  * input: fsl merge 4D file
  * output: statistical maps
  * requires a design matrix and a mask

6. or run FSL PALM (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM) <- the final statistical analysis performed in Rakowska et al. (2022)
* The scripts perform analysis for 3 different quesitons:
  * Q1: Relationship between baseline brain characteristics and TMR susceptibility
  * Q2: Relationship between microstructural plasticity (patterns across the two MRI markers) and TMR benefit across time
  * Q3: Control analysis = relationship between microstructural plasticity and participants' sex, baseline performance, and general sleep patterns
* 4DMerge4PALM.sh the images depending on the question asked. 
* Q1/S2/Q3script.sh - use FSL PALM to perform Non-Parametric Combination (NPC) for joint inference over multiple modalities (MD and Fr) for each question
  * input: fsl merge 4D file
  * output: statistical mpas
  * requires a design matrix and a mask
* Datapoints.sh - Extract individual datapoints to check for outliers

# Requirements

The pipeline requires MATLAB with SPM12 toolbox (https://www.fil.ion.ucl.ac.uk/spm/), FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) and the Modular pipeline developed by Chantal Tax and Greg Parker (see Tax et al., 2021; Genc et al., 2020). Use MicroGL (https://www.nitrc.org/projects/mricrogl) to display results.

# Authors and contributors
* Martyna Rakowska
* Alberto Lazari
* Mara Cercignani

# Relevant methods section from Rakowska et al. (2022):

5.7.2 DW-MRI DATA PRE-PROCESSING
5.7.3.2 MULTIMODAL ANALYSIS
5.7.3.3 UNIMODAL ANALYSIS
5.7.3.4 REGIONS OF INTEREST

# References
* Tax, C. M., Kleban, E., Chamberland, M., Baraković, M., Rudrapatna, U., & Jones, D. K. (2021). Measuring compartmental T2-orientational dependence in human brain white matter using a tiltable RF coil and diffusion-T2 correlation MRI. NeuroImage, 236, 117967.
* Genc, S., Tax, C. M., Raven, E. P., Chamberland, M., Parker, G. D., & Jones, D. K. (2020). Impact of b‐value on estimates of apparent fibre density. Human brain mapping, 41(10), 2583-2595.
* Rakowska, M., Lazari, A., Cercignani, M., Bagrowska, P., Johansen-Berg, H., & Lewis, P. A. (2022). Distributed and gradual microstructure changes track the emergence of behavioural benefit from memory reactivation. bioRxiv.
