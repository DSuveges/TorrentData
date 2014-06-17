#!/usr/bin/perl

# this script calculates what part of the total torrent population is represented by the top100 most frequently used genre definition

use warnings;
use strict;
use List::Compare;

my $genrelistfile   = "top100genres.txt";
my $torrents        = "genres_raw.csv";

# Step 1. read top100 genres:
my @TOPgenes =();

open(GENRES, "<", $genrelistfile);
foreach(<GENRES>){
    $_ =~ s/\s//g;
    push(@TOPgenes, $_);
}
close(GENRES);
print STDERR "Genres are read successfully!\n";

# Step. read torrent list file:
my %Torrents = ();

open(TORRENTS, "<", $torrents);
foreach(<TORRENTS>){
    $_ =~ s/\n//;
    my ($ID, $genre) = split(/,/,$_);
    push(@{$Torrents{$ID}},$genre);
}
close(TORRENTS);
print STDERR "Torrent IDs are read successfully!\n";


# Step 3. Chencking genres:
my $Rep_counter     = 0;
my $Torrent_counter = 0;

foreach my $ID (keys %Torrents){
    $Torrent_counter ++;
    # print STDERR "Testing $Torrent_counter -th torrent (ID: $ID): ";

    my $lc = List::Compare->new(\@TOPgenes, \@{$Torrents{$ID}});
    my $disj = $lc->is_LdisjointR;
    if ($disj == 1) {
        # print STDERR "Disjoint!\r";
    }
    else {
        # print STDERR "Has common element!\r";
        $Rep_counter ++;
    }
}

print "\nTotal number of torrents tested: $Torrent_counter\n";
print "Number of torrents represented by the TOP100 genre list: $Rep_counter (", int(100*$Rep_counter/$Torrent_counter), "%)\n"

