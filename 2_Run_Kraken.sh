#!/bin/bash -l
#SBATCH --job-name=Kraken
#SBATCH --account=
#SBATCH --output=outputr%j.txt
#SBATCH --error=errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=70G


# load job configuration
cd $SLURM_SUBMIT_DIR
source config.txt

# load environment
module load biokit

# echo for log
echo "job started"; hostname; date

## START KRAKEN2 annotation" 
mkdir -p "$OUTPUT_DIR/2.Kraken"

echo "################ KRAKEN ANNOTATION ###################"
kraken2 --paired --db krak_microb --report $OUTPUT_DIR/2.Kraken/${SAMPLE_NAME}_profile $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_QC_R1.fastq.gz $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_QC_R2.fastq.gz

## clean folder


