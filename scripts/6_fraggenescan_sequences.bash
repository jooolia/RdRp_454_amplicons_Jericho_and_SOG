#!/bin/bash

## Translating sequences using FragGeneScan 1.16 with 454 training settings. 
## Author: Xi A Tian (alvinxtian@hotmail.com )
## Modified from original by: Julia Gustavsen


FGS_DIR=/Data/software/FragGeneScan1.16
IN_DIR=../results/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/remove_contaminants_blast/chimera_check
OUT_DIR=../results/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/remove_contaminants_blast/chimera_check/FragGeneScanned
SCRIPT_DIR=./perl_scripts

mkdir -p $OUT_DIR

echo =========================================================================
echo "Fraggenescan"
echo =========================================================================

$FGS_DIR/./run_FragGeneScan.pl -genome=$IN_DIR/non_chimera_final.fa -out $OUT_DIR/fgs -complete=0 -train=454_10

echo "end"
#Trim header 
perl $SCRIPT_DIR/header_mod.pl $OUT_DIR/fgs.faa $OUT_DIR/fraggenescane2.fasta

#print length distribution report
perl $SCRIPT_DIR/count_fasta.pl -i 30 $IN_DIR/non_chimera_final.fa >$OUT_DIR/a.report

sed '1 i nuceotide' $OUT_DIR/a.report >$OUT_DIR/a2.report

perl $SCRIPT_DIR/count_fasta.pl $OUT_DIR/fraggenescane2.fasta >$OUT_DIR/b.report

sed '1 i amino acid' $OUT_DIR/b.report >$OUT_DIR/b2.report

cat $OUT_DIR/a2.report $OUT_DIR/b2.report > $OUT_DIR/count.report

rm $OUT_DIR/a.report $OUT_DIR/a2.report $OUT_DIR/b.report $OUT_DIR/b2.report

