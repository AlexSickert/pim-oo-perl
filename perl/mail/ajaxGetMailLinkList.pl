#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use Net::POP3;
use MIME::Base64;

# --------------------------------------- PURPOSE -----------------------------------------------
# load a list of mails according to the ids transmitted


# --------------------------------------- INCLUDES -----------------------------------------------

require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';

# --------------------------------------- HEADER -----------------------------------------------

if($@) { 
	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print "Error in ajaxLoadMail.pl - evaluating objects: $@"; 
}

# do not delete next line - it's a ajax file...
print "Content-type: text/html;Charset=iso-8859-1". "\n\n";

# --------------------------------------- VARIABLES -----------------------------------------------
my $return;
my @arr;
my $y;
my $tmpString;
# --------------------------------------- PARAMETER -----------------------------------------------

my $vs = param("v_s");
my $vu = param("v_u");
my $ids = param("ids");

# --------------------------------------- OTHER -----------------------------------------------

# --------------------------------------- OBJECTS-----------------------------------------------

my $objAdmBusiLayer = AdminBusinessLayer->new();
my $objMailBusiLayer = MailBusinessLayer->new();

# --------------------------------------- PROGRAM -----------------------------------------------

#  id, sender, recipient, mail_subject, load_year, load_month

# $arr[1] = decode_base64($arr[1]);
#   $arr[2] = decode_base64($arr[2]);
#   $arr[3] = decode_base64($arr[3]);

@arr = $objMailBusiLayer->getMailsByIds($ids);
$return = "";
for $y (0.. $#arr){
	$return .= "<tr><td class='dataMailList' onclick='baseShowPopMail(\"" . $arr[$y][0] . "\", \"" . $vs . "\", \"" . $vu . "\")'>";

	$tmpString = decode_base64($arr[$y][1]);
	$tmpString =~ s/<//gi;
	$tmpString =~ s/>//gi;
	$tmpString =~ s/"//gi;
	$tmpString =~ s/'//gi;
	$return .= substr($tmpString, 0, 20);

	$return .= "&nbsp;|&nbsp;";

	$tmpString = decode_base64($arr[$y][3]);
	$tmpString =~ s/</[/gi;
	$tmpString =~ s/>/]/gi;
	$tmpString =~ s/"//gi;
	$tmpString =~ s/'//gi;

	$return .= substr($tmpString, 0, 30);

	$return .= "</td></tr>\n";
}

print "<table>" . $return . "</table>";
# --------------------------------------- END OF PROGRAM ------------------------------------
exit 0