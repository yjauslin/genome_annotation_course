#!/bin/bash 
#SBATCH --job-name=agat          # e.g. TE_annotation 
#SBATCH --partition=pshort_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-01:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/agat_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/agat_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
CONTAINER=$COURSEDIR/containers/agat_1.5.1--pl5321hdfd78af_0.sif

cd /data/users/${USER}/genome_annotation_course/results/final/

apptainer exec --bind /data $CONTAINER agat_sp_statistics.pl -i filtered.genes.renamed.gff3 -o annotation.stat