#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use WebService::Pushover;
use Readonly;

Readonly my $FAKE_USER_TOKEN => '123456789012345678901234567890';
Readonly my $FAKE_API_TOKEN  => '123456789012345678901234567890';

Readonly my $OTHER_USER_TOKEN => '098765432109876543210987654321';
Readonly my $OTHER_API_TOKEN  => '098765432109876543210987654321';

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

# Sure, there's better ways to do this than monkey-patching.
# You should submit a pull request adding them! :)

{

    # Calls which expect both user and token defaults

    no warnings 'redefine';
    local *WebService::Pushover::_apicall = sub {
        my ($self, $call, %params) = @_;

        is($params{user}, $FAKE_USER_TOKEN,"$call / default user");
        is($params{token},$FAKE_API_TOKEN, "$call / default token");

        return;
    };

    $pushover->message();
    $pushover->user();
}

{

    # Calls which expect both user and token defaults,
    # but passing in overrides

    no warnings 'redefine';
    local *WebService::Pushover::_apicall = sub {
        my ($self, $call, %params) = @_;

        is($params{user}, $OTHER_USER_TOKEN,"$call / passed user");
        is($params{token},$OTHER_API_TOKEN, "$call / passed token");

        return;
    };

    $pushover->message( user => $OTHER_USER_TOKEN, token => $OTHER_API_TOKEN);
    $pushover->user(    user => $OTHER_USER_TOKEN, token => $OTHER_API_TOKEN);

}

{

    # Calls which expect just token to be defaulted.

    no warnings 'redefine';
    local *WebService::Pushover::_apicall = sub {
        my ($self, $call, %params) = @_;

        is($params{token},$FAKE_API_TOKEN, "$call / default token");

        return;
    };

    $pushover->receipt();
    $pushover->sounds();
}

done_testing;
