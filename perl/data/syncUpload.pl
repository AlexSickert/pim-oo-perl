#!/usr/bin/perl

use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw(:standard);
use warnings;
use File::stat;
use Time::localtime;
use MIME::Base64;

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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Utility.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

# =======================================================================================
# print default header
print "Content-type: text/html;Charset=iso-8859-1". "\n\n";

# =======================================================================================

# define variables

my $mimeType;
my $uploadPathWithName = param('filePath');
my $localPathWithName;
my $localPath;
my $localRandomName;
my $localPathFragmentWithName;
my $timestamp = param('fileTime');
my $fileContent = param('fileContent');
my $permissions = 0777;
my $pathFirstPart;
my $pathSecondPart;
my $a;
my @path_array;
my @mime_array;
my $fileName;
my $fileBinaryContent;

if (! defined($uploadPathWithName )){ $uploadPathWithName = 0;};
if (! defined($timestamp )){ $timestamp = 0;};
if (! defined($fileContent )){ $fileContent = 0;};
# =======================================================================================

# creating objects

my $objDataBusinessLayer = DataBusinessLayer->new();
my $objConfig = PageConfig->new();
my $objUtil = Utility->new();

# =======================================================================================

# extract file name

$uploadPathWithName =~ s/\//\|/g;
$uploadPathWithName =~ s/\\/\|/g;

#$uploadPathWithName
@path_array = split(/\|/,$uploadPathWithName );     # Array der einzelnen Teilstrings
$a = @path_array;     # Anzahl der Elemente
$fileName = $path_array[$a-1];
print $fileName ;

@mime_array = split(/\./,$fileName );     # Array der einzelnen Teilstrings
$a = @mime_array; 
$mimeType = $mime_array[$a-1];
print "MIME=" . $mimeType;

$pathFirstPart = $objUtil->getRandomNumericString(2);
$pathSecondPart = $objUtil->getRandomNumericString(2);
$localPath = $objConfig->cmsPath()  . $pathFirstPart;
if(! -e $localPath ){   mkdir($localPath ,$permissions);};	
$localPath = $localPath . "/"  . $pathSecondPart ;
if(! -e $localPath ){   mkdir($localPath ,$permissions);};	

my @timeArray = localtime(time);
my $v_second = $timeArray[0][0];
my $v_minute = $timeArray[0][1];
my $v_hour = $timeArray[0][2];
my $v_day = $timeArray[0][3];
my $v_month = $timeArray[0][4];
my $v_year = $timeArray[0][5];


my $timeFragment = $v_year . "-" . $v_month . "-" . $v_day . "-" . $v_hour . "-" . $v_minute . "-" . $v_second . "-";

$localRandomName = $timeFragment . $objUtil->getRandomString(10) . ".dat";
$localPathFragmentWithName = $pathFirstPart . "/" . $pathSecondPart . "/" . $localRandomName;
print "localPathFragmentWithName=" . $localPathFragmentWithName ;
$localPath = $localPath . "/" . $localRandomName;

# the local path is the real local path with file name
print "localPath =" . $localPath ;

# --------------------------------------------------------------------------------------------------------------------------
# if the file already exists then delete it - use the $uploadPathWithName
my $timeStamp = $objDataBusinessLayer->getTimestamp($uploadPathWithName);
if(! defined($timeStamp)){
	$timeStamp = 0;
}

if($timeStamp eq ''){
	$timeStamp = 0;
}

if($timeStamp > 0){
	my @arrForDelete = $objDataBusinessLayer->getFile($uploadPathWithName);
	my $localPath = $objConfig->cmsPath()  . $arrForDelete [0];
	if( -e $localPath ){   
		unlink($localPath ,$localPath);
	}else{
		print "error - timestamp is positive but file does not exist: " . $timeStamp;
	};
}

# --------------------------------------------------------------------------------------------------------------------------
# convert from base 64 to binary

$fileBinaryContent = decode_base64($fileContent) ;

# save the file
if (! open WF, ">$localPath"){   print "error upload"; }
binmode WF;
print WF $fileBinaryContent; 
close WF;

# --------------------------------------------------------------------------------------------------------------------------

# if we arrived here we can register the file
$objDataBusinessLayer->registerCmsUpload ($mimeType, $uploadPathWithName , $localPathFragmentWithName, $timestamp );

# --------------------------------------------------------------------------------------------------------------------------
# print ok if upload successful
print "\n" . $uploadPathWithName;
print "OK-uploadsuccessful";

# =======================================================================================

exit 0;