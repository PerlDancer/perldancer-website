#!/usr/bin/perl

use Dancer;
use Template;

my @pages = qw(quickstart documentation contribute about);

get '/' => sub {
    debug "GET /";
    template 'home';
};

get '/:page' => sub {
    my ($page) = params->{page};
    pass and return false unless grep /$page/, @pages;
    debug "GET /$page";
    template $page;
};

get '/*' => sub {
    status 'not_found';
    template 'not_found';
};

dance;
