#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use Net::POP3;
use MIME::Base64;

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
   print "Error in ajaxLoadMail.pl - evaluating objects: $@"; 
}

# do not delete next line - it's a ajax file...
print "Content-type: text/html;Charset=iso-8859-1". "\n\n";


# --------------------------------------- VARIABLES -----------------------------------------------

# --------------------------------------- PARAMETER -----------------------------------------------
my $clipId = param("id");
my $action = param("action");

# --------------------------------------- OTHER -----------------------------------------------

# --------------------------------------- OBJECTS-----------------------------------------------

my $objAdmBusiLayer = AdminBusinessLayer->new();

# --------------------------------------- PROGRAM -----------------------------------------------

if($action ne 'add'){
	$objAdmBusiLayer ->setParameter('mail','mail-clip', '' );
	print "ajaxClipMail.pl - cleared the clip";
}else{
	# setParameter
	my $tmpClip = $objAdmBusiLayer ->getParameter('mail','mail-clip');
	my $finalClip;
	if($tmpClip ne ''){
		$finalClip = $tmpClip . "," . $clipId;
	}else{
		$finalClip = $clipId;
	}
	$objAdmBusiLayer ->setParameter('mail','mail-clip', $finalClip );
	print "clipped " . $clipId. ". Now total clip: " . $objAdmBusiLayer ->getParameter('mail','mail-clip');
}

# --------------------------------------- END OF PROGRAM ------------------------------------

exit 0