use Test::More;

# make sure our permalinks are served 

use strict;
use warnings;

use PerlDancer;
use Dancer::Test;

my @pages = qw(
    quickstart
    documentation
    about
    irc
    contribute 
    dancefloor
    slides

    donate
    example
    download 
);

plan tests => scalar(@pages);

for my $page (@pages) {
    my $req = [GET => "/$page"];

    response_status_is $req, 200;
}
