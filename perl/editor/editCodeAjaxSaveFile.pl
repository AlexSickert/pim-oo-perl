#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;

#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm`;
#eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm`;


require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
#require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';



if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}




my $objConfig;
$objConfig = PageConfig->new();

my $admin = AdminBusinessLayer->new();


print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

my $db;
my $sql;
my $sql_string;

my $code;
my $v_s = param("v_s");
my $v_u = param("v_u");
my $url = param("url");
my @urlarray = split(/\//, $url);
my $code = param("code");
my $deploy = param("deploy");
my $deployDir = '';
my $action = param("action");
my $codestring = "";
my $codepart = "";

my $backupdir = $objConfig->get("db-dump-path");
my $dirfile = $url;
my $data;
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

my $timestamp = '-' . $v_year .'-'. $v_month .'-'.  $v_day .'-'. $v_hour .'-'. $v_minute .'-'. $v_second . '.';

#do "../includes/server_location.pl";
# do "admin_header.pl";

#------------------------------------------------------------
#print "-1-";

sub getXmlParameter{

    my $parameter = $_[0];
    
    if($_[1] eq "filepath"){
        $parameter =~ m/<filepath>(.*)<\/filepath>/si;
        $parameter = "$1";
    }
    
    if($_[1] eq "action"){
        $parameter =~ m/<action>(.*)<\/action>/si;
        $parameter = "$1";
    }
    if($_[1] eq "content"){
        $parameter =~ m/<content>(.*)<\/content>/si;
        $parameter = "$1";
    } 
        
    $parameter =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;

return $parameter;
}
#------------------------------------------------------------------------------------------
#load
#print "-2-";
my $xml = param("xml");
# print $xml;
#print "-3-";

my $filePath = getXmlParameter($xml,  'filepath');
my $action = getXmlParameter($xml,  'action');
my $content = getXmlParameter($xml,  'content');

$content =~ s/#percentpercentpercentzerotwoix#/%%%02X/g;
$content =~ s/#SpecialCharPlusSign#/+/g;

my @filePathArlarray = split(/\//, $filePath);
my $permissions = 0755;
#$content =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;

#print "---------filePath:---|";
#print $filePath;
#print "|---------4-";
# print  $content;

if ($action eq "save" || $action eq "deploy"){	
		
       $content =~ s/\n\r/\n/;
       $content =~ s/\r\n/\n/;


	

        open (WF, ">" . $filePath) || die("Could not open file " . $filePath . "  for writing!");
            binmode $content;
            binmode WF;		
            print WF $content; 
        close WF;
	
        chmod($permissions,  $filePath  );
        
        #register file for sync
        $filePath =~ s/\/\/\//\//g;
        $filePath =~ s/\/\//\//g;
        #$admin->registerFileForSync($filePath, "new");
        

        # create backup
	my $fileNamePart = @filePathArlarray[@filePathArlarray -1 ];

         $fileNamePart =~ s/[.]/$timestamp/;
        
	#print $backupdir . $fileNamePart;
	 open (BF, ">" . $backupdir . $fileNamePart ) || die("Could not open backup-file for writing!");		
		 binmode $content;
		 binmode BF;		
		 print BF $content; 
	 close BF;

	if ($action eq "deploy" ){
		#deploy file to live

		$deployDir = $filePath;       
		$deployDir =~ s/\/dev\//\/live\//;
				
		open (WF, ">" . $deployDir) || die("Could not open file for writing!");
		binmode $content;
		binmode WF;		
		print WF $content; 
		close WF;

		chmod($permissions,  $deployDir  );
        	#register file for sync  
        	$deployDir =~ s/\/\/\//\//g;
        	$deployDir =~ s/\/\//\//g; 
        	#$admin->registerFileForSync($deployDir, "new");        
	
		#deploy file to dev
		$deployDir = $filePath;
		$deployDir =~ s/\/live\//\/dev\//;
				
		open (WF, ">" . $deployDir) || die("Could not open file for writing!");
		binmode $content;
		binmode WF;		
		print WF $content; 
		close WF;

		chmod($permissions,  $deployDir  );
        	#register file for sync
        	$deployDir =~ s/\/\/\//\//g;
	       $deployDir =~ s/\/\//\//g; 
       	#$admin->registerFileForSync($deployDir, "new");   
        
	}

}

# das ist hier zum codieren
#$codestring =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
#zum decodieren
#$parameter =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;

print "File" . $filePath . " action = ". $action . " - OK !";

exit 0;



