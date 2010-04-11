use Test::More;

# make sure our permalinks are served 

use strict;
use warnings;

use PerlDancer;
use Dancer::Test;

my @pages = qw(
    about contribute 
    documentation donate example
    download quickstart
    used_by
);

plan tests => scalar(@pages) * 2;

for my $page (@pages) {
    my $req = [GET => "/$page"];

    response_exists $req;
    response_status_is $req, 200;
}
