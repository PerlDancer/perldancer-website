#!/usr/bin/perl

use Dancer;
use Template;

get '/' => sub {
    template "home"
};

dance;
