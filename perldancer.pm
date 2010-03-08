package perldancer;
use Dancer;
use Template;

get '/' => sub {
    template 'home';
};

get '/donate/thanks' => sub {
    template 'thanks';
};

true;
