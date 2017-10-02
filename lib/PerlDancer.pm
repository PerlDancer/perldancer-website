package PerlDancer;

use Dancer2;
use Template;
use LWP::Simple ();
use List::Util;
use WebService::Bluga::Webthumb;
use YAML;
use File::Basename qw(dirname);

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
    template 'testimonials-display' => {
        testimonials => [ _get_testimonials() ],
        title => 'What people say about the Perl Dancer web development framework',
    };
};

get '/dancefloor' => sub {
    template 'dancefloor-display' => {
        sites => _get_dancefloor_sites(),
        title => 'The Dancefloor - web site and web applications built on top of Perl Dancer',
    };
};

# Add this year to template params
hook before_template_render => sub {
    my $t = shift;
    $t->{this_year} = 1900 + (localtime)[5];
    my $dir = dirname dirname __FILE__;
    my @git = qx{cd $dir; git log -1};
    my ($commit_line) = grep { /^commit\s/ } @git;
    my ($commit) = $commit_line ? $commit_line =~ /commit\s(\w+)\s/ : '';
    my ($date_line) = grep { /^Date:/ } @git;
    my ($date) = $date_line ? $date_line =~ /Date:\s*(.*)/ : '';
    $t->{last_commit} = $commit;
    $t->{last_update} = $date;
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
            'http://api.metacpan.org/v0/release/Dancer2'
        ) or return $latest_version;

        my $response = from_json($json) or return $latest_version;
        my ($short_ver) = $response->{version} =~ /^(\d+\.\d{3})/;
        my $result =  {
            version       => $response->{version},
            short_version => $short_ver,
            download_url  => $response->{download_url},
        };
        $latest_version = $result;
        $last_check = time;
        return $result;
    }
}

sub _get_testimonials {
    my $testimonials_yml = Dancer2::FileUtils::read_file_content(
        path( setting('appdir'), 'testimonials.yml' )
    );
    return YAML::Load($testimonials_yml);
}

sub _get_dancefloor_sites {
    my $dancefloor_sites_yaml = Dancer2::FileUtils::read_file_content(
        path( setting('appdir'), 'dancefloor.yml' )
    ) or die "Failed to read sites from config";
    my @dancefloor_sites = YAML::Load($dancefloor_sites_yaml)
        or die "Failed to parse sites YAML";

    my $webthumb_api = from_yaml(
            scalar  Dancer2::FileUtils::read_file_content(
            path( setting('appdir'), 'webthumb-api.yml')
        )
    ) or die "Failed to read webthumb API details from config";

    my $wt = WebService::Bluga::Webthumb->new(%$webthumb_api);
    for my $site (@dancefloor_sites) {
        # Work out the URL to a thumbnail
        $site->{thumb_url} = $wt->thumb_url($site->{url})
            if $site->{url};
    }
    return [ sort { rand } @dancefloor_sites ];
}

true;
