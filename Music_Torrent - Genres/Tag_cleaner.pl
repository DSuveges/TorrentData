#!/usr/bin/perl

# After the iterative process, we have the following genre definitions, to cover as much torrents as possible
# The program also keep track how


use strict;
use warnings;

open(OUT,">", "genres_clean_final.csv");
print OUT "ID,Category,genre\n";

open(ERR, ">", "uncovered.csv");

# Torrents to be counted:
my $t_with_genre    = 0; # torrent that has at least one valid definition
my $t_without_genre = 0; # Torrent without at least one valid definition

# genres to be counted:
my $g_non_covered   = 0; # genre that is not covered in the mask definition set
my $g_non_valid     = 0; # genre that is covered, but not valid definition
my $g_valid         = 0; # genre with valid mask definition

# Input file is the atomic genre
foreach (<>){

    # Ignore empty lines at the end
    unless($_ =~ /^\d+/){next}

    $_=~ s/\s//g;

    # Total number of torrent:
    $Total_torrent++;

    # This will keep track if the song has at least one valid genre field
    my %hash = ();

    # Keep track of the processing:
    # print "Reading $i line\r";

    # SElect each field of the csv file:
    my @sor = split(/,/,$_);

    # If the torrent is missing:
    if ($sor[1] eq "NA") {
        $Missing_torrent++;
        next;
    }


    # Get important fields:
    my $ID    = $sor[0];
    my $genre = $sor[8];

    # Disect genre if, exists:
    if ($genre eq "NA"){
        $Missing_genre++;
        next;
    }

    # Genre field is set:
    else{
        $With_genre++;
        
        # If at least one genre is covered by the canonical list, the flag will increase
        my $flag = 0;

        my @genre_list = split(/[._]/, $genre);

        # Counting genres not torrents!!!
        foreach my $g (@genre_list){

            # new_g = masked genre
            # flag  = (0, 1, 2)
                # 0 -> non-defined genre -> printed out to file for further processing
                # 1 -> covered and valid mask -> printed into file
                # 2 -> covered but non-valid mask -> skipped and counted
            my ($new_g, $flag) = &genre_clean($g);

            if (EXPR) {
                #code
            }


            $flag += $increment;


            print OUT "$ID,$new_g\n" if ($increment == 1);


        }

        # Counting torrents not genres!!!
        $with_annotated_genre ++ if ($flag == 1); # Annotated valid definition
        $genre_skipped ++        if ($flag == 2); # Annotated non-valid definition

        if ($flag == 0){; # Non-annotated definition
            $genre_not_covered ++
            print ERR "\n"
        }

    }
    $i++;
}
close OUT;
close ERR;





sub genre_clean {
    my $genre = lc($_[0]);
    
    my %hash = (
        # Rock based genres
        "rock"           => "rock,rock",
        "rogressiverock" => "rock,rock",
        "classicrock"    => "rock,rock",
        "progressive"    => "rock,rock",

        "roll"      => "rock,rock'n'roll",
        "rocknroll" => "rock,rock'n'roll",
        "beat"      => "rock,rock'n'roll",
        "rockabilly"=> "rock,rock'n'roll",

        "metal"      => "rock,dark-rock",
        "blackmetal" => "rock,dark-rock",
        "metal"      => "rock,dark-rock",
        "death"      => "rock,dark-rock",
        "heavy"      => "rock,dark-rock",
        "thrash"     => "rock,dark-rock",
        "gothic"     => "rock,dark-rock",
        "black"      => "rock,dark-rock",
        "symphonic"  => "rock,dark-rock",
        "metalcore"  => "rock,dark-rock",
        "heavy"      => "rock,dark-rock",
        "heavymetal" => "rock,dark-rock",
        "celtic"     => "rock,dark-rock",
        "dark"       => "rock,dark-rock",
        "doom"       => "rock,dark-rock",
        "dark-metal" => "rock,dark-metal",
        "celtic"     => "rock,dark-metal",
        "speed"      => "rock,dark-metal",
        "nu"         => "rock,dark-metal",
        "viking"     => "rock,dark-metal",
        "power"      => "rock,dark-metal",
        "trash"      => "rock,dark-metal",

        "grunge"        => "rock,alternative",
        "alternative"   => "rock,alternative",

        "psychobilly"     => "rock,psychedelic-rock",
        "stoner"          => "rock,psychedelic-rock",
        "psychedelicrock" => "rock,psychedelic-rock",

        "punk"      => "rock,punk",
        "punkrock"  => "rock,punk",
        "oi"        => "rock,punk",
        "ska"       => "rock,punk",

        "hardcore"  => "rock,hardcore",
        "hardrock"  => "rock,hardcore",
        "hard"      => "rock,hardcore",
        "grindcore" => "rock,hardcore",
        "deathcore" => "rock,hardcore",

        "nemzeti"    => "rock,nemzeti-rock",

        # Hip-hop based genres
        "hop"       => "Hip-hop,hip-hop",
        "trip-hop"  => "Hip-hop,hip-hop",
        "hip-hop"   => "Hip-hop,hip-hop",
        "hip"       => "Hip-hop,hip-hop",
        "hiphop"    => "Hip-hop,hip-hop",

        "funk"      => "Hip-hop,funk",

        "rap"          => "Hip-hop,rap",
        "hardcorerap"  => "Hip-hop,rap",
        "gangstarap"   => "Hip-hop,rap",
        "rnb"          => "Hip-hop,rnb",
        "gangsta"      => "Hip-hop,rap",

        # Electronic based genres

        "space"     => "Electronic,chillout/ambient",
        "chill"     => "Electronic,chillout/ambient",
        "ambient"   => "Electronic,chillout/ambient",
        "downtempo" => "Electronic,chillout/ambient",
        "minimal"   => "Electronic,chillout/ambient",
        "ambient"   => "Electronic,chillout/ambient",
        "chillout"  => "Electronic,chillout/ambient",
        "psychill"  => "Electronic,chillout/ambient",
        "age"       => "Electronic,chillout/ambient",
        "wave"      => "Electronic,chillout/ambient",
        "lounge"    => "Electronic,chillout/ambient",
        "downtempo" => "Electronic,chillout/ambient",
        "groove"    => "Electronic,chillout/ambient",

        "eurohouse"         => "Electronic,house",
        "techhouse"         => "Electronic,house",
        "house"             => "Electronic,house",
        "deephouse"         => "Electronic,house",
        "house"             => "Electronic,house",
        "deep"              => "Electronic,house",
        "electrohouse"      => "Electronic,house",
        "euro-house"        => "Electronic,house",
        "progressivehouse"  => "Electronic,house",
        "trance"            => "Electronic,trance/techno",
        "fullon"            => "Electronic,trance/techno",
        "hardstyle"         => "Electronic,trance/techno",
        "breaks"            => "Electronic,trance/techno",
        "trip"              => "Electronic,trance/techno",
        "idm"               => "Electronic,trance/techno",
        "dance"             => "Electronic,trance/techno",
        "breakbeat"         => "Electronic,trance/techno",
        "rave"              => "Electronic,trance/techno",
        "techno"            => "Electronic,trance/techno",
        "tech"              => "Electronic,trance/techno",
        "techno"            => "Electronic,trance/techno",
        "club"              => "Electronic,trance/techno",

        "glitch"     => "Electronic,electronic",
        "electronic" => "Electronic,electronic",
        "electronica"=> "Electronic,electronic",
        "electro"    => "Electronic,electronic",
        "industrial" => "Electronic,electronic",

        "psytrance"   => "Electronic,psychedelic/acid/goa",
        "psychedelic" => "Electronic,psychedelic/acid/goa",
        "acid"        => "Electronic,psychedelic/acid/goa",
        "goa"         => "Electronic,psychedelic/acid/goa",

        "bass"       => "Electronic,drum'n'bass",
        "drumandbass"=> "Electronic,drum'n'bass",
        "drum"       => "Electronic,drum'n'bass",

        "dubstep"   => "Electronic,dubstep",
        "dub"       => "Electronic,dubstep",

        # Pop based
        "synthpop"  => "Pop,synthpop",
        "synth-pop" => "Pop,synthpop",
        "synth"     => "Pop,synthpop",
        "spacesynth"=> "Pop,synthpop",

        "pop"       => "Pop,pop",
        "pop"       => "Pop,pop",
        "electropop"=> "Pop,pop",
        "jpop"      => "Pop,pop",

        "disco"     => "Pop,disco",
        "disco"     => "Pop,dicso",

        "dance"     => "Pop,dance",

        "indie"     => "Pop,indie",

        "euro"      => "Pop,europop",
        "eurodance" => "Pop,europop",
        "eurodisco" => "Pop,europop",
        "europop"   => "Pop,europop",

        "italo"       => "Pop,italo-disco",
        "italo-disco" => "Pop,italo-disco",
        "italodisco"  => "Pop,italo-disco",

        # Other genres:
        "soundtracks"=> "Other,ost",
        "ost"        => "Other,ost",
        "soundtrack" => "Other,ost",

        "jazz"             => "Other,jazz",
        "smoothjazz"       => "Other,jazz",
        "contemporaryjazz" => "Other,jazz",
        "smooth"           => "Other,jazz",

        "audiobook"        => "Other,audiobook",
        "hangosk%c3%b6nyv" => "Other,audiobook",

        "folk"           => "Other,folk",
        "world"          => "Other,folk",
        "etno"           => "Other,folk",
        "ethnic"         => "Other,folk",
        "vil%c3%a1gzene" => "Other,folk",
        "tribal"         => "Other,folk",
        "n%c3%a9pzene"   => "Other,folk",
        "neofolk"        => "Other,folk",

        "classical" => "Other,classical",
        "operett"   => "Other,classical",
        "classic"   => "Other,classical",
        "piano"     => "Other,classical",
        "orchestral"=> "Other,classical",
        "opera"     => "Other,classical",

        "blues"     => "Other,blues",

        "soul"      => "Other,soul",
        "reggae"    => "Other,reggae",
        "reggaeton" => "Other,reggae",
        "reggae-pop"=> "Other,reggae",
        "ragimusic" => "Other,reggae",

        "country"   => "Other,country",
        "southern"  => "Other,country",

        "latin"       => "Other,latin",
        "flamenco"    => "Other,latin",

        "comedy"       => "Other,comedy",
        "cabaret"      => "Other,comedy",
        "humor"        => "Other,comedy",
        "kabar%c3%a9"  => "Other,comedy",
        "mulat%c3%b3s" => "Other,mulatos",

        "musical"   => "Other,musical",
        "swing"     => "Other,swing",

        "meditative" => "Other,meditation",
        "meditation" => "Other,meditation",
        "relaxing"   => "Other,meditation",

        # Non genre:
        "rhythm"            => "xx",
        "and"               => "xx",
        "90s"               => "xx",
        "dts"               => "xx",
        "new"               => "xx",
        "24bit"             => "xx",
        "music"             => "xx",
        "live"              => "xx",
        "80s"               => "xx",
        "other"             => "xx",
        "melodic"           => "xx",
        "hdtracks"          => "xx",
        "70s"               => "xx",
        "vocal"             => "xx",
        "experimental"      => "xx",
        "60s"               => "xx",
        "vinyl"             => "xx",
        "post"              => "xx",
        "modern"            => "xx",
        "instrumental"      => "xx",
        "acoustic"          => "xx",
        "r"                 => "xx",
        "christmas"         => "xx",
        "kar%c3%a1csonyi"   => "xx",
        "a"                 => "xx",
        "c"                 => "xx",
        "crossover"         => "xx",
        "ecm"               => "xx",
        "fusion"            => "xx",
        "garage"            => "xx",
        "audiophile"        => "xx",
        ""                  => "xx",
        "96khz"             => "xx",
        "hd"                => "xx",
        "villasbela"        => "xx",
    );

    if ($hash{$genre} && $hash{$genre} ne "xx") {
        return ($hash{$genre}, 1);
    }
    elsif ($hash{$genre} && $hash{$genre} eq "xx"){
        return ($genre, 2);
    }
    else {
        return ($genre, 0);
    }

}
