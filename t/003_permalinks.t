use strict;
use warnings;

use Test::More;
use Plack::Test;
use HTTP::Request::Common;

# make sure our permalinks are served 

use PerlDancer;
my $app = PerlDancer->to_app;
my $test = Plack::Test->create($app);

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
	my $response = $test->request( GET "/$page" );
    ok $response->is_success, $page;
}
