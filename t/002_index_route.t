use Test::More tests => 4;
use strict;
use warnings;

# the order is important
use PerlDancer;
use Dancer::Test;

route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';
response_content_like [GET => '/'], qr/Dancer.*Prepare your moves/s,
    'content looks OK for /';


response_content_like [GET => '/testimonials'], qr/Dancer is a breath of fresh air in the convoluted world of Perl web frameworks/,
    'at least one testimonial was loaded';

