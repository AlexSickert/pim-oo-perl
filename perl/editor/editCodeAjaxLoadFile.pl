#!/usr/bin/perl

use strict;
use CGI qw(:standard);
 
print  "Content-type: text/html;Charset=iso-8859-1". "\n\n\n\n\n";

my $db;
my $sql;
my $sql_string;


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
my $dirfile = $url;
my $data;
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

my $timestamp = '-' . $v_year . $v_month .  $v_day . $v_hour . $v_minute . $v_second . '.';


#------------------------------------------------------------

sub getXmlParameter{

    my $parameter = $_[0];
    
    if($_[1] eq "folderpath"){
        $parameter =~ m/<folderpath>(.*)<\/folderpath>/si;
        $parameter = "$1";
    }
    
    if($_[1] eq "id"){
        $parameter =~ m/<id>(.*)<\/id>/si;
        $parameter = "$1";
    }
    if($_[1] eq "v_u"){
        $parameter =~ m/<v_u>(.*)<\/v_u>/si;
        $parameter = "$1";
    } 
    if($_[1] eq "v_s"){
        $parameter =~ m/<v_s>(.*)<\/v_s>/si;
        $parameter = "$1";
    }    
    if($_[1] eq "filepath"){
        $parameter =~ m/<filepath>(.*)<\/filepath>/si;
        $parameter = "$1";
    }    
     
    $parameter =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;

return $parameter;
}
#------------------------------------------------------------------------------------------
#load

my $xml = param("xml");

my $filePath = getXmlParameter($xml,  'filepath');

#my $filePath =  '/var/www/vhosts/alex-admin.net//cgi-bin/dev/editor/editCodeAjax.pl';
	
	
	open (CHECKBOOK, $filePath) || die("Could not open file!");
	
	$codestring = "";
	
	while ($codepart = <CHECKBOOK>) {
		$codestring .= $codepart ;
		
	}
	
	close(CHECKBOOK);
	
	$codestring =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;

print $codestring;

exit 0;