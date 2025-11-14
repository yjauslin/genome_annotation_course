# Genome Annotation Course

## Description

This repository was created to store sripts created during the genome annotation course of the University of Fribourg. 
The code found in the scripts folder can be used to perform an entire genome annotation. In order to do so execute each file on the cluster starting with the smallest number. Files with a letter after the number should be executed in alphabetical order starting with a. Script 4b and 16b do not need to be executed at all as they are run by 4a and 16a respectively.
Please be aware that you may need to change some of the file paths to fit your folder structure in order to not receive any error messages. Besides 16b all R-Scripts were run locally with all the needed files in the same folder. To find the needed input files look for the name at the start of the scripts.

## Structure

### Scripts/
- **[01_runEDTA.sh](scripts/01_runEDTA.sh)**: Annotates transposable elements using EDTA.
- **[02a_sortTE.sh](scripts/02a_sortTE.sh)**: Refines TE classification and split them into clades using TEsorter.
- **[02b_full_length_LTRs_identity.R](scripts/02b_full_length_LTRs_identity.R)**: Plots identity-histograms of Copia- and Gypsy-family TEs               
- **[02c_annotation_circlize.R](scripts/02c_annotation_circlize.R)**: Plots positions of various TE superfamilies and clades in the scaffolds of the assembly        
- **[03_runTESorter.sh](scripts/03_runTESorter.sh)**: runs TESorter to extract Copia and Gypsy sequences.
- **[04a_TEDating.sh](scripts/04a_TEDating.sh)**: dates the TEs by executing the perl script 04b.
- **[04b_parseRM.pl](scripts/04b_parseRM.pl)**: Executed by 04a to date the TEs.
- **[04c_plot_div.R](scripts/04c_plot_div.R)**: Creates landscape plots from the results of 4a/4b.
- **[05_createControlFileMaker.sh](scripts/05_createControlFileMaker.sh)**: Creates a controlfile used in the next step for  MAKER. Before executing the next script make sure to manually adjust the settings to your preference in the file created by this script.
- **[06_runMaker.sh](scripts/06_runMaker.sh)**: Annotates the assembly using MAKER.
- **[07_prepareMakerOutput.sh](scripts/07_prepareMakerOutput.sh)**: Converts the results of MAKER into gff-files.
- **[08_assignIDs.sh](scripts/08_assignIDs.sh)**: gives the annotated genes unique IDs.
- **[09_runInterProScan.sh](scripts/09_runInterProScan.sh)**: Uses InterProScan to annotate protein sequences with functional domains.
- **[10_calculateAED.sh](scripts/10_calculateAED.sh)**: Incorporates the InterProScan functional annotations into the GFF3 file using ipr_update_gff and then calculates Annotation Edit Distance (AED).
- **[11_filteringFeatures.sh](scripts/11_filteringFeatures.sh)**: Filters the GFF file for quality and gene features and then removes bad-quality gene models from the FASTA files.
- **[12_runBuscoAnnotation.sh](scripts/12_runBuscoAnnotation.sh)**: Extracts the longest protein and transcript per gene and then uses BUSCO to evaluate the quality.
- **[13_runAgat.sh](scripts/13_runAgat.sh)**: uses AGAT to generate comprehensive statistics about gene annotations.
- **[14_queryBlast.sh](scripts/14_queryBlast.sh)**: queries Uniprot and Arabidopsis thaliana TAIR10 representative gene models using BLAST to find homologies to the annotated genes.
- **[15_createGENESPACEFiles.sh](scripts/15_createGENESPACEFiles.sh)**: prepares and creates files and correct folder structure to run GENESPACE in the next step.
- **[16a_runGENESPACE.sh](scripts/16a_runGENESPACE.sh)**: runs 16b_runGENESPACE.R in a container to compare different genomes.
- **[16b_runGENESPACE.R](scripts/16b_runGENESPACE.R)**: Uses GENESPACE to identify orthogroups, orthologues and to extract syntenic regions from various genomes.
- **[16c_process_pangenome.R](scripts/16c_process_pangenome.R)**: Uses the pangenomematrix created by GENESPACE in 16a/b to extract data like genes in core of the accession, unique genes in the accession and visualizes the number of genes and orthogroups.

### plots/
- **[01_LTR_Copia_Gypsy_cladelevel.pdf](plots/01_LTR_Copia_Gypsy_cladelevel.pdf)**: Histograms of the abundance of Copia and Gypsy clades in the genome in pdf format.
- **[01_LTR_Copia_Gypsy_cladelevel.png](plots/01_LTR_Copia_Gypsy_cladelevel.png)**: Histograms of the abundance of Copia and Gypsy clades in the genome in png format.
- **[02_TE_density_clades.pdf](plots/02_TE_density_clades.pdf)**: Circos plot of Athila and CRM TEs marking their position in the assembly.
- **[02_TE_density.pdf](plots/02_TE_density.pdf)**: Circos plot showing the positions of various superfamilies in the assembly.
- **[04_te_landscape_plot.pdf](plots/04_te_landscape_plot.pdf)**: Landscape-plot of TEs showing how recently they inserted into the accessions genome.
- **[12_busco_figure.png](plots/12_busco_figure.png)**: BUSCO-plot of the longest peptide sequences of the annotation.
- **[16_TAIR10_bp.rip.pdf](plots/16_TAIR10_bp.rip.pdf)**: Riparian-plot comparing the genome of the accession with three different accessions and the TAIR10-database.
- **[16_pangenome_frequency_plot.pdf](plots/16_pangenome_frequency_plot.pdf)**: Visualizes number of genes and orthogroups of the five different genomes.
  
## Dependencies

### Tools

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
- **[BLAST (v2.15.0)](https://blast.ncbi.nlm.nih.gov/doc/blast-help/downloadblastdata.html#id1)**

### R-Packages

The following R-packages were used in the R-scripts during the analysis. Install them beforehand using install.packages("name_of_the_package") or BiocManager:install("name_of_the_package") after having installed BiocManager (if (!require("BiocManager", quietly = TRUE)); install.packages("BiocManager");
BiocManager::install(version = "3.22")).

- tidyverse
- data.table
- cowplot
- circlize
- ComplexHeatmap
- dplyr
- reshape2
- GENESPACE (provided in Container)
