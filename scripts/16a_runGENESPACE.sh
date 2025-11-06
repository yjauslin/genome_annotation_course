#!/bin/bash 
#SBATCH --job-name=GENESPACE          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-24:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/GENESPACE_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/GENESPACE_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
WORKDIR=/data/users/${USER}/genome_annotation_course

chmod u+x $WORKDIR/scripts/16b_prepareGENESPACE.R

apptainer exec --bind $COURSEDIR --bind $WORKDIR --bind $SCRATCH:/temp --bind /data \
    $COURSEDIR/containers/genespace_latest.sif Rscript $WORKDIR/scripts/16b_runGENESPACE.R $WORKDIR/results/genespace