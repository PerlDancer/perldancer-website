# This is a PSGI application file for Apache+Plack support
use lib '/home/sukria/Devel/perldancer-website';
use perldancer-website;

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
