#! /usr/bin/perl -w
use strict;
use diagnostics;

# parameters perl label.pl [blastresult file] [original fasta] [no hit outputfile] [hits outfile]
#
open(BLASTIN, "$ARGV[0]");
open(IN, "$ARGV[1]");
open(OUT,">$ARGV[2]");
open(OUT2,">$ARGV[3]");

#Stores all the headers parsed from blast outfile
my %headerHash = ();
my $qname;
while (<BLASTIN>)
{
	my @array;
	chomp $_;
	my $flag = 0;
	
	if ($_ =~ m/^Query=/)
    {
    	@array = split(/ /, $_);
    	if (defined($array[1]))
    	{
    	#print "$array[1]\n";
        $qname = $array[1];
        }
    }
    if ($_ =~ m/\s.*No hits found/)
    {
    	#print "NO HITS FOUND\n";
        $flag = 1;
    }
    
	if($flag == 1)	
	{
	#store it in hash, same key/value pair
	#print "$qname\n";
	$headerHash{$qname} = $qname;	
	$flag=0;
	}
}

#check what is in the hash
while ( my ($key, $value) = each(%headerHash) ) {
       print "key: $key\n";
    }
    

    
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
close BLASTIN;
close IN;
close OUT2;
close OUT;

exit;
