package WebService::Pushover;
use base qw( WebService::Simple );
use warnings;
use strict;

binmode STDOUT, ":encoding(UTF-8)";

use Carp;
use DateTime;
use DateTime::Format::Strptime;
use Params::Validate qw( :all );
use Readonly;
use URI;

use version; our $VERSION = qv('0.0.2');

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

    return $status;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

WebService::Pushover - interface to Pushover API


=head1 VERSION

This document describes WebService::Pushover version 0.0.2.


=head1 SYNOPSIS

    use WebService::Pushover;

    my $push = WebService::Pushover->new
        or die( "Unable to instantiate WebService::Pushover.\n" );

    my %params = (
        token => 'PUSHOVER API TOKEN',
        user => 'PUSHOVER USER TOKEN',
        message => 'test test test',
    );

    my $status = $push->push( %params );

=head1 DESCRIPTION

This module provides a Perl wrapper around the Pushover
( L<http://pushover.net> ) RESTful API.  You'll need to register with
Pushover to obtain an API token for yourself and for your application
before you'll be able to do anything with this module.

=head1 INTERFACE

=over 4

=item new()

Inherited from L<WebService::Simple>, and takes all the same arguments; you
shouldn't need to pass any under normal use.

=item push(I<%params>)

I<push()> sends a message to Pushover and returns a scalar reference
representation of the message status.  The following are valid parameters:

=over 4

=item token B<REQUIRED>

The Pushover application token, obtained by registering at L<http://pushover.net/apps>.

=item user B<REQUIRED>

The Pushover user token, obtained by registering at L<http://pushover.net>.

=item device B<OPTIONAL>

The Pushover device name; if not supplied, the message will go to all devices
registered to the user token.

=item title B<OPTIONAL>

A string that will appear as the title of the message; if not supplied, the
name of the application registered to the application token will appear.

=item message B<REQUIRED>

A string that will appear as the body of the message.

=item timestamp B<OPTIONAL>

The desired message timestamp, in Unix epoch seconds.

=item priority B<OPTIONAL>

Set this value to "1" to mark the message as high priority, or leave it unset
for standard priority.

=item url B<OPTIONAL>

A string that will appear as an supplementary URL associated with the message.

=back

=back

=head1 DIAGNOSTICS

Inspect the value returned by I<push()>, which will be a Perl data structure
parsed from the JSON response returned by the Pushover API.  Under normal
operation it will contain one key, "status", with a value of "1"; in the event
of an error, there will also be an "errors" key.

=head1 DEPENDENCIES

=over 4

=item L<DateTime>

=item L<DateTime::Format::Strptime>

=item L<Params::Validate>

=item L<Readonly>

=item L<URI>

=item L<WebService::Simple>

=back

=head1 BUGS AND LIMITATIONS

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
