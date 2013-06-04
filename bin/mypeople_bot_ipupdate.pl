#!/usr/bin/env perl

# VERSION 
# PODNAME: mypeople-bot-ipupdate.pl
# ABSTRACT: Update server IP address setting for MyPeople Bot API 

use strict;
use warnings;
use utf8;
use lib qw(lib);
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);
use Getopt::Mini;

use Net::MyPeople::Bot::IPUpdator;

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

my $updator;
if($myip){
	$updator = Net::MyPeople::Bot::IPUpdator->new(daum_id=>$daumid,daum_pw=>$daumpw,myip_url=>$myip);
}
else{
	$updator = Net::MyPeople::Bot::IPUpdator->new(daum_id=>$daumid,daum_pw=>$daumpw);
}
my $nowip = $updator->update($ip);

if( $nowip ){
	print "IPADDR is updated to $nowip\n";
	print "OK\n";
}
else{
	print "FAIL\n";
}

=pod

=head1 SYNOPSIS

	Daum MyPeople Bot API - Server IP Updator

	usage:  mypeople_bot_ipupdate.pl DAUMID DAUMPW IPADDR
	or      mypeople_bot_ipupdate.pl DAUMID DAUMPW

	options:
	        --myip=MYIP_SERVICE_URL


	$ mypeople_bot_ipupdate DAUMID DAUMPW
	IPADDR is updated to XXX.XXX.XXX.XXX
	OK

	$ mypeople_bot_ipupdate DAUMID DAUMPW IPADDR
	IPADDR is updated to XXX.XXX.XXX.XXX
	OK

	$ mypeopel_bot_ipupdate --myip=http://ifconfig.me/ip DAUMID DAUMPW
	IPADDR is updated to XXX.XXX.XXX.XXX
	OK

	$ mypeopel_bot_ipupdate --myip=http://ifconfig.me/ip --myip=http://mabook.com:8080/myip DAUMID DAUMPW
	IPADDR is updated to XXX.XXX.XXX.XXX
	OK

=cut
