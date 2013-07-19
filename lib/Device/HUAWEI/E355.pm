require Exporter;

package Device::HUAWEI::E355;

=head1 NAME

Device::HUAWEI:E355 - Perl package for accessing the HUAWEI E355 API

=head1 SYNOPSIS

  use Data::Dumper;
  use Device::HUAWEI::E355;
  my $e355 = Huawei->new($devip);
  print Dumper($e355->status);

=cut

use strict;
use vars qw($VERSION @ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT_OK = (qw{PI DEG RAD KNOTS});
$VERSION = '0.01';

use MIME::Base64;
use POSIX qw(strftime);
use XML::TreePP;
use XML::Writer;
use XML::Writer::String;

=head1 CONSTRUCTOR

=head2 new

The new() constructor

  my $e355 = Huawei->new($devip, $username, $password);

=cut


sub new($$) {
    my $this = shift;
    my $class = ref($this) || $this;

    my $self = {
	devip => shift,
	auth_user => shift,
	auth_pass => shift,
	tpp => XML::TreePP->new(),
    };

    # prepare password
    if(defined($self->{auth_pass})) {
	$self->{auth_pass} = encode_base64($self->{auth_pass});
	chomp($self->{auth_pass});
    }

    bless $self, $class;
    return $self;
}

=head1 METHODS

=cut

sub _get($$) {
    my $self = shift;
    my $call = shift;

    my ($tree, $xml, $code) = $self->{tpp}->parsehttp(GET => "http://$self->{devip}$call");

    return $tree->{response} if($code == 200);

    return undef;
}

sub _post($$$) {
    my $self = shift;
    my $call = shift;
    my $body = shift;

    my ($tree, $xml, $code) = $self->{tpp}->parsehttp(POST => "http://$self->{devip}$call", $body);

    return $tree->{response} if($code == 200);

    return undef;
}

sub _auth() {
    my ($self) = @_;

    my $s = XML::Writer::String->new();
    my $w = new XML::Writer( OUTPUT => $s );

    $w->xmlDecl();
    $w->startTag('request');
    $w->dataElement('Username', $self->{auth_user});
    $w->dataElement('Password', $self->{auth_pass});
    $w->endTag();
    $w->end();

    return $self->_post('/api/user/login', $s->value());
}

=head2 status

Retrieves WAN, Wifi and SIM status informations as a hash ref.
Returns undef on error.

=cut

sub status($) {
    my $self = shift;

    return $self->_get('/api/monitoring/status');
}


=head2 check_notifications

Retrieves pending notifications (SMS related).
Returns undef on error.

=cut

sub check_notifications($) {
    my $self = shift;

    return $self->_get('/api/monitoring/check-notifications');
}


=head2 traffic_statistics

Returns current and total connection time, download & upload rate
and size. Returns undef on error.

=cut

sub traffic_statistics($) {
    my $self = shift;

    return $self->_get('/api/monitoring/traffic-statistics');
}


=head2 current_plmn

Returns informations about the current Public Land Mobile Network
provider. Returns undef on error.

=cut

sub current_plmn($) {
    my $self = shift;

    return $self->_get('/api/net/current-plmn');
}


=head2 send_sms($phone, $msg)

Sends a SMS. Returns undef on error.

=cut

sub send_sms($$@) {
    my ($self, $msg, @phones) = @_;

    # prepare SMS DOM
    my $s = XML::Writer::String->new();
    my $w = new XML::Writer( OUTPUT => $s );

    $w->xmlDecl();
    $w->startTag('request');
    $w->dataElement('Index', -1);
    $w->startTag('Phones');
    foreach my $phone (@phones) {
	$w->dataElement('Phone', $phone);
    }
    $w->endTag();
    $w->dataElement('Sca', '');
    $w->dataElement('Content', $msg);
    $w->dataElement('Length', length($msg));
    $w->dataElement('Reserved', 1);
    $w->dataElement('Date', strftime("%F %T", gmtime()));
    $w->endTag();
    $w->end();

    # (re)authenticate (required to send SMS)
    $self->_auth();

    return $self->_post('/api/sms/send-sms', $s->value());
}

=head1 AUTHOR

Thomas Liske <thomas@fiasko-nw.net>

=head1 LICENSE

Copyright (c) 2013 Thomas Liske <thomas@fiasko-nw.net>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
