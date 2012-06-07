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
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WebService-Pushover-*' },
);
