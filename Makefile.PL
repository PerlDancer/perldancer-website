use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'PerldancerWebsite',
    AUTHOR              => q{Alexis Sukrieh <sukria@sukria.net>},
    VERSION_FROM        => 'lib/PerlDancer.pm',
    ABSTRACT            => 'source code for http://perldancer.org',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Dancer'      => 0,
        'Test::More'  => 0,
        'YAML'        => 0,
        'LWP::Simple' => 0,
        'Template'    => 0,
        'WebService::Bluga::Webthumb' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'TestApp-*' },
);
