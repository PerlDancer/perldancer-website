use Test::More;
use YAML;
use strict;
use warnings;


# Valid testimonials:
my @testimonials = YAML::LoadFile('testimonials.yml');

ok(@testimonials, "Loaded " . scalar @testimonials . " testimonials");
my $tnum;
for my $testimonial (@testimonials) {
    $tnum++;
    ok (ref $testimonial eq 'HASH',
        "testimonial $tnum is a hashref");
    ok (exists $testimonial->{source},
        "testimonial $tnum has source");
    ok (exists $testimonial->{text},
        "testimonial $tnum has text");
}

# Valid dancefloor page entries
my @dancefloor_sites = YAML::LoadFile('dancefloor.yml');
ok(@dancefloor_sites, "Loaded " . scalar @dancefloor_sites . " sites");
my $sitenum;
for my $site (@dancefloor_sites) {
    $sitenum++;
    ok ref $site eq 'HASH',
        "Site $sitenum is a hashref";
    ok exists $site->{url} || exists $site->{source},
        "Site $sitenum has an URL or source";
    ok exists $site->{title},
        "Site $sitenum has a title";
    ok exists $site->{description},
        "Site $sitenum has a description";
}


done_testing;

