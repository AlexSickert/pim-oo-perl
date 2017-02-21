#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use MIME::Base64;

# THIS SCRIPT LOADS THE MAILS AS A TABLE

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';



if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error in ajaxLoadExistingMail.pl - evaluating objects: $@"; 
}

# do not delete next line - it's a ajax file...
print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
#print  "Content-type: text/html;Charset=utf-8". "\n\n"; # for unicode signes




# ----------------------------------------------------------------------------------

my $v_u = param("v_u");
my $v_s = param("v_s");

# ----------------------------------------------------------------------------------

my $objMailBusinessLayer = MailBusinessLayer->new();
my $objABL = AdminBusinessLayer->new();
my @arr;
my $y;
# ----------------------------------------------------------------------------------

# first check login

if($objABL->checkLogin($v_u, $v_s) eq 1 ){

	@arr = $objMailBusinessLayer->getRawMailsByFolderAndSearch("1","");
	# loop through array
   	for $y (0.. $#arr){
		# SELECT  id, sender, recipient, mail_subject, load_year, load_month, folder, read_version, folder_name, mail_status  FROM 
		print $arr[$y][0];
		print "<f>";
		print limitLength(decode_base64($arr[$y][1]));
		print "<f>";
		print limitLength(decode_base64($arr[$y][3]));
		print "<f>";
		print $arr[$y][9] ;
		print "<r>";
	}

#	print "credential OK";

}else{
	print "credential error";
}



# ----------------------------------------------------------------------------------
sub limitLength($)
{
	my $string = shift;
	if(length($string) > 50){
		return substr($string,0,50) . " (...)";
	}else{
		return $string;
	}
};
exit 0