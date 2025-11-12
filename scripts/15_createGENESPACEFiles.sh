#!/bin/bash 
#SBATCH --job-name=createGENESPACE          # e.g. TE_annotation 
#SBATCH --partition=pshort_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=10          # e.g. 20 
#SBATCH --mem=10G                      # e.g. 64G or 200G 
#SBATCH --time=0-01:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/createGENESPACE_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/createGENESPACE_%j.err

#save important directories and path to files as variables
WORKDIR=/data/users/${USER}/genome_annotation_course
Accession=Hiroshima
TAIR10_fasta=/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.fa
TAIR10_bed=/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10.bed
PEPTIDE=$WORKDIR/results/genespace/peptide
PROTEIN=$WORKDIR/results/genespace/bed
LONGEST_FASTA=$WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.longest.fasta
fasta_files=/data/courses/assembly-annotation-course/CDS_annotation/data/Lian_et_al/protein/selected
gff_files=/data/courses/assembly-annotation-course/CDS_annotation/data/Lian_et_al/gene_gff/selected

#create input/result directory  for genespace
mkdir $WORKDIR/results/genespace
mkdir $PEPTIDE
mkdir $PROTEIN

#create bed file for Hiroshima accession
grep -P "\tgene\t" $WORKDIR/results/final/filtered.genes.renamed.gff3 > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/${Accession}.bed

#copy TAIR10 fasta-file and accession fasta file as well as three other accession files to peptide folder
#rename the files to fit requirements of genespace 
cp $TAIR10_fasta $PEPTIDE
cp $LONGEST_FASTA $PEPTIDE/${Accession}.fa
cp $fasta_files/Etna-2.protein.faa $PEPTIDE/Etna_2.fa
cp $fasta_files/Ice-1.protein.faa $PEPTIDE/Ice_1.fa
cp $fasta_files/Taz-0.protein.faa $PEPTIDE/Taz_0.fa

#remove -RA suffix at the end from the ID and rest of the information to fit correct formatting for genespace
sed -i -E '/^>/ s/-R[A-Z]\b//; s/ .*$//' $PEPTIDE/${Accession}.fa

#copy gff files of all the accessions into protein directory, also copy the bed file from TAIR10
cp $TAIR10_bed $PROTEIN
cp $gff_files/Etna-2.EVM.v3.5.ann.protein_coding_genes.gff $PROTEIN
cp $gff_files/Ice-1.EVM.v3.5.ann.protein_coding_genes.gff $PROTEIN
cp $gff_files/Taz-0.EVM.v3.5.ann.protein_coding_genes.gff $PROTEIN

#create bed files from the previously copied gff-files
grep -P "\tgene\t" $gff_files/Etna-2.EVM.v3.5.ann.protein_coding_genes.gff > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/Etna_2.bed

grep -P "\tgene\t" $gff_files/Ice-1.EVM.v3.5.ann.protein_coding_genes.gff > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/Ice_1.bed

grep -P "\tgene\t" $gff_files/Taz-0.EVM.v3.5.ann.protein_coding_genes.gff > $WORKDIR/results/final/temp_genes.gff3

awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' $WORKDIR/results/final/temp_genes.gff3 > $PROTEIN/Taz_0.bed

#move to protein
cd $PROTEIN

#remove the gff-files
rm *.gff

#create list of all selected accessions fa and bed files
files=($PEPTIDE/Etna_2.fa $PEPTIDE/Ice_1.fa $PEPTIDE/Taz_0.fa $PROTEIN/Etna_2.bed $PROTEIN/Ice_1.bed $PROTEIN/Taz_0.bed)

#loop over files and replace - with _ so it fits genespace requirements
for file in "${files[@]}"; do 
    echo "Processing: '$file'"
    sed -i -E 's/-/_/g' "$file"
done