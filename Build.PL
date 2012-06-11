use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WebService::Pushover',
    license             => 'perl',
    dist_author         => 'Steve Huff <shuff@cpan.org>',
    dist_version_from   => 'lib/WebService/Pushover.pm',
    requires => {
        'version'                    => 0,
        'DateTime'                   => 0,
        'DateTime::Format::Strptime' => 0,
        'Params::Validate'           => 0,
        'Readonly'                   => 0,
        'URI'                        => 0,
        'WebService::Simple'         => 0
    },
    configure_requires => {
        'Module::Build' => 0.38,
    },
    test_requires => {
        'Test::More'          => 0,
        'Test::Perl::Critic'  => 0,
        'Test::Pod::Coverage' => 1.04,
        'Test::Pod'           => 1.14,
    },
    meta_merge => {
        resources => {
            homepage   => 'https://github.com/hakamadare/webservice-pushover',
            bugtracker => 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Pushover',
            repository => 'git://github.com/hakamadare/webservice-pushover.git',
        },
    },
    add_to_cleanup      => [ 'WebService-Pushover-*' ],
);

$builder->create_build_script();
