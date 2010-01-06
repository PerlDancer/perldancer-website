# This is a PSGI application file for Apache+Plack support
use lib '/srv/dancer.sukria.net/perldancer-website';
use perldancer;

use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
setting environment => 'production';
Dancer::Config->load;

my $handler = sub {
    my $env = shift;
    local *ENV = $env;
    my $cgi = CGI->new();
    Dancer->dance($cgi);
};
