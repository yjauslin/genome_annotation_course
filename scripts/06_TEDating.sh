#!/bin/bash 
#SBATCH --job-name=TEdating            # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=4          # e.g. 20 
#SBATCH --mem=10G                      # e.g. 64G or 200G 
#SBATCH --time=00-02:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/TEdating_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/TEdating_%j.err 

cp /data/courses/assembly-annotation-course/CDS_annotation/scripts/05-parseRM.pl /data/users/${USER}/genome_annotation_course/scripts

INPUT=/data/users/${USER}/genome_annotation_course/results/EDTA_annotation/ERR11437318.bp.p_ctg.fa.mod.EDTA.anno/ERR11437318.bp.p_ctg.fa.mod.out

cd /data/users/${USER}/genome_annotation_course/results/TE_classification

module add BioPerl/1.7.8-GCCcore-10.3.0
perl /data/users/${USER}/genome_annotation_course/scripts/05-parseRM.pl -i $INPUT -l 50,1 -v