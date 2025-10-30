#!/bin/bash 
#SBATCH --job-name=busco          # e.g. TE_annotation 
#SBATCH --partition=pshort_el8           # IBU cluster partition 
#SBATCH --cpus-per-task=20          # e.g. 20 
#SBATCH --mem=64G                      # e.g. 64G or 200G 
#SBATCH --time=0-02:00:00                    # format D-HH:MM, e.g. 2-00:00 
#SBATCH --output=/data/users/yjauslin/genome_annotation_course/logs/busco_%j.out 
#SBATCH --error=/data/users/yjauslin/genome_annotation_course/logs/busco_%j.err


cd /data/users/yjauslin/genome_annotation_course/results/final/

module load BUSCO/5.4.2-foss-2021a
module load SAMtools/1.13-GCC-10.3.0

# Define file names - ADJUST THESE based on what files actually exist
protein="assembly.all.maker.proteins.renamed.filtered.fasta"
transcript="assembly.all.maker.transcripts.renamed.filtered.fasta"

# Extract Longest Protein Isoforms
awk '/^>/ {
    if (seqlen > maxlen[gene]) {
        maxlen[gene] = seqlen
        seq[gene] = header "\n" sequence
    }
    header = $0
    gene = $0
    sub(/^>/, "", gene)
    sub(/-R.*/, "", gene)
    sequence = ""
    seqlen = 0
    next
}
{
    sequence = sequence $0
    seqlen += length($0)
}
END {
    if (seqlen > maxlen[gene]) {
        maxlen[gene] = seqlen
        seq[gene] = header "\n" sequence
    }
    for (g in seq) print seq[g]
}' "$protein" > "assembly.all.maker.proteins.renamed.filtered.longest.fasta"

busco -i assembly.all.maker.proteins.renamed.filtered.longest.fasta -l brassicales_odb10 -o busco_output -m proteins
