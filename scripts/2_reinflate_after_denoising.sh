#!/bin/bash
## Author:Julia Gustavsen
##  Last edit: 7 May 2013
##  Reinflate denoiser output from qiime 1.7 
##  Reinflation recreates the reads and their relative abundance after the denoising process have flattened many errors. 
## Requires: Output from denoiser.py from qiime
## Generates: denoised_seqs.fasta

In_dir=../results/split_libraries_output/AllMids9August2012/Reverse
Denoised_dir=$In_dir/titanium/denoised97


Centroids=$Denoised_dir/centroids.fasta
Singletons=$Denoised_dir/singletons.fasta
Sequences=$In_dir/seqs.fna
Denoiser_mapping=$Denoised_dir/denoiser_mapping.txt
output_file=$Denoised_dir/denoised_seqs.fasta


inflate_denoiser_output.py -c $Centroids -s $Singletons -f $Sequences -d $Denoiser_mapping -o $output_file

