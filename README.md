# Genome Annotation Course

## Description

This repository was created to store sripts created during the genome annotation course of the University of Fribourg. 
The code found in the scripts folder can be used to perform an entire genome annotation. In order to do so execute each file on the cluster starting with the smallest number. 
Please be aware that you may need to change some of the file paths to fit your folder structure in order to not receive any error messages. 

## Structure

### Scripts/
- **[01_runEDTA.sh](scripts/01_runEDTA.sh)**:             Annotates transposable elements using EDTA.
- **[02a_sortTE.sh](scripts/02a_sortTE.sh)**:                  Refines TE classification and split them into clades using TEsorter.
- **[02b_full_length_LTRs_identity.R](scripts/02b_full_length_LTRs_identity.R)**:                  
- **[02c_annotation_circlize.R](scripts/02c_annotation_circlize.R)**:                  
- **[03_runTESorter.sh](scripts/03_runTESorter.sh)**:
- **[04a_TEDating.sh](scripts/04a_TEDating.sh)**:
- **[04b_parseRM.pl](scripts/04b_parseRM.pl)**:
- **[04c_plot_div.R](scripts/04c_plot_div.R)**
- **[05_createControlFileMaker.sh](scripts/05_createControlFileMaker.sh)**:
- **[06_runMaker.sh](scripts/06_runMaker.sh)**:
- **[07_prepareMakerOutput.sh](scripts/07_prepareMakerOutput.sh)**
- **[08_assignIDs.sh](scripts/08_assignIDs.sh)**
- **[09_runInterProScan.sh](scripts/09_runInterProScan.sh)**
- **[10_calculateAED.sh](scripts/10_calculateAED.sh)**
- **[11_filteringFeatures.sh](scripts/11_filteringFeatures.sh)**
- **[12_runBuscoAnnotation.sh](scripts/12_runBuscoAnnotation.sh)**
- **[13_runAgat.sh](scripts/13_runAgat.sh)**
- **[](scripts/)**

### plots/
- **[01_LTR_Copia_Gypsy_cladelevel.pdf](plots/01_LTR_Copia_Gypsy_cladelevel.pdf)**
- **[01_LTR_Copia_Gypsy_cladelevel.png](plots/01_LTR_Copia_Gypsy_cladelevel.png)**
- **[02_TE_density_clades.pdf](plots/02_TE_density_clades.pdf)**
- **[02_TE_density.pdf](plots/02_TE_density.pdf)**
- **[04_te_landscape_plot.pdf](plots/04_te_landscape_plot.pdf)**
  
## Dependencies

Below you can find a list with all the tools used during the assemblies including their versions in the parentheses. While newer versions may be able to accomplish the same results, an errorfree analysis cannot be guaranteed.

- **[EDTA (v2.2.2)](https://github.com/oushujun/EDTA)**
- **[TEsorter (v1.3.0)](https://github.com/zhangrengang/TEsorter)**
- **[R (v4.5.1)](https://www.r-project.org)**
- **[R-Studio (v2025.9.1.401)](https://posit.co/download/rstudio-desktop)**
- **[SeqKit (v2.6.1)](https://bioinf.shenwei.me/seqkit)**
- **[BioPerl (v1.7.8)](https://bioperl.org)**
- **[MAKER (v3.01.03)](https://hpc.nih.gov/apps/maker.html)**
- **[OpenMPI (v4.1.1)](https://www.open-mpi.org)**
- **[AUGUSTUS (v3.4.0)](https://github.com/Gaius-Augustus/Augustus)**
- **[InterProScan (v5.70-102.0)](https://www.ebi.ac.uk/interpro/about/interproscan)**
- **[UCSC utils (v448-foss-2021a)](https://genome.ucsc.edu)**
- **[MariaDB (v10.6.4)](https://mariadb.org)**
- **[BUSCO (5.4.2)](https://busco.ezlab.org)**
- **[SAMtools (v1.13)](https://www.htslib.org)**
- **[agat (v1.5.1)](https://github.com/NBISweden/AGAT)**