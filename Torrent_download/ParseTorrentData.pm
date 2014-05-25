package ParseTorrentData;

=head1 Description of the package:

This package creates an object from the torrent datasheet downloaded by the
B<TorrentByID> method of the B<WgetNcore> packege. With the avilable methods the
user can retrieve any stored information regarding the torrent file.

 Version:       1.0
 Last modified: 2014.05.14
 By:            Daniel Suveges

=head1 Requirements:

Methods are relying on the html file downloaded by the B<TorrentByID> method

=head1 List of public methods:

=over 4

=item B<new> - creates an object of the downloaded torrent datasheet

  use ParseTorrentData;
  my $TorrentObject = ParseTorrentData->new($torrentfile)
  # $torrentfile is downloaded by the B<TorrentByID> method

=item B<ID> - Returns with the ID of the torrent

  my $TorrentID = $TorrentObject->ID;

=item B<Name> - Returns with the name of the torrent

  my $TorrentName = $TorrentObject->Name;

=item B<Seeders> - Returns with the number of seeders of the torrent

  my $TorrentSeeders = $TorrentObject->Seeders;

=item B<Leechers> - Returns with the number of Leechers of the torrent

  my $TorrentLeechers = $TorrentObject->Leechers;

=item B<IMDB> - Returns with the IMDB ID of the movie

  my $TorrentIMDB = $TorrentObject->IMDB;
  
=item B<Downloads> - Returns with the number of Downloads

  my $TorrentDownloads = $TorrentObject->Downloads;

=item B<TimeDate> - Returns with the date and time of the upload

  my $TorrentTimeDate = $TorrentObject->TimeDate;

=item B<Types> - Returns with the number of nationality and the media format of the torrentfile

  my $TorrentTypes = $TorrentObject->Types;

=item B<Genres> - Returns with the list of genres describing the torrent

  my $TorrentGenres = $TorrentObject->Genres;


=back

=cut

use strict;
use warnings;

our $AUTOLOAD;

# Calling the very simple constructor:
sub new {
    my ($class, $page) = @_;
    return bless \$page, $class;
}


sub AUTOLOAD {

    # Extracting page from object:
    my $self = ${$_[0]};

    # Parsing submitted method name:
    $AUTOLOAD =~ /.+::(.+)/;
    my $AUT_ = $1;

    # Finding the proper method, based on the submitted name:
    # Get the ID of the torrent:
    if ($AUT_ eq "ID") {
        my $ID = "NA";
        $ID = $1 if ($self =~ /download&id=(\d+)/);
        return $ID;
    }

    # Get the name of the torrent:
    elsif ($AUT_ eq "Name") {
        my $Name = "NA";
        if ($self =~ /torrent_reszletek_cim\">(.+?)\s*<\/div>/){
            $Name = $1;
            $Name =~ s/[,\s]/_/g; # Removing commas from the text
        }
        return $Name;
    }

    # Get Number of seeders:
    elsif ($AUT_ eq "Seeders") {
        my $Seeders = "NA";
        $Seeders = $1 if ($self =~ /Seederek:\<\/div\>\n.+\">(\d+)\<\/a\>/);
        return $Seeders;
    }

    # Get Number of leechers:
    if ($AUT_ eq "Leechers") {
        my $Leechers = "NA";
        $Leechers = $1 if ($self =~ /Leecherek:\<\/div\>\n.+\">(\d+)\<\/a\>/);
        return $Leechers;
    }

    # Get Number of IMDB:
    elsif ($AUT_ eq "IMDB") {
        my $IMDB = "NA";
        $IMDB = $1 if ($self =~ /imdb\.com\/title\/(.+?)\"/);
        return $IMDB;
    }

    # Number of downloads
    elsif ($AUT_ eq "Downloads") {
        my $Downloads = "NA";
        $Downloads = $1 if ($self =~ /\"dd\"\>(\d+) alkalommal\<\/div\>/);
        return $Downloads;
    }


    # Upload date and time
    # Number of downloads
    elsif ($AUT_ eq "TimeDate") {
        my $TimeDate = "NA";
        $TimeDate = '"'.$1." ".$2.'"' if ($self =~ /ltve\:\<\/div\>\n.+\>(\d+-\d+-\d+) (\d+\:\d+\:\d+)\</);
        return $TimeDate;
    }


    # Type of torrent - Format and nationality
    elsif ($AUT_ eq "Types") {
        my $Types = "NA";
        $Types = $1.",".$2 if ($self =~ /torrents.php\?tipus\=\S+\"\>(\S+)\/([A-Z]+)\<\/a\>/);
        return $Types;
    }

    # Some problem - No matching method...

    elsif ($AUT_ eq "Genres"){
        my $Genres = "NA";

    }
    else {die "No such method: $AUT_. The available methods: \"ID\", \"Name\", \"Seeders\", \"Leechers\", \"IMDB\", \"Downloads\", \"TimeDate\", \"Types\".\n"}


}

# Default destructor for AUTOLOAD
sub DESTROY {
    my $self = @_;
}

1;
