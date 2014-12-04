#! /usr/bin/perl -w

## Author: Xi A Tian (alvinxtian@hotmail.com)

use strict;

use diagnostics;

 

# perl findduplicate.pl [input] [out] [dup out]

 

open(IN, "$ARGV[0]");

open(OUT,">$ARGV[1]");

open(DUP,">$ARGV[2]");

 

my %headerHash = ();

my @rows = <IN>;

my $asize= @rows;

my $i;

for ($i=0; $i<$asize; $i++)

{

                my $row1 = $rows[$i];

                my $row2;

                if ($i+1 < $asize)

                {

                                $row2 = $rows[($i+1)];

                }

                else

                {

                                $row2 = 0;

                }

               

                chomp $row1;

                chomp $row2;

                #check for header

                if($row1 =~ m/^>/)        

                {

                #store header in hash, same key/value pair

 

                                #check for duplicate, delete entry in hash, write both out

                                if (defined($headerHash{$row1}))

                                {

                                                my $seq1 = $headerHash{$row1};

                                                my $seq2 = $row2;

                                                print DUP "$row1\n$seq1\n$row1\n$seq2\n";

                                                delete $headerHash{$row1};

                                }

                                else

                                {

                                                #insert next row (should be sequence, as the matching value

                                                $headerHash{$row1} = $row2; 

                                }

                }

}

 

 

while ( my ($key, $value) = each(%headerHash) ) {

        print OUT "$key\n$value\n";

    }

close IN;

close DUP;

close OUT;


