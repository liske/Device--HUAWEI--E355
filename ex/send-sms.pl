#!/usr/bin/perl

use strict;
use warnings;

use Device::HUAWEI::E355;

my $devip = shift || die "Usage: $0 <devip> <msg> <phone>+\n";
my $msg = shift || die "Usage: $0 <devip> <msg> <phone>+\n";
my @phones = @_;
my $e355 = Device::HUAWEI::E355->new($devip);

use Data::Dumper;
print Dumper($e355->send_sms($msg,  @phones));
