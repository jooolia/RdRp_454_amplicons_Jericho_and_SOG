#!/bin/bash

# Author=Julia Gustavsen
# Date=4 October 2012
# Date last modified= 24 July 2013
# Purpose of script= A for loop to do OTU picking at different identities. Will use this to determine which percentage will be best for use with viral sequences and using our control sequences. 

#These are sequences that have been translated using FragGeneScan
input=../results/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/test_remove_contaminants_blast/chimera_check/FragGeneScanned/RdRP_aa_duplicates_removed24July2013_reverse.fasta

#These are the sequences that have been sorted by size
outputsort=../results/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/test_remove_contaminants_blast/chimera_check/FragGeneScanned/usearch/seqs_sorted_size.fasta

#A place to put the output folders for this file. 
OUT_DIR=../results/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/test_remove_contaminants_blast/chimera_check/FragGeneScanned/usearch

usearch_dir=/home/julia/usearch
usearch7=$usearch_dir/usearch7.0.1090_i86linux32

mkdir $OUT_DIR
#A place for the sorted file that has been sorted and then has used sed to fix the header for use in usearch

#First need to sort the file by size. 
usearch -sortbysize $input -output $outputsort 

# Send all the output from these commands to a log file. 
exec > $OUT_DIR/OTUpickingviaUSEARCH49_100.log 2>&1

echo "------------OTU picking at different percent identities------------" 
 for i in {49..100}
do
		ID=`echo "$i / 100" | bc -l`
		echo $ID
		ID_DIR=$OUT_DIR/$i"identity"
		mkdir -p $ID_DIR
		echo $Percent
		$usearch7 -cluster_smallmem $outputsort -usersort -sizeout -sizein -centroids $ID_DIR/"centroids_"$i"_identity.fasta" -uc $ID_DIR/"clusters_"$i"_identity.uc" -id $ID
	
done   