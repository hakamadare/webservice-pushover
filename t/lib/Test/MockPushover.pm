package Test::MockPushover;
use warnings;
use strict;

use Test::More;
use Test::Deep;
use Test::Fake::HTTPD;
use WebService::Pushover;
use JSON;

use base 'Exporter';
our @EXPORT_OK = qw/
	spin_mock_server
	pushover_ok
/;
our @EXPORT = @EXPORT_OK;

my $httpd;
my $push;

sub spin_mock_server
{
	$push = WebService::Pushover->new(@_);

	$httpd = run_http_server {
		my $request = shift;

		my $data = {}; eval { $data = from_json($request->content) };

		my $req_params = $request->uri->as_string;
		$req_params =~ s/^.*\?//;
		for my $pair (split /&/, $req_params) {
			my ($k, $v) = split /=/, $pair;
			$data->{$k} = $v;
		}

		my %headers = map { $_ => $request->headers->header($_) }
			$request->headers->header_field_names;

		my $response = to_json({ headers => \%headers, data => $data, path => $request->uri->path });

		return [
			200,
			[ 'Content-Type' => 'application/json' ],
			[ $response ],
		];
	};

	$push->spore->base_url($httpd->endpoint);

}

sub pushover_ok
{
	my ($method, $provided, $expect, $msg) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	my $data = $push->$method(%$provided);

	cmp_deeply($data, $expect, $msg)
		or diag explain $data;
}

1;
