#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use File::Spec;

eval "use Test::Perl::Critic";
plan skip_all => "Test::Perl::Critic required for testing Perl::Critic" if $@;
my $rcfile = File::Spec->catfile( 't', 'perlcriticrc' );
Test::Perl::Critic->import( -profile => $rcfile );
all_critic_ok(qw/bin lib/);
