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

use XML::TreePP;

=head1 CONSTRUCTOR

=head2 new

The new() constructor

  my $e355 = Huawei->new($devip);

=cut


sub new($$) {
    my $this = shift;
    my $class = ref($this) || $this;

    my $self = {
	devip => shift,
	tpp => XML::TreePP->new(),
    };

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

=head1 AUTHOR

Thomas Liske <thomas@fiasko-nw.net>

=head1 LICENSE

Copyright (c) 2013 Thomas Liske <thomas@fiasko-nw.net>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
