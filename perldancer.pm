package perldancer;
use Dancer;
use Template;

my @pages = qw(quickstart documentation contribute about example download donate);

get '/' => sub {
    template 'home';
};

get '/:page' => sub {
    my ($page) = params->{page};
    pass and return false unless grep /$page/, @pages;
    template $page;
};

get '/donate/thanks' => sub {
    template 'thanks';
};


true;
