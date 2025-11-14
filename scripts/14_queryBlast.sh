#!/bin/bash 
#SBATCH --job-name=Blast          # e.g. TE_annotation 
#SBATCH --partition=pshort_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=10          # e.g. 20 
#SBATCH --mem=10G                      # e.g. 64G or 200G 
#SBATCH --time=0-01:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/Blast_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/Blast_%j.err

#save important directories as variables
WORKDIR=/data/users/yjauslin/genome_annotation_course
OUTDIR=$WORKDIR/results/blast
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin" 

#create output directory
mkdir $OUTDIR

#move to output directory
cd $OUTDIR

#load BLAST module
module load BLAST+/2.15.0-gompi-2021a

#makeblastb -in $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa -dbtype prot # this step is already done 

#search for matches of protein sequences in the uniprot database
blastp -query $WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.longest.fasta -db $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa -num_threads 10 -outfmt 6 -evalue 1e-5 -max_target_seqs 10 -out $OUTDIR/blastp_output_uniprot

#extract the best hits from uniprot query
sort -k1,1 -k12,12g $OUTDIR/blastp_output_uniprot | sort -u -k1,1 --merge > blastp_output_uniprot.besthits

#copy input files and rename them
cp $WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.fasta maker_proteins.fasta.Uniprot 
cp $WORKDIR/results/final/filtered.genes.renamed.gff3 filtered.maker.filtered.gff3.Uniprot 

# Uses maker_functional_fasta to add UniProt-based functional annotations to the MAKER protein FASTA.    
    $MAKERBIN/maker_functional_fasta $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa blastp_output_uniprot.besthits maker_proteins.fasta.Uniprot > maker_proteins.filtered.fasta.Uniprot
#Uses maker_functional_gff to update the MAKER GFF3 annotation file with functional descriptions derived from UniProt matches.
    $MAKERBIN/maker_functional_gff $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa  blastp_output_uniprot.besthits filtered.maker.filtered.gff3.Uniprot  > filtered.maker.gff3.Uniprot.gff3

#search for matches of protein sequences in the TAIR10 database
blastp -query $WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.longest.fasta -db $COURSEDIR/data/TAIR10_pep_20110103_representative_gene_model -num_threads 10 -outfmt 6 -evalue 1e-5 -max_target_seqs 10 -out $OUTDIR/blastp_output_TAIR10
#extract the best hits from TAIR10 query
sort -k1,1 -k12,12g blastp_output_TAIR10 | sort -u -k1,1 --merge > $OUTDIR/blastp_output_TAIR10.besthits