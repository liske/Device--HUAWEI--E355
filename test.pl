#!/usr/bin/perl

use strict;
use warnings;

use Device::HUAWEI::E355;

my $e355 = Device::HUAWEI::E355->new('10.66.1.1');

use Data::Dumper;
print Dumper($e355->status);
print Dumper($e355->check_notifications);
print Dumper($e355->traffic_statistics);
print Dumper($e355->current_plmn);
