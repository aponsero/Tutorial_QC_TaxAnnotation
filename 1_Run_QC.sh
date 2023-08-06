#!/bin/bash -l
#SBATCH --job-name=QC_HumanFilt
#SBATCH --account=
#SBATCH --output=outputr%j.txt
#SBATCH --error=errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=1000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config.txt

# load environment
module load biokit

# echo for log
echo "job started"; hostname; date

## START BOWTIE 2 HUMAN FILTERING ###
mkdir -p "$OUTPUT_DIR/1.QC_step"
BOWTIE_NAME="$OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_host_removed_R%.fastq.gz"
SAM_NAME="$OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_host.sam"
MET_NAME="$OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_hostmap.log"

echo "################ HUMAN READ FILTERING ###################"
echo "bowtie2 -p 10 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME"
bowtie2 -p 10 -x $HUM_DB -1 $PAIR1 -2 $PAIR2 --un-conc-gz $BOWTIE_NAME 1> $SAM_NAME 2> $MET_NAME


## START QC 
module purge
export PATH="${TRIM_bin}:$PATH"
echo "################ READ QC ###################"
trim_galore --paired -o $OUTPUT_DIR/1.QC_step --fastqc $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_host_removed_R1.fastq.gz $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_host_removed_R2.fastq.gz

## clean folder
mkdir $OUTPUT_DIR/1.QC_step/qc_logs
mv $OUTPUT_DIR/1.QC_step/*.log $OUTPUT_DIR/1.QC_step/qc_logs
mv $OUTPUT_DIR/1.QC_step/*.txt $OUTPUT_DIR/1.QC_step/qc_logs
mv $OUTPUT_DIR/1.QC_step/*.html $OUTPUT_DIR/1.QC_step/qc_logs
rm $OUTPUT_DIR/1.QC_step/*.sam
rm $OUTPUT_DIR/1.QC_step/*_host_removed_R1.fastq.gz
rm $OUTPUT_DIR/1.QC_step/*_host_removed_R2.fastq.gz
rm $OUTPUT_DIR/1.QC_step/*.zip
mv $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_host_removed_R1_val_1.fq.gz $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_QC_R1.fastq.gz
mv $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_host_removed_R2_val_2.fq.gz $OUTPUT_DIR/1.QC_step/${SAMPLE_NAME}_QC_R2.fastq.gz


