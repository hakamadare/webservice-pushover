use Test::More tests => 2;

use WebService::Pushover;

ok $push = WebService::Pushover->new;

TODO: {
    local $TODO = "Haven't figured out how to test lazy object creation";

    isa_ok( $push->spore, 'Net::HTTP::Spore'  );
}

diag( "Testing instantiation of Net::HTTP::Spore object" );
