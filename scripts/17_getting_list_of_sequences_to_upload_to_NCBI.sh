
## Need to convert OTUs that align back to nucleotide files

## new file with otu numbers
protein_seqs_to_submit=../data/Alignments/OTUs_95_longer_than_75aa_and_greater_than_5_occurences_aligned_no_gaps.fasta
## has headers like this: >OTU_54

## aa file before removal
protein_seqs_with_original_names=../results/usearch/95identity/RdRp_OTUs_95identity.fasta
## Have headers like this: >GZ44C7M01EAAVC;size=97191;



## >GZ44C7M02I6PUW;size=2;

## original nucleotide sequences fgs.ffn
## >GZ44C7M02I6PUW;size=2;1_4145-
nucleotide_seqs_cut_to_tranlation_frame=../results/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/remove_contaminants_blast/chimera_check/FragGeneScanned/fgs.ffn

## so need to match and split header after ;

#so need names of all original sequences that are being used: match the seuqences?
#then use the names to pull out the original nucleotide sequences..

python pull_out_nucleotide_seqs_from_translated_aligned_protein_seqs.py $protein_seqs_to_submit $protein_seqs_with_original_names $nucleotide_seqs_cut_to_tranlation_frame ../data/Alignments/Nucleotide_OTUs_95_longer_than_75aa_and_greater_than_5_occurences_aligned_no_gaps.fasta