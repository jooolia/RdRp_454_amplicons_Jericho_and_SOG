#!/usr/bin/env bash
## Created by Julia Gustavsen
## Date: 9 August 2012
## Split libraries.py and denoiser.py using qiime 1.7 (http://qiime.org/)
## Notes: 
## -needs qiime compatible mapping file. 
## -qiime commands do not work consistently with relative paths so it is necessary to use absolute paths when using this software suite. 


data_dir=../data

# Split libraries using reverse primer
mapping_file=$data_dir/Mapping_file_RdRp_rev.txt

## Data files are available on NCBI SRA
fna_files=$data_dir/TCA_454Reads_1.fna,$data_dir/454_Data/TCA_454Reads_2.fna,$data_dir/MMMV4/TCA_454Reads_1.fna,$data_dir/MMMV4/TCA_454Reads_2.fna

quality_files=$data_dir/TCA_454Reads_1.qual,$data_dir/TCA_454Reads_2.qual,$data_dir/MMMV4/TCA_454Reads_1.qual,$data_dir/MMMV4/TCA_454Reads_2.qual

split_library_output=../results/split_libraries_output/AllMids9August2012/Reverse/

echo "Splitting libraries"

split_libraries.py -m $mapping_file -f $fna_files  -q $quality_files  -l 100 -L 600 -w 50 -z truncate_only -d -b 10 -M 3 -o $split_library_output

echo "Denoising at 97 percent"

sff_files=$data_dir/GZ44C7M01.sff.txt,$data_dir/GZ44C7M02.sff.txt,$data_dir/MMMV4/G0X9B5C01.sff.txt,$data_dir/MMMV4/G0X9B5C02.sff.txt


# Split libraries using reverse primer
denoiser.py -v --percent_id 0.97 --titanium --primer CKYTTCARRAAWTCAGCATC -c -n 4 -i $sff_files -f $split_library_output'seqs.fna' -o $split_library_output"denoised97/"
