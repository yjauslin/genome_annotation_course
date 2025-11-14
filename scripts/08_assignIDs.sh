#!/bin/bash 
#SBATCH --job-name=assignID          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-00:30:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/assignID_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/assignID_%j.err 

#save important directories as variables
WORKDIR=/data/users/${USER}/genome_annotation_course
COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin" 

#create result directory
mkdir $WORKDIR/results/final

#save input files as variables
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"

#save accession prefix as variable
prefix=Hiroshima

#move to input directory
cd $WORKDIR/annotation/

#copy files to resultdirectory and rename them
cp $gff $WORKDIR/results/final/${gff}.renamed.gff
cp $protein $WORKDIR/results/final/${protein}.renamed.fasta
cp $transcript $WORKDIR/results/final/${transcript}.renamed.fasta 

#move to resultdirectory
cd $WORKDIR/results/final 

#assign an ID to the found genes using maker_map/gff/fasta_ids
    $MAKERBIN/maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > id.map 
    $MAKERBIN/map_gff_ids id.map ${gff}.renamed.gff 
    $MAKERBIN/map_fasta_ids id.map ${protein}.renamed.fasta 
    $MAKERBIN/map_fasta_ids id.map ${transcript}.renamed.fasta 