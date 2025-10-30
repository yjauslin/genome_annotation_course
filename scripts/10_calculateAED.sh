#!/bin/bash 
#SBATCH --job-name=AED          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-01:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/AED_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/AED_%j.err 

WORKDIR=/data/users/${USER}/genome_annotation_course
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin" 

gff=assembly.all.maker.noseq.gff

cd $WORKDIR/results/final

    $MAKERBIN/ipr_update_gff ${gff}.renamed.gff output.iprscan > assembly.all.maker.noseq.renamed.iprscan.gff     

perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 ${gff}.renamed.gff > assembly.all.maker.renamed.gff.AED.txt 