#!/bin/bash 
#SBATCH --job-name=createGENESPACE          # e.g. TE_annotation 
#SBATCH --partition=pshort_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=10          # e.g. 20 
#SBATCH --mem=10G                      # e.g. 64G or 200G 
#SBATCH --time=0-01:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/createGENESPACE_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/createGENESPACE_%j.err

WORKDIR=/data/users/${USER}/genome_annotation_course
Accession=Hiroshima
TAIR10_fasta=/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.fa
TAIR10_bed=/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.bed
PEPTIDE=$WORKDIR/results/genespace/peptide
PROTEIN=$WORKDIR/results/genespace/bed
LONGEST_FASTA=$WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.longest.fasta
fasta_files=/data/courses/assembly-annotation-course/CDS_annotation/data/Lian_et_al/genome/selected
gff_files=/data/courses/assembly-annotation-course/CDS_annotation/data/Lian_et_al/gene_gff/selected


mkdir $WORKDIR/results/genespace
mkdir $PEPTIDE
mkdir $PROTEIN

grep -P "\tgene\t" $WORKDIR/results/final/filtered.genes.renamed.gff3 > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/${Accession}.bed


cp $TAIR10_fasta $PEPTIDE
cp $LONGEST_FASTA $PEPTIDE/${Accession}.fa
cp $fasta_files/Etna-2.fasta $PEPTIDE
cp $fasta_files/Ice-1.fasta $PEPTIDE
cp $fasta_files/Taz-0.fasta $PEPTIDE

#remove -RA suffix at the end from the ID and rest of the information to fit correct formatting for genespace
sed -i -E '/^>/ s/-R[A-Z]\b//; s/ .*$//' $PEPTIDE/${Accession}.fa

cp $TAIR10_bed $PROTEIN
cp $gff_files/Etna-2.EVM.v3.5.ann.protein_coding_genes.gff $PROTEIN
cp $gff_files/Ice-1.EVM.v3.5.ann.protein_coding_genes.gff $PROTEIN
cp $gff_files/Taz-0.EVM.v3.5.ann.protein_coding_genes.gff $PROTEIN

grep -P "\tgene\t" $gff_files/Etna-2.EVM.v3.5.ann.protein_coding_genes.gff > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/Etna-2.bed

grep -P "\tgene\t" $gff_files/Ice-1.EVM.v3.5.ann.protein_coding_genes.gff > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/Ice-1.bed

grep -P "\tgene\t" $gff_files/Taz-0.EVM.v3.5.ann.protein_coding_genes.gff > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/Taz-0.bed

cd $PROTEIN

rm *.gff