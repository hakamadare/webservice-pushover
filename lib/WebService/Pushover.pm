package WebService::Pushover;
use base qw( WebService::Simple );
use warnings;
use strict;

binmode STDOUT, ":utf8";

use Carp;
use Data::Dumper;
use DateTime;
use DateTime::Format::Strptime;
use Params::Validate qw( :all );
use Readonly;

use version; our $VERSION = qv('0.0.1');

# Module implementation here

# constants
Readonly my $REGEX_TOKEN => '^[A-Za-z0-9]{30}$';
Readonly my $REGEX_DEVICE => '^[A-Za-z0-9_-]{0,25}$';

Readonly my $SIZE_TITLE => 50;
Readonly my $SIZE_MESSAGE => 512;
Readonly my $SIZE_URL => 200;

Readonly my $PUSHOVER_API => {
    json => {
        url => "https://api.pushover.net/1/messages.json",
        parser => "JSON",
    },
    xml => {
        url => "https://api.pushover.net/1/messages.xml",
        parser => "XML::Simple",
    },
};

__PACKAGE__->config(
    base_url => $PUSHOVER_API->{json}->{url},
    response_parser => $PUSHOVER_API->{json}->{parser},
);

my %push_spec = (
    token => {
        type  => SCALAR,
        regex => qr/$REGEX_TOKEN/,
    },
    user => {
        type  => SCALAR,
        regex => qr/$REGEX_TOKEN/,
    },
    device => {
        optional => 1,
        type     => SCALAR,
        regex    => qr/$REGEX_DEVICE/,
    },
    title => {
        optional  => 1,
        type      => SCALAR,
        callbacks => {
            "$SIZE_TITLE characters or fewer" => sub { length( shift() ) <= $SIZE_TITLE },
        },
    },
    message => {
        type      => SCALAR,
        callbacks => {
            "$SIZE_MESSAGE characters or fewer" => sub { length( shift() ) <= $SIZE_MESSAGE },
        },
    },
    timestamp => {
        optional  => 1,
        type      => SCALAR,
        callbacks => {
            "Unix epoch timestamp" => sub {
                my $timestamp = shift;
                my $strp = DateTime::Format::Strptime->new(
                    pattern   => '%s',
                    time_zone => "floating",
                    on_error  => "undef",
                );
                defined( $strp->parse_datetime( $timestamp ) );
            },
        },
    },
    priority => {
        optional  => 1,
        type      => SCALAR,
        callbacks => {
            "1 or undefined" => sub {
                my $priority = shift;
                ( ! defined( $priority ) )
                    or ( $priority == 1 );
            },
        },
    },
    url => {
        optional  => 1,
        type      => SCALAR,
        callbacks => {
            "valid URL" => sub {
                my $url = shift;
                my $uri = URI->new( $url );
                defined( $uri->as_string );
            },
        },
    },
);

sub push {
    my $self = shift;

    my %params = validate( @_, \%push_spec );

    my $response = $self->post( \%params );

    my $status = $response->parse_response;

    print Data::Dumper->Dump( [$status], [qw(*status)] );
}

1; # Magic true value required at end of module
__END__

=head1 NAME

WebService::Pushover - [One line description of module's purpose here]


=head1 VERSION

This document describes WebService::Pushover version 0.0.1


=head1 SYNOPSIS

    use WebService::Pushover;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
WebService::Pushover requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-webservice-pushover@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Steve Huff  C<< <shuff@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, Steve Huff C<< <shuff@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
