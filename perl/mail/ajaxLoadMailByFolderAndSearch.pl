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
   #print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print  "Content-type: text/html;Charset=utf-8". "\n\n";
   print "Error in ajaxLoadExistingMail.pl - evaluating objects: $@"; 
}

# ----------------------------------------------------------------------------------
my $folderId = param("folderId") . "";
my $searchString = param("searchString");

# ----------------------------------------------------------------------------------

my $objMailBusinessLayer = MailBusinessLayer->new();
# ----------------------------------------------------------------------------------
print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

# steps necessary:

# 1. if category = unread then run this method

if($folderId eq ""){
 $folderId = 1;
}

#print "result: ";

$searchString = myTrim($searchString);
$searchString =~ s/ /%/gi;
print $objMailBusinessLayer->getMailsByFolderAndSearch($folderId, $searchString );


# ----------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------
my $iii;
my $yClean = 0;
foreach (@INC) {
    #print ++$iii,". Pfad: $_<br>\n";
    if($_ eq '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes' || $_ eq '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/dev/perl/classes'){
        $INC[$yClean] = "";
        $yClean = $yClean +1;
    }
}
$iii = 0;
foreach (@INC) {
    #print ++$iii,". Pfad: $_<br>\n";
    if($_ eq '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes' || $_ eq '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/dev/perl/classes'){
        $INC[$yClean] = "";
        $yClean = $yClean +1;
    }
}
#----------------------------------------------------------------------------------------------------------------------

sub myTrim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

exit 0