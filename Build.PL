use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WebService::Pushover',
    license             => 'perl',
    dist_author         => 'Steve Huff <shuff@cpan.org>',
    dist_version_from   => 'lib/WebService/Pushover.pm',
    requires => {
        'Test::More'                 => 0,
        'version'                    => 0,
        'DateTime'                   => 0,
        'DateTime::Format::Strptime' => 0,
        'Params::Validate'           => 0,
        'Readonly'                   => 0,
        'URI'                        => 0,
        'WebService::Simple'         => 0
    },
    add_to_cleanup      => [ 'WebService-Pushover-*' ],
);

$builder->create_build_script();
