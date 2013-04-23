use Test::More tests => 1;

use WebService::Pushover;

BEGIN {
    can_ok( 'WebService::Pushover', qw( push tokens ) );
}

diag( "Testing 0.0.x methods" );
