#!/bin/bash 
#SBATCH --job-name=filtering          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-01:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/filtering_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/filtering_%j.err

WORKDIR=/data/users/${USER}/genome_annotation_course
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin" 

gff=assembly.all.maker.noseq
protein=assembly.all.maker.proteins.fasta
transcript=assembly.all.maker.transcripts.fasta

cd $WORKDIR/results/final

perl $MAKERBIN/quality_filter.pl -s ${gff}.renamed.iprscan.gff > ${gff}_iprscan_quality_filtered.gff

# We only want to keep gene features in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
# Check
cut -f3 filtered.genes.renamed.gff3 | sort | uniq

module load UCSC-Utils/448-foss-2021a
module load MariaDB/10.6.4-GCC-10.3.0

grep -P "\tmRNA\t" filtered.genes.renamed.gff3 | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' > list.txt
faSomeRecords ${transcript}.renamed.fasta list.txt assembly.all.maker.transcripts.renamed.filtered.fasta
faSomeRecords ${protein}.renamed.fasta list.txt assembly.all.maker.proteins.renamed.filtered.fasta