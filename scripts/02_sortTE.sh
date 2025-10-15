#!/bin/bash 
#SBATCH --job-name=sortTE          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64                      # e.g. 64G or 200G 
#SBATCH --time=0-24:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/sortTE_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/sortTE_%j.err 

WORKDIR=/data/users/${USER}/genome_annotation_course 
CONTAINER=/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif

apptainer exec --bind $WORKDIR $CONTAINER TEsorter ERR11437318.bp.p_ctg.fa.mod.EDTA.raw/ERR11437318.bp.p_ctg.fa.mod.LTR.raw.fa \
    -db rexdb-plant