#!/bin/bash 
#SBATCH --job-name=EDTA            # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=40          # e.g. 20 
#SBATCH --mem=200G                      # e.g. 64G or 200G 
#SBATCH --time=0-24:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/EDTA_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/EDTA_%j.err 

#save important paths as variables
WORKDIR=/data/users/${USER}/genome_annotation_course 
GENOME=/data/users/${USER}/assembly_annotation_course/hifiasm_assembly/ERR11437318.bp.p_ctg.fa
CONTAINER=/data/courses/assembly-annotation-course/CDS_annotation/containers/EDTA2.2.sif

#create output directory
mkdir -p $WORKDIR/results/EDTA_annotation 

#move to output directory
cd $WORKDIR/results/EDTA_annotation 

#run EDTA
apptainer exec --bind /data $CONTAINER EDTA.pl --genome $GENOME \
    --species others \
    --step all \
    --sensitive 1 \
    --cds "/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated" \
    --anno 1 \
    --threads $SLURM_CPUS_PER_TASK \
    --force 1