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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';

print "Content-type: text/html;Charset=utf-8". "\n\n";

# --------------------------------------- PARAMETER -----------------------------------------------

my $v_u = param("v_u");
my $v_s = param("v_s");
my $id = param("id");
my $content = param("content");

my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];
my $tmpString; 
my $objAdminBusinessLayer = AdminBusinessLayer->new();

if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){

	# my $filename = "/var/www/vhosts/alex-admin.net/statistics/logs/form-field-change-backup-log-" . $v_year . $v_month .  $v_day . '.txt';
	$v_year = $v_year + 1900;
	$v_month = $v_month + 1;
	my $filename = " /var/www/vhosts/alex-admin.net/httpdocs/db_backup/form-field-change-backup-log-" . $v_year . "-" . $v_month .  "-" .  $v_day . '.pl';

	if (! open WF, ">>$filename"){   
		print "file not existing - create new file... "; 
		if (! open WF, ">$filename"){   
			print "...cannot create file..."; 
		}
	}
	binmode WF;
	$tmpString = "\n" . "----------" . $v_u .  "----------" . $id . "----------" . "\n";
	print WF $tmpString;
	print WF $content;
	close WF;

	print 'form field change backup done: ' . $content;


}else{
	print 'permission denied';
}

exit 0;