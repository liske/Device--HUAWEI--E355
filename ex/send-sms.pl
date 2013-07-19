#!/usr/bin/perl

use strict;
use warnings;

use Device::HUAWEI::E355;

my $devip = shift || die "Usage: $0 <devip> <msg> <phone>+\n";
my $msg = shift || die "Usage: $0 <devip> <msg> <phone>+\n";
die "Usage: $0 <devip> <msg> <phone>+\n" if($#ARGV == -1);

$|++;
print "Username: ";
my $uname = <>;
chomp($uname);

print "Password: ";
my $passw = <>;
chomp($passw);

my $e355 = Device::HUAWEI::E355->new($devip, $uname, $passw);

use Data::Dumper;
print Dumper($e355->send_sms($msg,  @ARGV));
