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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';

if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}else{
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   #print "hallo";
}

#   http://www.alex-admin.net/alex-admin/dev/perl/language/insertSync.pl?id=&L1=LLL1X&L2=LLL2&L3=LLL3&L4=LLL4&L5=LLL5&L6=LLL6

# ==========================================================================================================================

my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();


# ==========================================================================================================================
# insert bei request

my $sql_string = "";
my $sql_string_stat = "";
my @languages = ();
my @languages2 = ();
my @zeile = ();
my @arr = ();
my $lCount = -1;
my $tl1 = 0;
my $tl2 = 0;
my $returnId;
my $supplement;
   $supplement = "";

my $L1 = param("L1");
my $L2 = param("L2");
my $L3 = param("L3");
my $L4 = param("L4");
my $L5 = param("L5");
my $L6 = param("L6");
my $L7 = param("L7");
my $id = param("id");

$L1 = myDecode($L1);
$L2 = myDecode($L2);
$L3 = myDecode($L3);
$L4 = myDecode($L4);
$L5 = myDecode($L5);
$L6 = myDecode($L6);
$L7 = myDecode($L7);




if($L1 ne ''){$lCount += 1; $languages[$lCount] = 1; $languages2[$lCount] = 1;};
if($L2 ne ''){$lCount += 1; $languages[$lCount] = 2; $languages2[$lCount] = 2;};
if($L3 ne ''){$lCount += 1; $languages[$lCount] = 3; $languages2[$lCount] = 3;};
if($L4 ne ''){$lCount += 1; $languages[$lCount] = 4; $languages2[$lCount] = 4;};
if($L5 ne ''){$lCount += 1; $languages[$lCount] = 5; $languages2[$lCount] = 5;};
if($L6 ne ''){$lCount += 1; $languages[$lCount] = 6; $languages2[$lCount] = 6;};
if($L7 ne ''){$lCount += 1; $languages[$lCount] = 7; $languages2[$lCount] = 7;};



# eintragen wenn nicht leer
if ($L1 ne ''){

    $L1 = encodeValue($L1);
    $L2 = encodeValue($L2);
    $L3 = encodeValue($L3);
    $L4 = encodeValue($L4);
    $L5 = encodeValue($L5);
    $L6 = encodeValue($L6);
    $L7 = encodeValue($L7);

   if ($id eq ''){
	   # insert
	    $objDataBusinessLayer->insertVoc($L1, $L2, $L3, $L4, $L5, $L6, $L7);
	    #sleep(3);
	    #get id of inserted value
	    @arr = $objDataBusinessLayer->getVocIdByContent($L1, $L2, $L3, $L4, $L5, $L6, $L7);
	   $returnId = $arr[0];
	   $supplement .= decodeValue($arr[1]) . "|";
	   $supplement .= decodeValue($arr[2]) . "|";
	   $supplement .= decodeValue($arr[3]) . "|";
	   $supplement .= decodeValue($arr[4]) . "|";
	   $supplement .= decodeValue($arr[5]) . "|";
	   $supplement .= decodeValue($arr[6]) . "|";
	   $supplement .= decodeValue($arr[7]) . "|";

   }else{

  	 # update no insert
	   $objDataBusinessLayer->updateVocById($id, $L1, $L2, $L3, $L4, $L5, $L6, $L7 );
	   $returnId = $id;
	   @arr = $objDataBusinessLayer->getVocByID($id);
	   $supplement .= decodeValue($arr[1]) . "|";
	   $supplement .= decodeValue($arr[2]) . "|";
	   $supplement .= decodeValue($arr[3]) . "|";
	   $supplement .= decodeValue($arr[4]) . "|";
	   $supplement .= decodeValue($arr[5]) . "|";
	   $supplement .= decodeValue($arr[6]) . "|";
	   $supplement .= decodeValue($arr[7]) . "|";
   }

  
}else{
   $returnId = ""
}

# ==========================================================================================================================

#craete result of page

   print "id|" . $returnId . "|" .   $supplement; 


# ==========================================================================================================================

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


sub myDecode{

    my $codestring = "";    
    $codestring = $_[0];
    $codestring =~ s/_comma_/,/g;
    $codestring =~ s/_eq_/=,/g;
    $codestring =~ s/_p_/\./g;
    $codestring =~ s/_void_/ /g;
    $codestring =~ s/_ques_/\?/g;
    $codestring =~ s/_excl_/\!/g;
    $codestring =~ s/_auml_/ä/g;
    $codestring =~ s/_Auml_/Ä/g;
    $codestring =~ s/_uuml_/ü/g;
    $codestring =~ s/_Uuml_/Ü/g;
    $codestring =~ s/_ouml_/ö/g;
    $codestring =~ s/_Öuml_/Ö/g;
    $codestring =~ s/_sz_/ß/g;
    $codestring =~ s/_dash_/-/g;
    $codestring =~ s/_opbrac_/(/g;
    $codestring =~ s/_clbrac_/)/g;


    return $codestring;    
}


exit 0