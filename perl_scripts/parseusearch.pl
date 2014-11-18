#! /usr/bin/perl -w
use strict;
use diagnostics;

# parameters perl label.pl [usearch file] [original fasta] [outputfile matched] [outfile no match]
#
open(USEARCH, "$ARGV[0]");
open(IN, "$ARGV[1]");
open(OUT,">$ARGV[2]");
open(OUT2,">$ARGV[3]");

#Stores all the headers parsed from usearch or blast outfile
my %headerHash = ();

while (<USEARCH>)
{
	my @array;
	chomp $_;
	@array = split(/\t/, $_);
	if(defined($array[0]))	
	{
	#store it in hash, same key/value pair
	#print $array[0];
	$headerHash{$array[0]} = $array[0];	
	}
}
close USEARCH;
#check what is in the hash
#while ( my ($key, $value) = each(%headerHash) ) {
#       print "key: $key\n";
#    }
    
my $writeflag = 0;
while (<IN>)
{
	my @tmpArray;
	chomp $_;
	if ($writeflag == 0 && !($_ =~ m/>/))
	{
		print OUT2 "$_\n";
	}
	if ($writeflag == 1 && !($_ =~ m/>/))
	{
		print OUT "$_\n";
		
	}
	
	
	
	#check if line is header
	if ($_ =~ m/^>/)
	{
		$_ =~ s/ $//;
		my $line = $_;
		$line =~ s/>//;
		$line =~ s/ /\t/g;
		@tmpArray = split(/\t/, $line);
		print "$tmpArray[0]\n";
		#store it in hash, same key/value pair
		if (defined($headerHash{$tmpArray[0]}))
		{
			$writeflag = 1;
			#print "$tmpArray[0]\n";
			#print "$_\n";
			print OUT "$_\n";
		}
		else
		{
			print OUT2 "$_\n";
			$writeflag =0;
		}
		
	}	
	
	

	
}
close IN;
close OUT2;
close OUT;

exit;
