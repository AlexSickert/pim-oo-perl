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



# =========================================================================================================================

# resultat von der letzten abfrage eintragen
$objDataBusinessLayer->registerResult($result, $id, $fromLanguage, $toLanguage);

# =========================================================================================================================
srand();
$methodOfSelection = int( rand(4) );

if($methodOfSelection ne '2'){

    # in 3 von 4 faellen werden die woerter hergenommen wie man nicht kann... 

    srand();
    $randomRecord = 1 + int( rand(9) );
    $recCount = 0;

    # getContentNotLearned ist eine funktion die nach lernerfolg sortiert die wörter liefert die man am wenigsten kann. 
    # es liefert also nicht die neuen wörter, sondern die die man nicht kann. 
    # @zeile = $objDataBusinessLayer->getContentNotLearned();
    @zeile = $objDataBusinessLayer->getContentNotLearnedFromStatistics();

    $info = $info  . "Ranking";
    
    $id = $zeile[0];
    $L1 = $zeile[1];
    $L2 = $zeile[2];     
    $maxRatio = $zeile[3];  
    
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

}else{

    # if we want to get random content
    # liefert tatsächlich eine rteines zufallsergebnis
    @zeile = $objDataBusinessLayer->getRandomContent();
    $info = $info  . "Random";
    
        $id = $zeile[0] . "";
        $L1 = $zeile[1] . "";
        $L2 = $zeile[4] . "";
        $L3 = $zeile[7] . "";
        $L4 = $zeile[10] . "";
        $L5 = $zeile[13] . "";
        $L6 = $zeile[16] . "";
        $L7 = $zeile[19] . "";
    
    $countLanguages = 0;
    
    if ($L1 ne ''){
        $languages[$countLanguages] = 'deutsch';
        $values[$countLanguages] = decodeValue($L1);
        $languageid[$countLanguages] = "1";        
        $countLanguages +=1;
    }
    
    if ($L2 ne ''){
        $languages[$countLanguages] = 'englisch';
        $values[$countLanguages] = decodeValue($L2);
        $languageid[$countLanguages] = "2"; 
        $countLanguages +=1;
    }
    
    if ($L3 ne ''){
        $languages[$countLanguages] = 'spanisch';
        $values[$countLanguages] = decodeValue($L3);
        $languageid[$countLanguages] = "3"; 
        $countLanguages +=1;
    }
    
    if ($L4 ne ''){
        $languages[$countLanguages] = 'franz&ouml;sisch';
        $values[$countLanguages] = decodeValue($L4);
        $languageid[$countLanguages] = "4"; 
        $countLanguages +=1;
    }
    
    if ($L5 ne ''){
        $languages[$countLanguages] = 'italienisch';
        $values[$countLanguages] = decodeValue($L5);
        $languageid[$countLanguages] = "5"; 
        $countLanguages +=1;
    }
    if ($L6 ne ''){
        $languages[$countLanguages] = 'portugiesisch';
        $values[$countLanguages] = decodeValue($L6);
        $languageid[$countLanguages] = "6"; 
        $countLanguages +=1;
    }
    
     if ($L7 ne ''){
        $languages[$countLanguages] = 'russisch';
        $values[$countLanguages] = decodeValue($L7);
        $languageid[$countLanguages] = "7"; 
        $countLanguages +=1;
    }
     
    # now we choose from the available combination by random one      
    srand(); 
    $fromLanguage = int( rand($countLanguages) );
    srand();
    $toLanguage = int( rand($countLanguages) );
    if($fromLanguage == $toLanguage){
        while($fromLanguage == $toLanguage){
            srand();
            $toLanguage = int( rand($countLanguages) );
        }
    }

}
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

my $elapsed = Time::HiRes::tv_interval( $start );
print "<!-- $elapsed -->\n";
exit 0