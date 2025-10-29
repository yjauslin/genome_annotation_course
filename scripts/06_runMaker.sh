#!/bin/bash 
#SBATCH --job-name=maker            # e.g. TE_annotation 
#SBATCH --partition=pibu_el8           # IBU cluster partition 
#SBATCH --mem=200G                      # e.g. 64G or 200G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=50 
#SBATCH --time=7-00:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/maker_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/maker_%j.err 

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation" 
WORKDIR="/data/users/${USER}/genome_annotation_course/annotation" 

cd $WORKDIR

REPEATMASKER_DIR="/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker" 
export PATH=$PATH:"/data/courses/assembly-annotation-course/CDS_annotation/softwares/RepeatMasker" 

module load OpenMPI/4.1.1-GCC-10.3.0 
module load AUGUSTUS/3.4.0-foss-2021a 

mpiexec --oversubscribe -n 50 apptainer exec \
 --bind $SCRATCH:/TMP --bind $COURSEDIR --bind $AUGUSTUS_CONFIG_PATH --bind $REPEATMASKER_DIR --bind /data \
  ${COURSEDIR}/containers/MAKER_3.01.03.sif \
  maker -mpi --ignore_nfs_tmp -TMP /TMP maker_opts.ctl maker_bopts.ctl maker_evm.ctl maker_exe.ctl 
