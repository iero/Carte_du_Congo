#!/usr/bin/perl
use strict;

# Script that computes lengths of ways in an OSM file.
#
# Reads the OSM file on stdin.
# Writes an OSM file to stdout in which all ways carry an additional
# tag: <d length="1234.567">, specifying the length in metres.
#
# On stderr, outputs a list of all highway types encountered together 
# with total length.
#
# Stores all node positions in a memory hash and will thus be unable
# to process the whole planet file unlesss you have 8 Gig of RAM or so.
#
# Author: Frederik Ramm <frederik@remote.org>. My contribution is 
# Public Domain but I grabbed the Haversine formula in calc_distance 
# from the original osm-length script, written by Jochen Topf, which
# is GPL, so the whole of this script is GPL also - if you need a
# true PD variant, re-implement the Haversine yourself.

my $nodes = {};
my $waysum = {};
my $gpswaysum = {};

use constant PI => 4 * atan2 1, 1;
use constant DEGRAD => PI / 180;
use constant RADIUS => 6367000.0;

my $waylen;
my $hw;
my $gpshw;
my $warning;
my $lastnode;

my $gpstotal;

while(<>) 
{
   if (/k=.source_type.\s*v=["'](.*?)["']/) {
	$gpshw = $1;
    } 

    if (/^\s*<node.*\sid=["']([0-9-]+)['"].*lat=["']([0-9.-]+)["'].*lon=["']([0-9.-]+)["']/)
    {
        $nodes->{$1}=[$2,$3];
    }
    elsif (/^\s*<way /)
    {
        $waylen = 0;
        undef $hw;
        undef $gpshw;
        undef $warning;
        undef $lastnode;
    }
    elsif (defined($waylen) && /k=.highway.\s*v=["'](.*?)["']/)
    {
        $hw = $1;
    }
    elsif (defined($waylen) && /k=.waterway.\s*v=["'](.*?)["']/)
    {
        $hw = $1;
    }
    elsif (defined($waylen) && /k=.route.\s*v=["'](.*?)["']/)
    {
        $hw = $1;
    }
    elsif (/^\s*<nd ref=['"](.*)["']/)
    {
        if (defined($nodes->{$1}) && defined($lastnode))
        {
            $waylen += calc_distance($lastnode, $nodes->{$1});
        }
        $lastnode = $nodes->{$1};
    }
    elsif ((/^\s*<\/way/))
    {
        #printf "   <d length='%f'/>\n", $waylen;
        $waysum->{$hw} += $waylen;
        $gpswaysum->{$gpshw} += $waylen;
    }
    #print;
}


print STDERR "(high/water)way length stats (m/km):\n";
my $oa;
foreach my $hw(sort { $waysum->{$b} <=> $waysum->{$a} } keys(%$waysum))
{
    if ($waysum->{$hw} > 1000) {
    	printf STDERR "%-15s %10d km\n", $hw, $waysum->{$hw}/1000;
    }
    else {
    	printf STDERR "%-15s %10d m\n", $hw, $waysum->{$hw};
    }
    $oa += $waysum->{$hw};
}

if ($waysum->{$hw} > 1000) {
	printf STDERR  "%-15s %10d km\n", "TOTAL", $oa/1000;
}
    else {
	printf STDERR  "%-15s %10d m\n", "TOTAL", $oa;
}

#GPS
my $gpsprimary;

print STDERR "\nBy source (high/water)way length stats (m/km):\n";
my $gpsoa;

foreach my $gpshw(sort { $gpswaysum->{$b} <=> $gpswaysum->{$a} } keys(%$gpswaysum))
{
    # On somme toutes les sources GPS
    if ($gpshw =~ m/GPS/) {
	$gpstotal +=  $gpswaysum->{$gpshw};
	# On somme toutes les primary
    }

    if ($gpswaysum->{$gpshw} > 1000) {
    	printf STDERR "%-15s %10d km\n", $gpshw, $gpswaysum->{$gpshw}/1000;
    }
    else {
    	printf STDERR "%-15s %10d m\n", $gpshw, $gpswaysum->{$gpshw};
    }
    $gpsoa += $gpswaysum->{$gpshw};
}

if ($gpswaysum->{$gpshw} > 1000) {
	printf STDERR  "\n%-15s %10d km\n", "TOTAL", $gpsoa/1000;
}
    else {
	printf STDERR  "%-15s %10d m\n", "TOTAL", $gpsoa;
}


printf STDERR  "%-15s %10d km\n", "TOTAL GPS", $gpstotal/1000;

sub calc_distance {
    my ($p1, $p2) = @_;

    my ($lat1, $lon1, $lat2, $lon2) = ($p1->[0] * DEGRAD, $p1->[1] * DEGRAD, $p2->[0] * DEGRAD, $p2->[1] * DEGRAD);

    my $dlon = ($lon2 - $lon1);
    my $dlat = ($lat2 - $lat1);
    my $a = (sin($dlat/2))**2 + cos($lat1) * cos($lat2) * (sin($dlon/2))**2;
    my $c = 2 * atan2(sqrt($a), sqrt(1-$a)) ;
    return RADIUS * $c;
}
