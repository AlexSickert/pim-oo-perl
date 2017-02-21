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
}



# ==========================================================================================================================

my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();


# ==========================================================================================================================
# insert bei request
my $v_s = param("v_s");
my $v_u = param("v_u");
my $L1 = param("L1");
my $L2 = param("L2");
my $L3 = param("L3");
my $L4 = param("L4");
my $L5 = param("L5");
my $L6 = param("L6");
my $L7 = param("L7");
my $sql_string = "";

my $sql_string_stat = "";
my @languages = ();
my @languages2 = ();
my @zeile = ();
my $lCount = -1;
my $tl1 = 0;
my $tl2 = 0;
my $v_id;

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

    $objDataBusinessLayer ->insertVoc($L1, $L2, $L3, $L4, $L5, $L6, $L7);
  
}
# ==========================================================================================================================
my $objPage = Page->new();
my $objTable = Table->new();

$objPage->setEncoding('xhtml');
$objPage->initialize();

$objPage ->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"language")  );
$objPage ->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
  
$objPage->setTitle($objConfig->get("page-title"));

$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'language.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'language.js');

#$objPage->addContent( modulHeader($v_u,$v_s,'language') );
#$objPage->addContent( languageHeader($v_u,$v_s) );

$objTable->addRow();

$objTable->addField('label','a','deutsch');
$objTable->addField('label','b',$objPage->getPopLink('poplink','http://dict.leo.org/ende' , 'englisch'  )  );
$objTable->addField('label','c',$objPage->getPopLink('poplink','http://dict.leo.org/frde' , 'franz&ouml;isch'  )  );
$objTable->addRow();

$objTable->addField('vakabel_insert_td','',$objPage->getArea('L1','vokabel_insert_area',''));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L2','vokabel_insert_area',''));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L3','vokabel_insert_area',''));
$objTable->addRow();

$objTable->addField('label','d',$objPage->getPopLink('poplink','http://dict.leo.org/esde' , 'spanisch'  )  );
$objTable->addField('label','e','italienisch');
$objTable->addField('label','f','portugiesisch');

$objTable->addRow();

$objTable->addField('vakabel_insert_td','',$objPage->getArea('L4','vokabel_insert_area',''));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L5','vokabel_insert_area',''));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L6','vokabel_insert_area',''));


$objTable->addRow();
$objTable->addField('label','g','russisch');
$objTable->addRow();
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L7','vokabel_insert_area',''));

$objTable->addRow();

$objTable->addField('vakabel_insert_td','', $objPage->getHidden('v_u', $v_u). $objPage->getHidden('v_s', $v_s). $objPage->getSubmit('L1','Save','Save') );

#$objPage->addContent( );

#$objPage->addContent('Й&nbsp;&nbsp;&nbsp;Г&nbsp;&nbsp;&nbsp;Ц&nbsp;&nbsp;&nbsp;У&nbsp;&nbsp;&nbsp;©&nbsp;&nbsp;&nbsp;й&nbsp;&nbsp;&nbsp;б&nbsp;&nbsp;&nbsp;Ш&nbsp;&nbsp;&nbsp;дк├&nbsp;&nbsp;&nbsp;ц&nbsp;&nbsp;&nbsp;г&nbsp;&nbsp;&nbsp;Ф&nbsp;&nbsp;&nbsp;о
#');

$objPage->addContent( $objPage->getContainer('centeredContainer', 'language_positioner',  $objPage->getForm('this_form','form_class','./insert.pl',$objTable->getTable())  )  ) ;

$objPage->positionContainerAbsolut("centeredContainer", "CENTER", "CENTER", 100, 100, 100,100);


# ====== ab hier darf kein content mehr agefgt werden ==================================
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
exit 0