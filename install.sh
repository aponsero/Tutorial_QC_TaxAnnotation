
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


