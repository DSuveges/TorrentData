#!/usr/bin/perl

# Project Torrentdata - main script.

#

# Description of the functionality:
    # based on the user provided username and password, logs in to the torrentsite ncore.cc
    # the script downloads torrent information based on the query string built in the program:
    my $query_string = "xvid_hun,xvid,dvd_hun,dvd,dvd9_hun,dvd9,hd_hun,hd";
    # Program keep track of the pogression of the data collection. Upon restart the program continues from the last page

# Usage:
    # $./TorentInfoDownload.pl -u <username> -p <Password> -o <outputfile.csv>

my $version = 2.0; # Last modified: 2014.05.14


use warnings;
use strict;
use Getopt::Std;

# Custom classes made for the project:
use WgetNcore        "."; # This module authenticates and downloads html, all methods use wget
use ListNavigator    "."; # A module that parses the downloaded html list files.
use ParseTorrentData "."; # A module to extract torrent data

# The username and password we use to login ncore, and the name of the output file is provided as command line options
our($opt_u, $opt_p, $opt_o);
my ($passwd, $username);
getopt('u:p:');

# Both password and username are necessary to run the progam
die "No password provided!!\n" unless ($passwd = $opt_p);
die "No username has provided!!\n" unless ($username = $opt_u);

# Providing output filename is optional
my $filename = "Torrent.csv";
$filename    = $opt_o if ($opt_o);

# Opening output file
open(OUT, ">>", $filename);


# Steps:

# 1 - Do authentication - save cookie, proceed only if login was successful.
print "Provided login parameters: $username, $passwd\n";

my $auth = WgetNcore::Authenticate($username, $passwd);
if ($auth == 0) {die "Login falied. Check username and password!\n"}
if ($auth == 1) {print STDERR "Login was successful!\n"}
if ($auth == 2) {die "Login failed. Unknown error occurred.\n"}

# 2 - Download first page, get last page.

# Get the first page of the category to get the length of the list:
my $FirstPage = &WgetNcore::GetListPage(1, $query_string);
my $startPage = &GetStartPage(); # the page, where we start the reading.
my $lastPage  = &ListNavigator::Lastpage($FirstPage);

# Status update:
print STDERR "Last page: $lastPage, the first page to download: $startPage\n";


# 3 - Loop through all pages
while ($startPage <= $lastPage){

    # Step 3.1 Download the list page
    print STDERR "Reading torrents on $startPage page of the total $lastPage\n";

    my $oldal   = &WgetNcore::GetListPage($startPage,$query_string);

    # Step 3.2 Get the IDs
    my @ID_list = &ListNavigator::GetIDs($oldal);

    # Step 3.3 loop throug all the IDs and get the torrent details
    foreach my $ID (@ID_list){

        print STDERR ".";

        my @fields         = ();
        my $TorrentPage    = &WgetNcore::TorrentByID($ID);
        my $TorrentPageObj = ParseTorrentData->new($TorrentPage);

        # Extracting data from webpage object, fill array with data:
        push(@fields, (
                $TorrentPageObj->ID,
                $TorrentPageObj->Name,
                $TorrentPageObj->Seeders,
                $TorrentPageObj->Leechers,
                $TorrentPageObj->IMDB,
                $TorrentPageObj->Downloads,
                $TorrentPageObj->TimeDate,
                $TorrentPageObj->Types)
            );

        # Saving extracted invormation into a csv file:
        print OUT join(",", @fields),"\n";

    }
    print STDERR "\n";
    # Step 3.4 save state and then apply incrementation
    $startPage = &IndexIncrement($startPage);
}

close OUT;

# To get the last page the program has read
sub GetStartPage{

    # By default, the start page is 1
    my $lastpage = 1;

    # We open the list file, but if that does not exist, we return the default value
    open( START, "<", "read_pages.lst" ) or return $lastpage;
    foreach (<START>){
        $lastpage = $_ if ($_ > $lastpage)
    }
    close START;

    return $lastpage;
}

# This routine takes care of the read pages.
# Once it is called, saves the state in the list file and increment the value
sub IndexIncrement {
    my $page = $_[0];

    open(INDEX, ">", "read_pages.lst") or die "Gebasz van!!!\n";
    print INDEX "$page";
    close INDEX;

    # Return the next page to read
    return ($page + 1);
}
