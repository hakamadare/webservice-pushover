use Test::More tests => 1;

use WebService::Pushover;

BEGIN {
    can_ok( 'WebService::Pushover', qw( spore _apicall message user receipt sounds ) );
}

diag( "Testing 0.2.x methods" );
