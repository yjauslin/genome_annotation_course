#!/bin/bash 
#SBATCH --job-name=Blast          # e.g. TE_annotation 
#SBATCH --partition=pshort_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=10          # e.g. 20 
#SBATCH --mem=10G                      # e.g. 64G or 200G 
#SBATCH --time=0-01:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/Blast_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/Blast_%j.err

WORKDIR=/data/users/yjauslin/genome_annotation_course
OUTDIR=$WORKDIR/results/blast
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin" 



mkdir $OUTDIR

cd $OUTDIR

module load BLAST+/2.15.0-gompi-2021a

#makeblastb -in $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa -dbtype prot # this step is already done 

blastp -query $WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.fasta -db $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa -num_threads 10 -outfmt 6 -evalue 1e-5 -max_target_seqs 10 -out $OUTDIR/blastp_output_uniprot # Now sort the blast output to keep only the best hit per query sequence 

sort -k1,1 -k12,12g $OUTDIR/blastp_output_uniprot | sort -u -k1,1 --merge > blastp_output_uniprot.besthits

cp $WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.fasta maker_proteins.fasta.Uniprot 
cp $WORKDIR/results/final/filtered.genes.renamed.gff3 filtered.maker.filtered.gff3.Uniprot 
    
    $MAKERBIN/maker_functional_fasta $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa blastp_output_uniprot.besthits maker_proteins.fasta.Uniprot > maker_proteins.filtered.fasta.Uniprot 
    $MAKERBIN/maker_functional_gff $COURSEDIR/data/uniprot/uniprot_viridiplantae_reviewed.fa  blastp_output_uniprot.besthits filtered.maker.filtered.gff3.Uniprot  > filtered.maker.gff3.Uniprot.gff3

blastp -query $WORKDIR/results/final/assembly.all.maker.proteins.renamed.filtered.fasta -db $COURSEDIR/data/TAIR10_pep_20110103_representative_gene_model -num_threads 10 -outfmt 6 -evalue 1e-5 -max_target_seqs 10 -out $OUTDIR/blastp_output_TAIR10 # Now sort the blast output to keep only the best hit per query sequence 
sort -k1,1 -k12,12g blastp_output_TAIR10 | sort -u -k1,1 --merge > $OUTDIR/blastp_output_TAIR10.besthits