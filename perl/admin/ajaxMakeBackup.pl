#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use DBI;






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







if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

# =======================================================================================
#print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; # for debugging
# =======================================================================================

# ---------------------- REQUEST VARIABLES --------------------------------------------------
my $params = CGI->new();
my $v_p = $params->param("v_p");
my $v_s = $params->param("v_s");
my $v_u = $params->param("v_u");
my $v_x = $params->param("v_x");
# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objNavigation;
my $objConfig;
my $objDB;
my $objABL;
my $returnValue;
my $commandString;
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_year = (localtime())[5];
my $v_day_of_week = (localtime())[6];
   $v_year = $v_year +1900;
   $v_month = $v_month + 1;
my @modules;  
my $tmpPathString; 
my $dateiName;
# my $timeStamp = $v_year . "-" . $v_month . "-" . $v_day . "-" . $v_hour . "-" . $v_minute . "-" . $v_second;
my $timeStamp = $v_day_of_week ;

# ---------------------- create objects---------------------------------------------------------
$objConfig = PageConfig->new();
$objDB = DbConfig->new();
my $admin = AdminBusinessLayer->new();
# ---------------------- create backup ---------------------------------------------------------



# create backup if not logged on so far
$returnValue = "new system messages:";

    @modules = $objConfig->moduleArr(); #get names of all modules
    foreach my $i (@modules){

       $returnValue .= "<br />backing up '" . $i . "' in '" . $objDB->serverloc() . "'";

        #create directory and dump database

	if($objDB->serverloc() eq "live"){
		$tmpPathString = $objConfig->get("db-dump-path") .  $i . "Live";
		$commandString = "mysqldump -u" . $objDB->getDbUser($i) . " -p" . $objDB->getPassword($i) . " " . $i . "Live > " . $tmpPathString . "/" . $i . "-" . $timeStamp . ".sql" ;
	}else{
        	$tmpPathString = $objConfig->get("db-dump-path") .  $i . "Dev";
		$commandString = "mysqldump -u" . $objDB->getDbUser($i) . " -p" . $objDB->getPassword($i) . " " . $i . "Dev > " . $tmpPathString . "/" . $i . "-" . $timeStamp . ".sql" ;        
	}

        mkdir($tmpPathString);

        #first delete old file
        unlink($tmpPathString . "/" . $i . "-" . $timeStamp . ".sql");

	 # execute command
        $returnValue .= "<br />result of backup command: " . system($commandString);
        #chmod 0000, $tmpPathString . "/" . $i . "-" . $timeStamp . ".sql";

        #first delete old file
        unlink($tmpPathString . "/" . $i . "-" . $timeStamp . ".sql.gz");


        # now zip the file
        $commandString = "/bin/gzip " . $tmpPathString . "/" . $i . "-" . $timeStamp . ".sql" ;
        # $returnValue .= "<br />command of gzip : " . $commandString;
        $returnValue .= "<br />result of gzip : " .  system($commandString);

      	 #$commandString = "tar -C " . $tmpPathString  . " -czf "  . $tmpPathString . "/" . $i . "-" . $timeStamp . ".tgz " . $tmpPathString . "/" . $i . "-" . $timeStamp . ".sql" ;
      	 #$returnValue .= "<br />command of gzip : " . $commandString;
      	 #$returnValue .= "<br />result of tar: " .  system($commandString);

        $returnValue .= "<br />-------------------------------------------------------";
        
    }


$returnValue .= "<br />(" . $v_year . "-" . $v_month . "-" . $v_day . "-" . $v_hour . "-" . $v_minute . "-" . $v_second . ")";


print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";
print '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
print $returnValue;


exit 0;

