#!/bin/bash 
#SBATCH --job-name=InterProScan          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-02:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/InterProScan_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/InterProScan_%j.err 

#save important directories as variables
WORKDIR=/data/users/${USER}/genome_annotation_course
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 

#save path to input file as variable
protein=$WORKDIR/results/final/assembly.all.maker.proteins.fasta.renamed.fasta

#move to input directory
cd $WORKDIR/results/final/

#run InterProScan on input file
apptainer exec --bind /data --bind $SCRATCH:/temp --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
    $COURSEDIR/containers/interproscan_latest.sif \
    /opt/interproscan/interproscan.sh \
    -appl pfam --disable-precalc -f TSV \
    --goterms --iprlookup --seqtype p \
    -i ${protein} -o output.iprscan 