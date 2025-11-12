#!/bin/bash 
#SBATCH --job-name=TEsorter          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=4          # e.g. 20 
#SBATCH --mem=10G                      # e.g. 64G or 200G 
#SBATCH --time=0-02:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/TEsorter_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/TEsorter_%j.err 

#save important directories as variables
WORKDIR=/data/users/${USER}/genome_annotation_course 
CONTAINER=/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif
GENOME=/data/users/${USER}/genome_annotation_course/results/EDTA_annotation/ERR11437318.bp.p_ctg.fa.mod.EDTA.TElib.fa

cd $WORKDIR/results/TE_classification

module load SeqKit/2.6.1

#Extract Copia sequences
seqkit grep -r -p "Copia" $GENOME > Copia_sequences.fa

#Extract Gypsy sequences
seqkit grep -r -p "Gypsy" $GENOME > Gypsy_sequences.fa

apptainer exec --bind /data $CONTAINER TEsorter Copia_sequences.fa -db rexdb-plant

apptainer exec --bind /data $CONTAINER TEsorter Gypsy_sequences.fa -db rexdb-plant