use Test::More;
use YAML;
use strict;


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





done_testing;




