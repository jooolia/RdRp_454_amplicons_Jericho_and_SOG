#!/bin/bash
## Author:  Author: Xi A Tian (alvinxtian@hotmail.com)
## Modified by: Julia Gustavsen


## directory containing NCBI databases
DB_DIR=/Data/blastdb
IN_DIR2=/Data/Julia/qiime/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97
OUT_DIR=/Data/Julia/qiime/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/remove_contaminants_blast
SCRIPT_DIR=./perl_scripts

mkdir -p $OUT_DIR
#run blastx on viruses
echo =========================================================================
echo "remove contaminants"
echo =========================================================================

mkdir -p $OUT_DIR/
echo blast against the gene

blastx -query $IN_DIR2/catsingletonsandcentroids.fasta -db $DB_DIR/RDRPdbP -evalue 1e-3 -outfmt 6 -out $OUT_DIR/denoise_blast.result -num_threads 10 -max_target_seqs 1

#parse hit and non hit
perl $SCRIPT_DIR/parseusearch.pl $OUT_DIR/denoise_blast.result $IN_DIR2/catsingletonsandcentroids.fasta $OUT_DIR/denoise_blast_hit.fasta $OUT_DIR/denoise_blast_nohit.fasta

echo blast no hit agaisnt nr

blastx -query $OUT_DIR/denoise_blast_nohit.fasta -db nr -evalue 1e-5 -out $OUT_DIR/_nohit_blast.result -num_threads 10 -num_descriptions 1 -num_alignments 1

echo parse no hits
#parse no hit
perl $SCRIPT_DIR/blast_parser.pl <$OUT_DIR/_nohit_blast.result >$OUT_DIR/_nohit_blast_parsed.result


#parse no hit and hit sequence data
# parameters perl label.pl [blastresult file] [original fasta] [no hit outputfile] [hits outfile]

perl $SCRIPT_DIR/parse_blastnohits.pl $OUT_DIR/_nohit_blast.result $IN_DIR2/catsingletonsandcentroids.fasta $OUT_DIR/_denoise_blastnt_nohit.fasta $OUT_DIR/_denoise_blastnt_hit.fasta




