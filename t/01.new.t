use Test::More tests => 3;

use WebService::Pushover;

BEGIN {
    new_ok( 'WebService::Pushover' );
    new_ok( 'WebService::Pushover' => [ debug => 0 ] );
    new_ok( 'WebService::Pushover' => [ debug => 1 ] );
}

diag( "Testing instantiation of WebService::Pushover object" );
