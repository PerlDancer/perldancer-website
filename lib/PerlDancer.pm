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

# Add last tweet to template params
hook before_template_render => sub {
    shift->{last_tweet} = latest_tweet();
};

# Find the latest stable version on Github.  Cache it for a while, to avoid
# hitting it every single time.  (If we're trying to fetch up to date info and
# fail, return the cached version, even if it's a bit stale; more useful to
# return the last version, which is most likely still the latest, than just die.
{
    my ($latest_version, $last_check);
    sub latest_version {
        if ($latest_version
            && time - $last_check < config->{cache_latest_version})
        {
            return $latest_version;
        }

        my $json = LWP::Simple::get(
            'http://search.cpan.org/api/dist/Dancer'
        ) or return $latest_version;

        my $versions = from_json($json) or return $latest_version;
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

# TODO: I should probably use Net::Twitter / Net::Twitter::Lite or something
# here, but this is quick and easy and gets the job done.
{
    my $last_tweet;
    my $last_tweet_checked;

    sub latest_tweet {
        return $last_tweet if $last_tweet and time - $last_tweet_checked < 300;

        my $url = "http://api.twitter.com/1/statuses/user_timeline.json"
            . "?screen_name=PerlDancer&include_rts=1&count=1";
        my $json = LWP::Simple::get($url) or return "Unavailable";
        my $tweets = from_json($json);
        $last_tweet_checked = time;
        return $last_tweet  = $tweets->[0]->{text};
    }
}

true;
