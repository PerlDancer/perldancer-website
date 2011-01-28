package PerlDancer;

use Dancer ':syntax';
use Template;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/donate/thanks' => sub {
    template 'thanks';
};

true;
