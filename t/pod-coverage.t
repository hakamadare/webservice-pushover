#!perl -T

use warnings;
use strict;

use Test::More;
use Class::Load qw(try_load_class);

my $min_tpc = 1.04;
try_load_class('Test::Pod::Coverage', {-version => $min_tpc})
    or plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage";
Test::Pod::Coverage::all_pod_coverage_ok();
