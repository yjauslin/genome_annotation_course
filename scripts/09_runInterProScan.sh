#!/bin/bash 
#SBATCH --job-name=InterProScan          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-02:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/InterProScan_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/InterProScan_%j.err 

WORKDIR=/data/users/${USER}/genome_annotation_course
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 

protein=$WORKDIR/results/final/assembly.all.maker.proteins.fasta.renamed.fasta

cd $WORKDIR/results/final/

apptainer exec --bind /data --bind $SCRATCH:/temp --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
    $COURSEDIR/containers/interproscan_latest.sif \
    /opt/interproscan/interproscan.sh \
    -appl pfam --disable-precalc -f TSV \
    --goterms --iprlookup --seqtype p \
    -i ${protein} -o output.iprscan 