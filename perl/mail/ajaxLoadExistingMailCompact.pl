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
# print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
#print  "Content-type: text/html;Charset=utf-8". "\n\n"; # for unicode signes
print  "Content-type: text/html;Charset=utf-8". "\n\n";



# ----------------------------------------------------------------------------------
my $category = param("category");
my $mailId = param("mailId");

# ----------------------------------------------------------------------------------

my $objMailBusinessLayer = MailBusinessLayer->new();
# ----------------------------------------------------------------------------------

#print "in ajaxLoadExistingMail.pl...";


# get all mails that exist in the inbox

if($category eq 'unread' || $category eq 'read' || $category eq 'inbox'){
	print $objMailBusinessLayer->getMailsbyCategoryCompact('inbox');
}


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


exit 0