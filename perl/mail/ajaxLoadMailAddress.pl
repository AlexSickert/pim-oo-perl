#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;

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


if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error in ajaxLoadExistingMail.pl - evaluating objects: $@"; 
}

# ---------------------------------------------------------------------------------------------------------------------------------
# getting parameters
# ---------------------------------------------------------------------------------------------------------------------------------

my $action = param("action") ;
my $v_u= param("v_u") ;
my $v_s= param("v_s") ;
my $target= param("targetId") ;
my $searchString = param("searchString");

# ---------------------------------------------------------------------------------------------------------------------------------
# create objects
# ---------------------------------------------------------------------------------------------------------------------------------

my $objMailBusinessLayer = MailBusinessLayer->new();
my $objDataBusinessLayer = DataBusinessLayer->new();
my @arr;
my $y;

# ---------------------------------------------------------------------------------------------------------------------------------
# initialize output
# ---------------------------------------------------------------------------------------------------------------------------------

print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

# ---------------------------------------------------------------------------------------------------------------------------------
# if we only want to initliaize the component
# ---------------------------------------------------------------------------------------------------------------------------------

if($action  eq "init"){

	print "<input type=\"button\" id=\"closeDiv\" value=\"close\" onclick=\"mailHideAddressDiv();\">";
	print "<input type=\"text\" name=\"searchText\" id=\"searchText\" value=\"\" size=\"20\" onkeyup=\"mailRefreshAddressList(\'searchText\', \'addressList\',\'" . $target . "\',\'" . $v_u . "\',\'" . $v_s . "\')\" >";
	print "<br>";
	print "<div id=\"addressList\">address list</div>";
}

# ---------------------------------------------------------------------------------------------------------------------------------
# if we want to update the content
# ---------------------------------------------------------------------------------------------------------------------------------


if($action  eq "search"){

	@arr = $objDataBusinessLayer->getEmailAddressBySearch($searchString );
   	for $y (0.. $#arr){
		print "<span onclick=\"mailUseAddress(\'" . $target . "\', \'" . $arr[$y][2] . "\');\" >" . $arr[$y][1]  . "&nbsp;[&nbsp;" . $arr[$y][2]  . "&nbsp;]</span><br>";
	}
}

# ---------------------------------------------------------------------------------------------------------------------------------
# end of output
# ---------------------------------------------------------------------------------------------------------------------------------



exit 0