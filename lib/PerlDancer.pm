package PerlDancer;

use Dancer ':syntax';
use Template;
use LWP::Simple ();
use List::Util;

our $VERSION = '0.1';

get '/' => sub {
    my $testimonials_yml = 
        Dancer::FileUtils::read_file_content('testimonials.yml');

    template 'index' => { 
        latest => latest_version(),
        testimonials => [ List::Util::shuffle(from_yaml($testimonials_yml)) ],
    };
};

get '/donate/thanks' => sub {
    template 'thanks';
};


# Find the latest stable version on Github.  Cache it for 10 minutes, to avoid
# hitting it every single time
{
    my ($latest_version, $last_check);
    sub latest_version {
        if ($latest_version 
            && time - $last_check < config->{cache_latest_version})
        {
            return $latest_version;
        }

        my $versions = from_json(LWP::Simple::get(
            'http://search.cpan.org/api/dist/Dancer'
        ));
        my ($latest) = grep { $_->{latest} } @{ $versions->{releases} };
        my $url = join '/', 'http://search.cpan.org/CPAN/authors/id',
            substr($latest->{cpanid}, 0, 1),
            substr($latest->{cpanid}, 0, 2),
            $latest->{cpanid},
            $latest->{archive};
        my ($short_ver) = $latest->{version} =~ /^(\d+\.\d)/;
        my $result =  {
            version => $latest->{version},
            short_version => $short_ver,
            download_url => $url,
        };
        $latest_version = $result;
        $last_check = time;
        return $result;
    }
}

sub _get_testimonials {
    my $testimonials_yml = Dancer::FileUtils::read_file_content(
        Dancer::FileUtils::path( setting('appdir'), 'testimonials.yml' )
    );
    return from_yaml($testimonials_yml);
}


true;
