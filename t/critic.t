#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

eval "use Test::Perl::Critic";
plan skip_all => "Test::Perl::Critic required for testing Perl::Critic" if $@;
Test::Perl::Critic->import(-theme => 'core', -severity => 5);
all_critic_ok(qw/bin lib/);
