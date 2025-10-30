#!/bin/bash 
#SBATCH --job-name=MakerOutput          # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=100G                      # e.g. 64G or 200G 
#SBATCH --time=0-00:30:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/MakerOutput_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/MakerOutput_%j.err 

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 

cd /data/users/yjauslin/genome_annotation_course/annotation

MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin" 
   $MAKERBIN/gff3_merge -s -d ERR11437318.bp.p_ctg.maker.output/ERR11437318.bp.p_ctg_master_datastore_index.log > assembly.all.maker.gff 
   $MAKERBIN/gff3_merge -n -s -d ERR11437318.bp.p_ctg.maker.output/ERR11437318.bp.p_ctg_master_datastore_index.log > assembly.all.maker.noseq.gff 
   $MAKERBIN/fasta_merge -d ERR11437318.bp.p_ctg.maker.output/ERR11437318.bp.p_ctg_master_datastore_index.log -o assembly 