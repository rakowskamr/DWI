# DWI
Analysis pipeline for diffusion-weighted MRI (DWI). 
Input: Multi-shell DWI data (here CHARMED)
Output: Statistical test results for FA (fractional anisotropy), MD (mean diffusivity), and Fr (restricted water fraction) maps. 

# Step-by-step analysis instructions

1. Preprocessing, aka the 'Modular pipeline' steps
* Supp_human_bet_mask
* DWI_proc_SOLID
* DWI_proc_gibbs_SubVoxShift
* DWI_sort_refPA
* DWI_proc_TED
* DWI_proc_DTI_fit -> choose nonlinear & maxb value = 1500!
* DWI_proc_DTI_maps
* DWI_proc_CHARMED_fit
* DWI_proc_CHARMED_maps
*-> output: Fr maps

2. FSL DTIfit
* dtifit_fsl_bmax1500_final.sh 
*-> output: MD/FA maps

3. Coregister, normalise, smooth in SPM
* extract the brain first (from T1) 
* coregister DWI images to a brain extracted T1 image
* smooth with 8 mm Gaussian kernel
*-> output: swFA/MD/FR

4. Prepare images
* Copy files to the FinalFSLDTI folder (S1, S2, S3), subtract sessions and put the subtraction files in the relevant folders (S1S2, S2S3, S1S3)
* Merge images into a single 4D file using fslmerge.
* The 4D file will be used as the only image for the design matrix so each design matrix needs to have a separate 4D file.
* fslmerge merges the files in its own order, check it with ‘ls’. That order needs to match the order of participants in the design matrix
*-> 4D file

7. GLM
* open FSL > MISC > GLM setup > higher level
* use 1 EV for a simple 1-way t-test; 2 EVs for 1 way t-test with covs
* set EV1 as 1 for everyone; set EV2 as the actual covariate value
* set the contrast to either [1] or [0 1] (or negative 1)
*-> design matrix

8. FSL Randomise (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Randomise/UserGuide)
* use fsl randomise
* input: fsl merge 4D file
* output: output directory
* requires a design matrix and a mask

9. FSL Palm (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM)
* use fsl palm
* input: fsl merge 4D file
* output: output directory
* requires a design matrix and a mask

# Requirements

The pipeline requires MATLAB with SPM12 toolbox (https://www.fil.ion.ucl.ac.uk/spm/), FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) and the Modular pipeline developed by Chantal Tax and Greg Parker (see Tax et al., 2021; Genc et al., 2020)

# Authors and contributors
* Martyna Rakowska
* Mara Cercignani
* Alberto Lazari

# Relevant methods section from Rakowska et al. (2022):

DW-MRI data pre-processing was performed as described in previous publications 71,72. The pre-processing steps included (1) Slicewise OutLIer Detection (SOLID) 73; (2) full Fourier Gibbs ringing correction 74 using Mrtrix mrdegibbs software 75; and (3) a combined topup, eddy and DISCO step 76 to (i) estimate susceptibility-induced off-resonance field and correct for the resulting distortions using images with reversed phase-encoding directions, (ii) correct for eddy current distortions and (iii) correct for gradient nonlinearity. To generate Mean Diffusivity (MD) maps, the diffusion tensor model was fitted to the data using the DTIFIT command in FSL for shells with b < 1500 s/mm2. To estimate Restricted Water Fraction (Fr) metric, the composite hindered and restricted model of diffusion (CHARMED) was fitted to the data using an in-house non-linear least square fitting algorithm 77 coded in MATLAB 2015a. The two indices (MD, Fr) were chosen based on the existing human literature on the microstructural changes following learning (MD: 26,27,29,30 Fr: 28). MD describes the average mobility of water molecules and has shown sensitivity to changes in grey matter 26,29,30. MD is thought to reflect the underlying, learning-dependent remodelling of neurons and glia, i.e., synaptogenesis, astrocytes activation and brain-derived neurotrophic factor (BDNF) expression, as confirmed by histological findings 26, which were of particular interest in this study. As opposed to DTI, the CHARMED model separates the contribution of water diffusion from the extra-axonal (hindered) and intra-axonal (restricted) space 32, thereby providing a more sensitive method to look at the microstructural changes than DTI 28. Fr is one of the outputs from the CHARMED framework. In grey matter, Fr changes are thought to reflect remodelling of dendrites and glia, and were observed both short-term (2 h) and long-term (1 week) following a spatial navigation task 28.

Co-registration, spatial normalisation and smoothing of the MD and Fr maps were performed in SPM12, running under MATLAB 2015a. First, we co-registered the pre-processed diffusion images with participants’ structural images using a rigid body model. The co-registration output was then spatially normalised to MNI space. This step involved resampling to 2 mm voxel with B-spline interpolation and utilised T1 deformation fields generated during fMRI analysis of the same participants 24. That way, the resulting diffusion images were in the same space as the fMRI and T1w data. Finally, the normalised data was smoothed with an 8 mm FWHM Gaussian kernel.

# References
* Tax, C. M., Kleban, E., Chamberland, M., Baraković, M., Rudrapatna, U., & Jones, D. K. (2021). Measuring compartmental T2-orientational dependence in human brain white matter using a tiltable RF coil and diffusion-T2 correlation MRI. NeuroImage, 236, 117967.
* Genc, S., Tax, C. M., Raven, E. P., Chamberland, M., Parker, G. D., & Jones, D. K. (2020). Impact of b‐value on estimates of apparent fibre density. Human brain mapping, 41(10), 2583-2595.
* Rakowska, M., Lazari, A., Cercignani, M., Bagrowska, P., Johansen-Berg, H., & Lewis, P. A. (2022). Distributed and gradual microstructure changes track the emergence of behavioural benefit from memory reactivation. bioRxiv.
