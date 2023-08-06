# Tutorial_QC_TaxAnnotation
Simple Tutorial for performing QC and Taxonomic annotation on Whole Genome Shotgun on HPC system (Puthi CSC)

## Installation
First clone the repository on your scratch space:

```
module load git
git clone https://github.com/aponsero/Tutorial_QC_TaxAnnotation.git
```

Then install the necessary tools and download databases:

```
cd Tutorial_QC_TaxAnnotation

## intallation TrimGalore
mkdir -p tools/TrimGalore
module purge
module load tykky
wrap-container -w /usr/local/bin docker://quay.io/biocontainers/trim-galore:0.6.10--hdfd78af_0 --prefix tools/TrimGalore

## Human reference database for Bowtie2
mkdir tools/bowtie2_db
cd tools/bowtie2_db
wget https://genome-idx.s3.amazonaws.com/bt/GRCh38_noalt_as.zip
unzip GRCh38_noalt_as.zip
cd ../..
```

Finally edit the **1_Run_QC.sh** and **2_Run_Kraken.sh** files to specify your CSC project ID line (#SBATCH --account=project_0000000)

## Run pipeline

### Edit the config file

Edit the **config.txt** file for the following lines:
- PAIR1 = Path to the file pair 1
- PAIR2 = Path to the file pair 2
- SAMPLE_NAME = Name of the sample (will be use to generate the output names
- OUTPUT_DIR = path to output directory

## Run QC and human filtering step.

Submit the QC and human filtering step :
```
sbatch 1_Run_QC.sh
```
This step will run Bowtie2 against the human genome to remove the human reads, and TrimGalore! to remove reads with poor QC and primers.

## Run the Taxonomic profiling step.

Submit the Taxonomic annotation step :
```
sbatch 2_Run_Kraken.sh
```
This step will run the QC'd reads against the microbe standard database from Kraken2 and generate a taxonomic annotation profile.




