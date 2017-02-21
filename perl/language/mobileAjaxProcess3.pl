#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;

use Time::HiRes;
my $start = [ Time::HiRes::gettimeofday( ) ];

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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

print "Content-type: text/html;Charset=utf-8". "\n\n";

# ==========================================================================================================================

my $objPage = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();
my $info = "";

# ==========================================================================================================================

# insert bei request

my $L1 ;
my $L2 ;
my $L3 ;
my $L4 ;
my $L5 ;
my $L6 ;
my $L7 ;
my $tableAndForm ;
my $sql_string = "";
my @zeile = ();
my @statistics;
my @statisticsTwo;
my @languages = ();
my @languageid = ();
my @values = ();
my $countLanguages = 0;
my $fromLanguage = param("fromLanguage");
my $toLanguage = param("toLanguage");
my $result = param("result");
my $language = param("language");
my $id  = param("id");
my $counter;
my $db;
my $sql;
my $randomRecord;
my $recCount;
my $maxRatio;
my $methodOfSelection;
my $timeNowSec;
my $lastAccessTime;
my $elapsedSec;
my $totalTimeSec;
my $totalTimeHours;



# =========================================================================================================================

# resultat von der letzten abfrage eintragen
$objDataBusinessLayer->registerResult($result, $id, $fromLanguage, $toLanguage);

# =========================================================================================================================

# load next word

@zeile = $objDataBusinessLayer->getNextWordFromCategories($id);   # what is missing here is the right ID to prevent we load the same word again
@statistics = $objDataBusinessLayer->getCategoryStatistics();
@statisticsTwo = $objDataBusinessLayer->getCategoryStatisticsTwo();

$timeNowSec = time();
$lastAccessTime = $objAdminBusinessLayer->getParameter('language','lastAccess');

if($lastAccessTime eq ''){
	$lastAccessTime = $timeNowSec;
}

$elapsedSec = $timeNowSec - $lastAccessTime;

# $objAdminBusinessLayer->setParameter('language','lastAccess','');
$objAdminBusinessLayer->setParameter('language','lastAccess',$timeNowSec);

if($elapsedSec <= 60){

	
	$totalTimeSec = $objAdminBusinessLayer->getParameter('language','totalTimeSeconds');
	if($totalTimeSec eq ''){
		$totalTimeSec = 0;
	}

	$totalTimeSec = $totalTimeSec + $elapsedSec;
	$objAdminBusinessLayer->setParameter('language','totalTimeSeconds', $totalTimeSec);

}

$totalTimeSec = $objAdminBusinessLayer->getParameter('language','totalTimeSeconds');
# $objAdminBusinessLayer->setParameter('language','totalTimeHours', 0);
$totalTimeHours = sprintf("%.2f", $totalTimeSec / 3600);


$info = "Cat: " . $zeile[7] . " P: " . $zeile[5] . " N: " . $zeile[6] . " R: " . $zeile[4] . " H: " . $zeile[8] . " H: " . $zeile[9];
$info .= " C" . $statistics[0][0] . ": " . $statistics[0][1] . " / ";
$info .= " C" . $statistics[1][0] . ": " . $statistics[1][1] . " / ";
$info .= " C" . $statistics[2][0] . ": " . $statistics[2][1] . " / ";
$info .= " C" . $statistics[3][0] . ": " . $statistics[3][1] . " / ";
$info .= " TS " . $totalTimeSec  . " / ";
$info .= " TH " . $totalTimeHours  . " / ";
$info .= " Count: " . $statisticsTwo[0][0] ;

$id = $zeile[0];
$L1 = $zeile[1];
$L2 = $zeile[2];     

$fromLanguage = substr($L1,1) - 1;
$toLanguage = substr($L2,1) - 1;

@zeile = $objDataBusinessLayer->getOneWord($L1 , $L2 , $id);

$values[$fromLanguage] = decodeValue($zeile[0]);
$values[$toLanguage] = decodeValue($zeile[1]);

$languages[0] = "deutsch";
$languages[1] = "englisch";
$languages[2] = "spanisch";
$languages[3] = "franz&ouml;sisch";
$languages[4] = "italienisch";
$languages[5] = "portugiesisch";
$languages[6] = "russisch";

$languageid[0] = "1"; 
$languageid[1] = "2"; 
$languageid[2] = "3"; 
$languageid[3] = "4"; 
$languageid[4] = "5"; 
$languageid[5] = "6"; 
$languageid[6] = "7"; 

# ==========================================================================================================================
my $delimiter  = "<x>";
print $id;
print $delimiter; 
print $languages[$fromLanguage];
print $delimiter; 
print $languageid[$fromLanguage];
print $delimiter; 
print $values[$fromLanguage];
print $delimiter; 
print $languages[$toLanguage];
print $delimiter; 
print $languageid[$toLanguage];
print $delimiter; 
print $values[$toLanguage];
print $delimiter; 

print $result . "<br>";
print $id. "<br>";
print $fromLanguage. "<br>";
print $toLanguage. "<br>";
print $delimiter; 
print $info;
# =========================================================

sub encodeValue{    
    my $codestring = "";    
    $codestring = $_[0];
    $codestring =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
    return $codestring; 
}

sub decodeValue{    
    my $codestring = "";    
    $codestring = $_[0];
    $codestring =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    return $codestring;      
}

#my $elapsed = Time::HiRes::tv_interval( $start );
#print "<!-- $elapsed -->\n";
exit 0