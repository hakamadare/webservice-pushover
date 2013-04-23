use Test::More tests => 1;

use WebService::Pushover;

BEGIN {
    can_ok( 'WebService::Pushover', qw( message user receipt ) );
}

diag( "Testing 0.1.x methods" );
