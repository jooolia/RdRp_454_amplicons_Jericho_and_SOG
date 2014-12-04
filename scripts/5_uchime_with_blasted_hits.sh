#!/bin/bash

#usage ./uchime.bash input.fasta outputdir

## Author: Xi A Tian (alvinxtian@hotmail.com )
## usearch version: usearch_i86linux32 v6.1.544
## Modified from original by: Julia Gustavsen
## Last edit: October 1, 2012

ABSKEW=2       # Abundance skew for de novo chimera filtering
UCHIME_REFDB=/Data/Julia/qiime/PicornaLikedb.fasta #RefDB for UCHIME
u=usearch

input=/Data/Julia/qiime/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/remove_contaminants_blast/denoise_blastnt_hit_with_no_hit_added_back_manually.fasta
outdir=/Data/Julia/qiime/split_libraries_output/AllMids9August2012/Reverse/titanium/denoised97/remove_contaminants_blast/chimera_check
mkdir -p $outdir



echo
echo =========================================================================
echo "Chimera filter de novo, output tmp1.fa."
echo =========================================================================
$u -uchime_denovo $input -chimeras $outdir/chimeras_denovo.fa -nonchimeras $outdir/tmp1.fa -uchimeout $outdir/denovo.uchime -log $outdir/uchimedn.log -abskew $ABSKEW
if [ $? != 0 ] ; then
	exit 1
fi
ls -l $outdir/tmp1.fa
nseqs_dn=`grep ">" $outdir/tmp1.fa | wc -l`
cp $outdir/chimeras_denovo.fa $outdir/chimeras_denovo.fa
echo $nseqs_dn seqs after de novo chimera filter

echo
echo =========================================================================
echo "Chimera filter ref. db., output tmp2.fa"
echo =========================================================================
$u -uchime_ref $input -db $UCHIME_REFDB -strand plus -uchimeout $outdir/refdb.uchime -chimeras $outdir/chimeras_ref.fa -nonchimeras $outdir/tmp2.fa -log $outdir/uchimedb.log

if [ $? != 0 ] ; then
	exit 1
fi
ls -l $outdir/tmp2.fa
nseqs_db=`grep ">" $outdir/tmp2.fa | wc -l`
echo $nseqs_db seqs after ref db chimera filter

echo
echo =========================================================================
echo "Take the intersect of the two chimera methods"
echo =========================================================================
cat $outdir/chimeras_denovo.fa $outdir/chimeras_ref.fa > $outdir/ch1.fa

perl -e ' $unique=0; $total=0; while(<>) { if (/^>\S+/) { $total++; if (! ($seen{$&}++)) { $print_it = 0 } else { $unique++; $print_it = 1 } }; if ($print_it) { print $_ }; } warn "\nChose $unique intersect chimera records out of $total total.\n\n"; ' $outdir/ch1.fa > $outdir/ch.fa 

echo
echo =========================================================================
echo "Merge and remove redundant non-chimeras"
echo =========================================================================

cat $outdir/tmp1.fa $outdir/tmp2.fa > $outdir/tmp12.fa

perl -e ' $unique=0; $total=0; while(<>) { if (/^>\S+/) { $total++; if (! ($seen{$&}++)) { $unique++; $print_it = 1 } else { $print_it = 0 } }; if ($print_it) { print $_ }; } warn "\nChose $unique nonredundant non-chimera records out of $total total.\n\n"; ' $outdir/tmp12.fa > $outdir/non_chimera_final.fa 


