#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use lib qw(lib);
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
use Getopt::Mini;

use Net::MyPeople::Bot::IPUpdator;
use LWP::Simple;

use Data::Printer;

my @argv = $ARGV{''}?@{$ARGV{''}}:();
my ($daumid, $daumpw, $ip) = @argv;
if( @argv < 2 ){
	print "Daum MyPeople Bot API - Server IP Updator\n\n";
	print "usage:\t$0 DAUMID DAUMPW IPADDR\n";
	print "or\t$0 DAUMID DAUMPW\n\n";
	print "options:\n";
	print "\t--myip=MYIP_SERVICE_URL\n";
	exit;
}

my $myip = $ARGV{myip};
my @myips = qw( http://mabook.com:8080/myip http://http://ifconfig.me/ip $myip);
while( !$ip ){
	$ip = get(shift @myips);
}
DEBUG "MY IP : $ip";
my $res = Net::MyPeople::Bot::IPUpdator::update($daumid,$daumpw,$ip);
if( $res ){
	print "OK\n";
}
else{
	print "FAIL\n";
}
