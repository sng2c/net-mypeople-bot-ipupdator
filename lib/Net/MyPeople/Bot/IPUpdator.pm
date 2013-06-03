use strict;
use warnings;
package Net::MyPeople::Bot::IPUpdator;
use WWW::Mechanize;
use Data::Printer;
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);

# ABSTRACT: Update server IP address setting for MyPeople Bot API. 

# VERSION

our $API_SETTING = 'http://dna.daum.net/myapi/authapi/mypeople';

sub update{
	my $daumid = shift;
	my $daumpw = shift;
	my $ip = shift;

	my $mech = WWW::Mechanize->new;
	$mech->get($API_SETTING);

	my $res = $mech->submit_form(
		form_name=>'loginform',
		fields => {
			id=>$daumid,
			pw=>$daumpw,
			securityLevel=>1,
		},
	);
	unless( $res->header('x-daumlogin-error') =~ /^200/ ){
		ERROR 'Daum Login Fail';
		return 0;
	}

	$mech->get($API_SETTING);
	my $link = $mech->find_link( url_regex=>qr@/myapi/authapi/mypeople/.+/modify@ );
	unless( $link ){
		ERROR 'No registered bot.';
		return 0;
	}

	DEBUG $link->url_abs;
	$res = $mech->get($link->url_abs);

	DEBUG $res->decoded_content;
	$res = $mech->submit_form(
		form_name=>'form_auth_new',
		fields => {
			bot_ip=>$ip,
			chkPurpose=>'on',
		});

	DEBUG $res->decoded_content;
	return 1;
}
1;

=head1 SYNOPSIS

	use Net::MyPeople::Bot::IPUpdator;

	use Log::Log4perl qw(:easy);
	Log::Log4perl->easy_init($DEBUG); # You can see all logs.

	my $res = Net::MyPeople::Bot::IPUpdator::update($daumid,$daumpw,$ip);
	if( $res ){ # OK
		print "IPADDR is updated to $ip\n";
		print "OK\n";
	}
	else{
		print "FAIL\n";
	}

or

	$ mypeople_bot_ipupdate DAUMID DAUMPW IPADDR

=head1 SEE ALSO

=over

=item * 

L<Net::MyPeople::Bot>

=item *

MyPeople : L<https://mypeople.daum.net/mypeople/web/main.do>

=item *

MyPeople Bot API Home : L<http://dna.daum.net/apis/mypeople>

=item *

MyPeople Bot API Buffer Service : L<http://mabook.com:8080/>

=back


=cut
