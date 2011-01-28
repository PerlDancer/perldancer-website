# PSGI application bootstraper for Dancer
use Dancer;
use lib path(dirname(__FILE__), 'lib');
use PerlDancer;

setting apphandler  => 'PSGI';
Dancer::Config->load;

my $handler = sub {
    my $env = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};
