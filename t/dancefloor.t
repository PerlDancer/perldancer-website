use Test2::V0;

use Path::Tiny;
use YAML;
use Test::WWW::Mechanize;

skip_all "WITH_NETWORK not set"
  unless $ENV{WITH_NETWORK};

my @dancefloor = map { YAML::Load($_) } grep { $_ } split /---\n/,
  path('dancefloor.yml')->slurp;

my $mech = Test::WWW::Mechanize->new;

for my $site (@dancefloor) {
    $mech->get_ok( $site->{url} );
}

done_testing();
