package perldancer;
use Dancer;
#use Template;

my @pages = qw(quickstart documentation contribute about example download);

get '/' => sub {
    my $toto;
    $toto += "";
    template 'home';
};

get '/:page' => sub {
    my ($page) = params->{page};
    pass and return false unless grep /$page/, @pages;
    template $page;
};

true;
