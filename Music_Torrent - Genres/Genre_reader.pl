#!/usr/bin/perl

# This script takes the first step in the process of the genre field optimization

# Version: 1.2 Last modified: 2014.06.12
    # Reads csv file.
    # Takes last column
    # further splits at "." and  "_" characters
    # Saves new csv, where the first column is the torrent ID, the second is the genre is exists
    # As there could be more genres assigned to one music, there can be multiple rows with one ID


use strict;
use warnings;

# Default output file:
open(OUT,">", "genres_raw.csv");

# Initialize variables:
my $Total_torrent    = 0;
my $genre_assignment = 0;

foreach (<>){
    # removing whitepaces:
    $_=~ s/\s//g;

    # Splitting lines at commas:
    my @sor = split(/,/,$_);

    # We don't care about missing torrents:
    next unless($sor[1]);
    if ($sor[1] eq "NA") {
        next;
    }

    # Total number of torrent/keep track of progerssion:
    $Total_torrent++;
    #print "Reading $Total_torrent line\r";

    # Get important fields:
    my $ID     = $sor[0];
    my $genre  = $sor[8];
    
    # Splitting the genre definition:
    next unless($genre);
    my @genre_list = split(/[._]/, $genre);

    # Looping through all the assigned genres:
    foreach my $g (@genre_list){
        print OUT "$ID,$g\n";
        $genre_assignment ++;
    }
    
}
close OUT;

print "\nNumber of torrents processed: $Total_torrent\nThe number of genre assignment: $genre_assignment\n";
