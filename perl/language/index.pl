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

#   print "Content-type: text/html;Charset=utf-8". "\n\n";

# ==========================================================================================================================

my $objPage = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();

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
my $v_s  = param("v_s");
my $v_u  = param("v_u");
my $id  = param("id");
my $counter;
my $db;
my $sql;
my $randomRecord;
my $recCount;
my $maxRatio;
my $methodOfSelection;
my $stat;



# =========================================================================================================================

$objPage ->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"language")  );
$objPage ->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
  
# resultat von der letzten abfrage eintragen

#print $result . "<br>";
#print $id. "<br>";
#print $fromLanguage. "<br>";
#print $toLanguage. "<br>";

$objDataBusinessLayer->registerResult($result, $id, $fromLanguage, $toLanguage);


# =========================================================================================================================
srand();
$methodOfSelection = int( rand(10) );

if($methodOfSelection eq '2'  || $methodOfSelection eq '3' || $methodOfSelection eq '4'){

    # getContentNotLearnedFromRatio - word with ratio 1 or more

    srand();
    $randomRecord = 1 + int( rand(9) );
    $recCount = 0;

    @zeile = $objDataBusinessLayer->getContentNotLearnedFromRatio();

    
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



}elsif ($methodOfSelection eq '5'  || $methodOfSelection eq '8' ){
# random content


    # if we want to get random content
    # liefert tatsächlich eine rteines zufallsergebnis
    @zeile = $objDataBusinessLayer->getRandomContent();
    
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

}else{   # in all other cases we use the word with lowest sucess ratio

    #  getContentNotLearnedFromStatistics - word with lowest sucess ratio
    # die woerter hergenommen wie man nicht kann... 

    srand();
    $randomRecord = 1 + int( rand(6) );
    $recCount = 0;

    # getContentNotLearned ist eine funktion die nach lernerfolg sortiert die wörter liefert die man am wenigsten kann. 
    # es liefert also nicht die neuen wörter, sondern die die man nicht kann. 
    # @zeile = $objDataBusinessLayer->getContentNotLearned();

    if($id eq ''){
        @zeile = $objDataBusinessLayer->getContentNotLearnedFromStatistics(0);
    }else{
        @zeile = $objDataBusinessLayer->getContentNotLearnedFromStatistics($id);
    }


    
    $id = $zeile[0];
    $L1 = $zeile[1];
    $L2 = $zeile[2];     
    $maxRatio = $zeile[3];  
    $stat = "..."; 
    # $stat = "rat: " . $zeile[3] . " pos: " . $zeile[4] . " neg: " . $zeile[5] ; 
    $stat = " pos: " . $zeile[5] . " neg: " . $zeile[6] ; 
    
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

}

# ==========================================================================================================================

my $objTable = Table->new();

$objPage->setEncoding('xhtml');
$objPage->initialize();


$objPage->setTitle($objConfig->get("page-title"));

$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'language.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'language.js');


#$objPage->addContent( modulHeader($v_u,$v_s,'language') );
#$objPage->addContent( languageHeader($v_u,$v_s) );

$objTable->addRow();

$objTable->addField('xxx','vokabel_label','&nbsp;');
$objTable->addField('xxx','vokabel_label',$languages[$fromLanguage]);
$objTable->addField('xxx','vokabel_label',$values[$fromLanguage]);

$objTable->addRow();

$objTable->addField('id-of-field','vakabel_label',$objPage->getPopLink('vokabel_label','./edit.pl?v_id='.$id,'?') );
$objTable->addField('xxx','vokabel_label',$languages[$toLanguage]);
$objTable->addField('xxx','vokabel_label', $objPage->getContainer('vokabel','hiddenVoc',$values[$toLanguage]) );

$objTable->addRow();

$objTable->addField('id-of-field','vokabel_label',$objPage->getButton('OK','vokabel_button','OK','sendOk()'));
$objTable->addField('id-of-field','vokabel_label',$objPage->getButton('Answer','vokabel_button','? ? ?','showHide(\'vokabel\')'));
$objTable->addField('id-of-field','vokabel_label',$objPage->getButton('NO','vokabel_button','NO','sendNo()'));

if($methodOfSelection eq '2'  || $methodOfSelection eq '3' || $methodOfSelection eq '4'){
    $objTable->addRow();
    $objTable->addField('','',"word ratio is 1 " . $objDataBusinessLayer->getVersion() );
    $objTable->addField('','',"&nbsp;"  );
    $objTable->addField('','',"&nbsp;"  );
}elsif($methodOfSelection eq '5'){
    $objTable->addRow();
    $objTable->addField('','',"new random content " . $objDataBusinessLayer->getVersion()  );
    $objTable->addField('','',"&nbsp;"  );
    $objTable->addField('','',"&nbsp;"  );
}else{
    $objTable->addRow();
    # $objTable->addField('','',"not good " . $objDataBusinessLayer->getVersion()  . " - " . $stat);
    $objTable->addField('','',"LR " . " - " . $stat);
    $objTable->addField('','',"&nbsp;"  );
    $objTable->addField('','',"&nbsp;"  );
}

$tableAndForm = "";
$tableAndForm .=  $objPage->getHidden('v_s',$v_s);
$tableAndForm .=  $objPage->getHidden('v_u',$v_u);
$tableAndForm .=  $objPage->getHidden('id',$id);
$tableAndForm .=  $objPage->getHidden('toLanguage',$languageid[$toLanguage]);
$tableAndForm .=  $objPage->getHidden('fromLanguage',$languageid[$fromLanguage]);
$tableAndForm .=  $objPage->getHidden('result','');

$tableAndForm .=  $objTable->getTable();

$objPage->addContent(  $objPage->getForm('this_form','form_class','./index.pl', $objPage->getContainer('centeredContainer', 'language_positioner', $tableAndForm)   ));

$objPage->positionContainerAbsolut("centeredContainer", "CENTER", "CENTER", 10, 10, 50,10);

$objPage->setBodyOnLoad('langEnableKey();');
# ====== ab hier darf kein content mehr agefügt werden ==================================
$objPage->display();
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

my $elapsed = Time::HiRes::tv_interval( $start );
print "<!-- $elapsed -->\n";
exit 0