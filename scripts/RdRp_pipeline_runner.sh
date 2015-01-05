# Files to run complete analysis

mkdir -p ../results

bash 1_Split_libraries_and_Denoise_at_97.sh

bash 2_reinflate_after_denoising.sh

Denoised_dir=../results/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97

## usage ./uchime.bash input.fasta outputdir
bash 3_uchime.sh $Denoised_dir/denoised_seqs.fasta $Denoised_dir/Chimera_checked

## use non-inflated sequences to more quickly BLAST for contaminants 
cat $Denoised_dir/centroids.fasta $Denoised_dir/singletons.fasta > $Denoised_dir/catsingletonsandcentroids.fasta

bash 4_Blast_bash_to_remove_contaminants.sh

#manually added back the no hits > 2 to the denoise_blast_nt_hit.fasta to get the file: denoise_blastnt_hit_with_no_hit_added_back_manually.fasta

bash 5_uchime_with_blasted_hits.sh

bash 6_fraggenescan_sequences.bash

# perl findduplicate.pl [input] [out] [dup out]
perl 7_findduplicate.pl $Denoised_dir/remove_contaminants_blast/chimera_check/FragGeneScanned/fraggenescane2.fasta $Denoised_dir/remove_contaminants_blast/chimera_check/FragGeneScanned/RdRP_aa_duplicates_removed24July2013_reverse.fasta $Denoised_dir/remove_contaminants_blast/chimera_check/FragGeneScanned/fgs_dup.faa

## pick OTUs at a range of 50-100 percent similarity
## output directory is $Denoised_dir/test_remove_contaminants_blast/chimera_check/FragGeneScanned/usearch/$ID"_identity"/
## gives centroids: $ID_DIR/"centroids_"$i"_identity.fasta"
bash 8_OTUpickingafterFragGeneScan.sh

## make OTU table from 95% identity OTUs
## generates: $Denoised_dir/test_remove_contaminants_blast/chimera_check/FragGeneScanned/usearch/95identity/RdRp_OTUs_long_OTU_table.csv
python 9_make_long_OTU_table.py

## manupulate long table into regular species abundance type table
## generates: "RdRpAmplicons/results/usearch//95identity/RdRp_OTUs_table.csv"
Rscript 10_parsing_long_otu_table_into_species_abundance_table.R


## remove sequences from OTU table that are not alignable
## needs: $Denoised_dir/test_remove_contaminants_blast/chimera_check/FragGeneScanned/usearch/95identity/RdRp_OTUs_table.csv")
##  FIX!!!! sequences: "RdRpAmplicons/data/OTUs_95identity_removed_unalignable_no_gaps_longer_than_75aa.fasta")
## generates: $Denoised_dir/test_remove_contaminants_blast/chimera_check/FragGeneScanned/usearch/95identity/RdRp_OTUs_table_only_alignable_and_over_75aa.csv
Rscript 11_filter_OTU_table_based_on_alignable_sequences.R

## gets genbank data from accession numbers pulled from the literature and parses it into information
## useful for analysis
## needs: ../data/reference_data/Cully_environmental_seqeunce_data_gi_numbers.txt
bash 12_getting_accession_info_from_genbank.sh

## needs: ../data/OTUs_95_longer_than_75aa_and_greater_than_5_occurences.fasta  
## generates alignment that is sent to RaXML webserver
bash 13_clustering_known_environmental_and_aligning_454_seqs_to_reference.sh

## uses clustered environmental sequences to generate the info
## generates: "Clusters_for_Culley.tsv"
bash 14_generating_list_of_genbank_ids_by_cluster_for_paper.py ../results/Culley_env_sequences_clustered_95.uc "Clusters_for_Culley.tsv"

## needs: "../results/usearch/95identity/RdRp_OTUs_table.csv"
## generates: rarefaction curve plot before removing less abundant OTUs
Rscript 15_rarefaction_curves_by_lib.R

## needs: "../results/usearch/95identity/RdRp_OTUs_table_only_alignable_and_over_75aa.csv"
## generates: RdRpAmplicons/results/AllOTUs_rarefied_by_lowest_Mid_(date).csv",
Rscript 16_normalization_of_OTU_table_by_reads_per_library.R

mkdir -p ../figures

## needs: ../data/EnvironmentalParametersForRdRpMids.csv
Rscript Figure_Environmental_Params_with_range.R

## needs: RdRpAmplicons/results/AllOTUs_rarefied_by_lowest_Mid_(date).csv"
## Generates: RdRpAmplicons/figures/Euler_diagram_RdRp_SOG_shared_OTUs_normalized.pdf
## RdRpAmplicons/figures/Euler_diagram_RdRp_SOG_shared_OTUs_normalized.pdf
Rscript Figure_Euler_diagram_of_OTUs_by_site.R

## needs: RdRpAmplicons/data/Lat_lon_stations.csv"
## Generates: RdRpAmplicons/figures/", paste("station_map_", Sys.Date(), ".eps"
Rscript Figure_Map_of_stations.R

## needs; RdRpAmplicons/results/AllOTUs_rarefied_by_lowest_Mid_(date).csv"
## needs RAxML tree: RdRpAmplicons/data/Alignments/RAxML_bipartitions.NBCI_with_Culley_env_95_with_454_data_trimalled_no_colons_renamed"	
## generates: tree : RdRpAmplicons/results/", paste("RdRP_tree_rotated_reverse"
## points to classify tips of tree: RdRpAmplicons/figures/", paste("tree_with_points","_", Sys.Date(), ".eps"
## heatmap: RdRpAmplicons/figures/", paste("heatmap_ggplot","_", Sys.Date(), ".eps"	
## table of diversity metrics	
Rscript Figure_phylogenetic_tree_with_heatmap.R

## needs:RdRpAmplicons/results/AllOTUs_rarefied_by_lowest_Mid_(date).csv"
## generates: Rank_abundances_points_side_by_side", Sys.Date(), ".eps"
Rscript Figure_Rank_abundance_curves.R


bash 17_getting_list_of_sequences_to_upload_to_NCBI.sh




