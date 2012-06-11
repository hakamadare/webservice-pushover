use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WebService::Pushover',
    AUTHOR              => 'Steve Huff <shuff@cpan.org>',
    VERSION_FROM        => 'lib/WebService/Pushover.pm',
    ABSTRACT_FROM       => 'lib/WebService/Pushover.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'version'                    => 0,
        'DateTime'                   => 0,
        'DateTime::Format::Strptime' => 0,
        'Params::Validate'           => 0,
        'Readonly'                   => 0,
        'URI'                        => 0,
        'WebService::Simple'         => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'          => 0,
        'Test::Perl::Critic'  => 0,
        'Test::Pod::Coverage' => 1.04,
        'Test::Pod'           => 1.14,
    },
    META_MERGE => {
        resources => {
            homepage   => 'https://github.com/hakamadare/webservice-pushover',
            bugtracker => 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Pushover',
            repository => 'git://github.com/hakamadare/webservice-pushover.git',
        },
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WebService-Pushover-*' },
);
