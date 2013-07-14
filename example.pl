#!/usr/bin/perl

use strict;
use warnings;

use Device::HUAWEI::E355;

my $devip = shift || die "Usage: $0 <devip>\n";
my $e355 = Device::HUAWEI::E355->new($devip);

use Data::Dumper;
print Dumper($e355->status);
print Dumper($e355->check_notifications);
print Dumper($e355->traffic_statistics);
print Dumper($e355->current_plmn);
