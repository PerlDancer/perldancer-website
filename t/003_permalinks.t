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
    slides

    donate
    example
    download 
);

if (-e 'webthumb-api.yml') {
    push @pages, 'dancefloor';
}

plan tests => scalar(@pages);

for my $page (@pages) {
    my $req = [GET => "/$page"];

    response_status_is $req, 200;
}
