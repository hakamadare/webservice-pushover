#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Class::Load qw(try_load_class);

try_load_class("Test::Perl::Critic")
    or plan skip_all => "Test::Perl::Critic required for testing Perl::Critic";
Test::Perl::Critic::all_critic_ok(qw/bin lib t/);
