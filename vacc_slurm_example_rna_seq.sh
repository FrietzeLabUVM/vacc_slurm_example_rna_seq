#!/bin/sh

#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --time=03:00:00
#SBATCH --mem=60GB
#SBATCH --mail-user=seth.frietze@med.uvm.edu
#SBATCH --job-name=Cahan_RNAseq
#SBATCH --output=/users/s/f/sfrietze/Cahan/RNAseq/myjob.out

##The first line is called the "shebang" or "hashbang", it specifies 
##to the computer that this is a shell file ".sh".
##it is not always necessary but can help the computer 
##figure out what it is supposed to do with the file
##if there are ever any inconsistencies. 

##The '#SBATCH' lines are preprocessor lines for the SLURM
##job scheduler. This information tells SLURM which parameters 
##to use to run the coputational job on VACC. 
##make sure to check the VACC user manual, available online,
##when setting these parameters. 

##First, let's tell our script where to find the main STAR program.
##If installed globally, you should just be able to set it to "STAR"
##Otherwise, you will need to specify the exact path.
path_to_star="STAR"

##Now, set the directory variable below to the location that
##houses your fastq files:
##For the drosophila RNA-Seq analysis, the fastq.gz files were located
##in the following directory:
files_dir="/users/s/f/sfrietze/FRIETZE_LAB_SEQUENCING/Frietze_PR_iLabs_15180_100720"

##Now specifify the file ending to search for:
file_ending=".fastq.gz"

##Specify the path the the STAR reference directory. 
##You may need to create the reference with STAR, before,
##running alignment. Consult the STAR user manual for 
##further details.
##For example, for the drosophila RNA-Seq study,
##a drosophila reference directory was created using the 
##NCBI RefSeq .FASTA and .GTF files called STAR_dm6
star_genome_ref_dir="/users/s/f/sfrietze/genome_index/STAR_dm6"

##Now let's set an output directory for our STAR alignment results.
##For the drosophila RNA-Seq study the output directory was as follows:
output_dir="/users/s/f/sfrietze/Cahan/RNAseq"

##Now we will store the fastq.gz file names as an array:
arrayNow=($(find $files_dir -type f -name "*$file_ending"))

##Finally, we will loop through the array, processing each fastq.gz file
##one at a time:
for file in "${arrayNow[@]}" 
do

##Run STAR with the below parameters for each .fastq.gz file.
##(remember to consult the STAR manual, or an individual versed
##in running STAR, if you have questions about any of the below
##parameters

$path_to_star \
--runThreadN 16 \
--genomeDir $star_genome_ref_dir \
--readFilesIn $file \
--outFilterMultimapScoreRange 1 \
--outFilterMultimapNmax 20 \
--outFilterMismatchNmax 10 \
--alignIntronMax 500000 \
--alignMatesGapMax 1000000 \
--sjdbScore 2 \
--alignSJDBoverhangMin 1 \
--readFilesCommand zcat \
--outFilterMatchNminOverLread 0.2 \
--outFilterScoreMinOverLread 0.2 \
--sjdbOverhang 99 \
--outSAMtype BAM SortedByCoordinate \
--outFileNamePrefix $output_dir"/"$(basename $file "$file_ending") \
--quantMode TranscriptomeSAM

done

