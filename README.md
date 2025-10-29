# Genome Annotation Course

## Description

This repository was created to store sripts created during the genome annotation course of the University of Fribourg. 
The code found in the scripts folder can be used to perform an entire genome annotation. In order to do so execute each file on the cluster starting with the smallest number. 
Please be aware that you may need to change some of the file paths to fit your folder structure in order to not receive any error messages. 

## Structure

### Scripts/
- **[01_runEDTA.sh](scripts/01_runEDTA.sh)**:             Annotates transposable elements using EDTA.
- **[02_sortTE](scripts/02_sortTE.sh)**:                  Refines TE classification and split them into clades using TEsorter.
- **[03_runTESorter.sh](scripts/03_runTESorter.sh)**:
- **[04_createControlFileMaker.sh](scripts/04_createControlFileMaker.sh)**:
- **[05-parseRM.pl](scripts/05-parseRM.pl)**:
- **[05_runMaker.sh](scripts/05_runMaker.sh)**:
- **[06_TEDating.sh](scripts/06_TEDating.sh)**:

## Dependencies

Below you can find a list with all the tools used during the assemblies including their versions in the parentheses. While newer versions may be able to accomplish the same results, an errorfree analysis cannot be guaranteed.

- **[EDTA (v2.2.2)](https://github.com/oushujun/EDTA)**
- **[TEsorter (v1.3.0)](https://github.com/zhangrengang/TEsorter)**
- **[Maker (v3.01.03)](https://hpc.nih.gov/apps/maker.html)**
- **[OpenMPI (v4.1.1)](https://www.open-mpi.org)**
- **[AUGUSTUS (v3.4.0)](https://github.com/Gaius-Augustus/Augustus)**
- **[XXX (v1.0.0)](XXX)**
