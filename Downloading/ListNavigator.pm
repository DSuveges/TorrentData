# Project - ParseNCORE - Movies

package ListNavigator;

=head1 Description of package:

This package contains methods to navigate on the ncore.cc listpage. The

    Version:       v.1.0
    Last modified: 2014.05.13
    By:            Daniel Suveges

=head1 Requirements:

Methods are processing html files downloaded by the B<GetListPage> method of the B<WgetNcore> package

=head1 List of methods in the package:

=over 4

=item B<GetIDs>   - Collects the torrent IDs from a listpage.

 use ListNavigator.pm;
 my @ID_list = &ListNavigator::GetIDs($html);

 # input $html is the output of GetListPage method
 # An array is returned with all the torrent ID that listed in the html file

=item B<Lastpage>  - Get the last page of the torrent list

 use ListNavigator.pm;
 my $LastPage = &ListNavigator::Lastpage($html);

 # input $html is the output of GetListPage method
 # A scalar is returned with with the last list page

=back

=cut

use strict;
use warnings;



# To get the number of the last page of the list
sub Lastpage {
    my $page = $_[0];

    if($page =~ /oldal\=(\d+)\&tipus\=\S+\"><strong>Utols/){
        print STDERR "Last page of the category: $1\n";
        return $1;
    }
    else { die "There was problem with the dowloaded page... Last page could not be parsed.\n"}

}

# At first we get the IDs of the torrent.
# Once a page is downloaded, fetches the torrent IDs
# Input: html, output: list of scalars (default: a list with one 0)
sub GetIDs {
    my $oldal = $_[0];
    my @IDs = ();
    while ($oldal =~ /onclick\=\"torrent\((\d+)\)/g){
        push (@IDs, $1);
    }
    return @IDs;
}
1;
