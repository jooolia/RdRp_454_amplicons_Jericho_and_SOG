#! /usr/bin/perl -w
use strict;
use diagnostics;

# parameters perl header_mod.pl [inputfile] [outputfile] 
# remove anything after the "_" in header, use after fraggenescan to get rid of the extra header info
#last update: Dec 18th, 2011
open(INPUT, "$ARGV[0]");
open(OUT,">$ARGV[1]");

my $head;
while (<INPUT>)
{
	chomp $_;
	$head=$_;
	if ($_ =~ m/>/)
	{	
	my @tmpArray2 = split(/_/, $_);
	$head = $tmpArray2[0];
	}
	print OUT "$head\n";
}

close INPUT;
close OUT;

exit;
