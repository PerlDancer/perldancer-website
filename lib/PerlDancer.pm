package PerlDancer;

use Dancer ':syntax';
use Template;
use LWP::Simple ();
use List::Util;
use WebService::Bluga::Webthumb;

our $VERSION = '0.1';

get '/' => sub {
    template 'index' => { 
        latest => latest_version(),
        testimonials => [ List::Util::shuffle(_get_testimonials()) ],
    };
};

get '/donate/thanks' => sub {
    template 'thanks';
};

get '/testimonials' => sub {
    template 'testimonials-display', { testimonials => [ _get_testimonials() ] };
};

get '/dancefloor' => sub {
    my $sites = _get_dancefloor_sites();
    template 'dancefloor-display', { sites => _get_dancefloor_sites() };
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

sub _get_dancefloor_sites {
    my $dancefloor_sites_yaml = Dancer::FileUtils::read_file_content(
        Dancer::FileUtils::path( setting('appdir'), 'dancefloor.yml' )
    ) or die "Failed to read sites from config";
    my @dancefloor_sites = from_yaml($dancefloor_sites_yaml)
        or die "Failed to parse sites YAML";

    my $webthumb_api = from_yaml(
            scalar  Dancer::FileUtils::read_file_content(
            Dancer::FileUtils::path( setting('appdir'), 'webthumb-api.yml')
        )
    ) or die "Failed to read webthumb API details from config";

    my $wt = WebService::Bluga::Webthumb->new(%$webthumb_api);
    for my $site (@dancefloor_sites) {
        # Work out the URL to a thumbnail
        $site->{thumb_url} = $wt->easy_thumb($site->{url})
            if $site->{url};
    }
    return [ sort { rand } @dancefloor_sites ];
}



true;
