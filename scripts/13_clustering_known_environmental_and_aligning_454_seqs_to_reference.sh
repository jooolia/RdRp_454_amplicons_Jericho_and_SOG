#!/bin/bash

## Author=Julia Gustavsen
## Last edited: 2 September 2014

## Use a collection of the marine viruses align using muscle. 
## Then I make sure to identify the sequences so that they can be removed later
## I add the NCBI taxonomy and then trim the alignment to the desired length.
## I need to keep looking at it using aliview so that I don't make mistakes. 
## I cat together previous environmental sequences and then cluster them at 95% identity.
## These are then added to the previous alignments. Alignthe 454 sequences and
## see which ones are not alignable. Remove them, then remove gaps and add 454 
## sequences to the existing alignment. Trim the 
## alignment using trimal and then make a test tree using Fasttree. 
## Send the alignment to RaxML webserver.

## aliview is used for viewing and editing sequence alignments and is available here: http://www.ormbunkar.se/aliview/
## FastTree version 2.1.7 SSE3 
usearch7=/home/julia/usearch/usearch7.0.1090_i86linux32
muscle_3=/home/muscle3.8.31_i86linux64
trimal=/home/julia/trimal/source/trimal
fasttree=/home/julia/FastTree

############# Align isolated marine viruses ####################
## Downloaded full length isolates of marine viruses in the Picornavirales
$muscle_3 --in ../data/reference_data/Marine_viruses_full_length.fasta -out ../data/Alignments/Marine_viruses_full_length_aligned.fasta

## trim it so that it is just the RdRp section
 $trimal -in  ../data/Alignments/Marine_viruses_full_length_aligned.fasta -out ../data/Alignments/Marine_viruses_trimmal.fasta -selectcols { 0-1823,2115-3128 } -fasta

aliview ../data/Alignments/Marine_viruses_trimmal.fasta 

## Trimming alignments to desired columns encasing the RdRp
## Alignment from the NCBI CDD database: 
## http://www.ncbi.nlm.nih.gov/Structure/cdd/cddsrv.cgi?uid=cd01699
 $trimal -in  ../data/reference_data/NCBI_CDD_RdRP_alignment_only_Picornaviridae_only_seco_dicistro_iflavir.fasta -out ../data/Alignments/NCBI_CDD_RdRP_alignment_only_Picornaviridae_only_seco_dicistro_iflavir_trimmal.fasta -selectcols { 0-3058,3355-3742 } -fasta

aliview ../data/Alignments/NCBI_CDD_RdRP_alignment_only_Picornaviridae_only_seco_dicistro_iflavir_trimmal.fasta


########### Getting the OTU and environmental files set up ###################
## Cluster sequences retrieved from accession numbers in cited papers. 
cat ../data/reference_data/Culley_2003_protein.fasta ../data/reference_data/Culley_2014_amplified_sequences_protein.fasta ../data/reference_data/Culley_2007_sequence_protein.fasta > ../data/reference_data/Culley_environmental_sequence_data.fasta

## use the same procedure on Genbank accessed files as on the 454 data in this study. 
 $usearch7 -cluster_smallmem ../data/reference_data/Culley_environmental_sequence_data.fasta -usersort -strand both -id 0.95 -sizeout -centroids ../results/Culley_env_sequences_clustered_95.fasta -uc ../results/Culley_env_sequences_clustered_95.uc

## Produces fasta file with OTUs intstead of the weird header names for clusters
python rename_OTUs_from_collected_list_of_accession_numbers.py

######### Align 454 sequences and then remove those that are not alignable ################
## Use only those >75aa

$usearch7 -sortbylength ../results/usearch/95identity/RdRp_OTUs_95identity.fasta -output ../data/Alignments/RdRp_OTUs_95identity_over75aa.fasta -minseqlength 75

$muscle_3 -in ../data/Alignments/RdRp_OTUs_95identity_over75aa.fasta -out ../data/Alignments/RdRp_OTUs_95identity_over75aa_aligned.fasta

## check and manually edit alignment
aliview ../data/Alignments/RdRp_OTUs_95identity_over75aa_aligned.fasta



############# Add marine RNA viruses to the NCBI alignment ############
$muscle_3 -profile -in1 ../data/Alignments/Marine_viruses_trimmal.fasta -in2 ../data/Alignments/NCBI_CDD_RdRP_alignment_only_Picornaviridae_only_seco_dicistro_iflavir_trimmal.fasta -out ../data/Alignments/NBCI_with_marine_added_homologs_double_seed.fasta

aliview ../data/Alignments/NBCI_with_marine_added_homologs_double_seed.fasta


## Add environmental data from Genbank to the whole alignment (NCBI reference alignment with Marine viruses). 
$muscle_3 -profile -in1 ../results/Culley_env_sequences_clustered_95.fasta  -in2 ../data/Alignments/NBCI_with_marine_added_homologs_double_seed.fasta  -out ../data/Alignments/NBCI_with_Culley_env_95.fasta

## edited
aliview ../data/Alignments/NBCI_with_Culley_env_95.fasta


####### Add in the 454 data to the overall alignment. ###################
$muscle_3 -profile -in1 ../data/Alignments/RdRp_OTUs_95identity_over75aa_aligned.fasta -in2 ../data/Alignments/NBCI_with_Culley_env_95.fasta  -out ../data/Alignments/NBCI_with_Culley_env_95_with_454_data.fasta

aliview ../data/Alignments/NBCI_with_Culley_env_95_with_454_data.fasta


## then do automated trimming
 $trimal -in  ../data/Alignments/NBCI_with_Culley_env_95_with_454_data.fasta -out ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled.fasta -fasta -htmlout ../data/Alignments/NBCI_with_Culley_env_at_95_with_454_data_trimalled.html -automated1

 aliview ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled.fasta

#### Cosmetic tidying before tree-building and visualizing ####
## remove semi-colons
sed 's/\;/_/g;s/\+//g' ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled.fasta  > ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons.fasta  


## Rename sequences to something more user friendly (and this will also be useful for sending to RaxML)

## python script renames things based on the tab-separated table with names found in alignment file and what they should be renamed as. 
## usage: python Renaming_sequences_in_alignment_for_phylogenetic_tree.py renaming_file alignment_file renamed_alignment
python Renaming_sequences_in_alignment_for_phylogenetic_tree.py ../data/table_to_rename_sequence_data_for_readable_tree.txt ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons.fasta ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed.fasta
     

aliview ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed.fasta


######## Test tree building, visualization and model testing. ###############

## check alignment by using FastTree for estimation
$fasttree ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed.fasta   > ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed.tree

## Visualize tree with Figtree. 
java -jar /home/julia/FigTree/FigTree_v1.4.0/lib/figtree.jar ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed.tree 

### Model test beofre sending to RaxML
java -jar /home/julia/prottest-3.4-20140123/prottest-3.4.jar -i ../data/Alignments/NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed.fasta

## Send alignment to RaxML server. http://embnet.vital-it.ch/raxml-bb/