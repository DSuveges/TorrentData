package WgetNcore;

our $version = 1.2;


=head1 Description of package:

This package is a collection of methods written to download html pages from the biggest Hungarian torrent portal L<ncore.cc>

    Version:       v.1.2
    Last modified: 2014.05.13
    By:            Daniel Suveges

=head1 Requirements:

Methods are using B<wget> to access html files and manage authentication.

=head1 List of methods in the package:

=over 4

=item B<Authenticate>   - Manages authentication to the torrent site

 use WgetNcore.pm;
 my $authpass = &Authenticate("Username","Passwd");

 # Return value depens on the success of the authentication
 if $authpass == 1 - Authentication was successful, cookiefile.txt is saved
 if $authpass == 0 - Authentication failed, bad username or password
 if $authpass == 2 - Authentication failed, unknown error occurred

=item B<GetListPage>    - Download and return a html listpage

 use WgetNcore.pm;
 my $listapge = &GetListPage(pagenumber,query);

 # pagenumber - integer
 # query      - valid categories on ncore
 # The method downloads a list of torrents based on the pagenumber
 # and the query.
 # Return value is a html file as a single string

=item B<TorrentByID>    - Download the info page of a given torrent ID

 use WgetNcore.pm;
 my $infopage = &TorrentByID(ID);

 # ID - integer
 # Return value is a html file as a single string

=back

=cut

use strict;
use warnings;

# This routine perform authentication to ncore.cc based on the provided username and password
sub Authenticate {

    my $id     = $_[0];
    my $passwd = $_[1];

    $id        =~ s/\s//g;
    $passwd    =~ s/\s//g;

    # The default return value. Corresponds to the unknown error :D
    my $return = '2';

    my $oldal = `wget --user-agent="Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" --save-cookies cookies.txt  --post-data='nev=$id&pass=$passwd&ne_leptessen_ki=1'  -O - -o /dev/null https://ncore.cc/login.php`;

    # If login was successful:
    $return = 1 if ($oldal =~ /<a href\=\"profile\.php\"\>$id\<\/a\>/);

    # Username/Passwd error:
    $return = 0 if ($oldal =~ /<img src\=\"images\/warning\.png\"/);

    return $return;
}

# This routine download a list page from ncore.cc based on the page number and the torrent type provided
sub GetListPage {
    # Warning: At this step there is no error hangling
    # We are assuming, that the authentication was successful, so there should be no problem with the following steps

    my $page  = $_[0];
    my $query = $_[1];

    my $oldal = `wget --load-cookies cookies.txt --post-data='oldal=$page&tipus=kivalasztottak_kozott&kivalasztott_tipus=$query' -O - -o /dev/null https://ncore.cc/torrents.php`;

    return $oldal;
}

# Download a torrent page of a given ID
sub TorrentByID {
    # Warning: At this step there is no error hangling
    # We are assuming, that the authentication was successful, so there should be no problem with the following steps

    my $id = $_[0];

    my $oldal = `wget --load-cookies cookies.txt --post-data=\'action=details&id=$id\' -O - -o /dev/null https://ncore.cc/torrents.php`;

    return $oldal;
}
1;


