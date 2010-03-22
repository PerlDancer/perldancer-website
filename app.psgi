# PSGI application bootstraper for Dancer
use lib '/srv/dancer.sukria.net/perldancer-website';
use perldancer-website;

use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
setting environment => 'production';
Dancer::Config->load;

my $handler = sub {
    my $env = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};
