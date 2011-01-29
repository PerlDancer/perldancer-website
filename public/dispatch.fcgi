#!/usr/bin/perl
use Plack::Handler::FCGI;

my $app = do('/srv/dancer.sukria.net/perldancer-website/app.psgi');
my $server = Plack::Handler::FCGI->new(nproc  => 10, detach => 1);
$server->run($app);
