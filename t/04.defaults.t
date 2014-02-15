#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use WebService::Pushover;
use Readonly;

Readonly my $FAKE_USER_TOKEN => '123456789012345678901234567890';
Readonly my $FAKE_API_TOKEN  => '123456789012345678901234567890';

my $pushover;

lives_ok( sub {
    $pushover = WebService::Pushover->new(
        user_token => $FAKE_USER_TOKEN,
        api_token  => $FAKE_API_TOKEN,
    );
}, "Make pushover object with defaults");

# Make sure we can read the values back.
is($pushover->user_token, $FAKE_USER_TOKEN);
is($pushover->api_token,  $FAKE_API_TOKEN);

done_testing;
