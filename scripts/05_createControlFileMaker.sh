#!/bin/bash 
#SBATCH --job-name=controlfile            # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=4          # e.g. 20 
#SBATCH --mem=10G                      # e.g. 64G or 200G 
#SBATCH --time=0-00:30:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/controlfile_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/controlfile_%j.err 

#save working- and container-directory as variables
WORKDIR=/data/users/${USER}/genome_annotation_course/annotation
CONTAINER=/data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif

#create working directory
mkdir -p $WORKDIR 

#move to working directory
cd $WORKDIR

#run maker to create ccontrol file
apptainer exec --bind /data $CONTAINER maker -CTL
