#!/bin/bash

## Author=Julia Gustavsen
## Purpose of script= A for loop to do OTU picking at different identities. 
## Will use this to determine which percentage will be best for use with viral
## sequences and using our control sequences. 
## Using python scripts from Adina Chuang Howe (@teeniedeenie)
## to download metadeta from Genbank. 
## Parse genbank data into csv file. 

mkdir -p ../data/reference_data/metadata

python fetch_genomes.py ../data/reference_data/Cully_environmental_sequence_data_gi_numbers.txt ../data/reference_data/metadata

for x in ../data/reference_data/metadata/*
 do
python parsing_genbank.py $x 
 done
