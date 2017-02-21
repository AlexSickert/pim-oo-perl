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
my $objPage = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();
my $objTable = Table->new();
# ==========================================================================================================================
# insert bei request

my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_id = param("v_id");
my $v_a = param("v_a");
my $L1 = param("L1");
my $L2 = param("L2");
my $L3 = param("L3");
my $L4 = param("L4");
my $L5 = param("L5");
my $L6 = param("L6");
my $L7 = param("L7");
my $sql_string = "";
my $sql_string_stat = "";
my @zeile = ();
my $sql = "";
my $db = ""; 

my $lCount = -1;
my $tl1 = 0;
my $tl2 = 0;

# eintragen wenn nicht leer
if ($L1 ne '' && $v_a eq 'save' && $v_id ne ''){
    
    $L1 = encodeValue($L1);
    $L2 = encodeValue($L2);
    $L3 = encodeValue($L3);
    $L4 = encodeValue($L4);
    $L5 = encodeValue($L5);
    $L6 = encodeValue($L6);
    $L7 = encodeValue($L7);

    $objDataBusinessLayer->updateVocById($v_id, $L1, $L2, $L3, $L4, $L5, $L6 , $L7);
  
}
# ================================================================================================================
# get content

    @zeile = $objDataBusinessLayer->getVocByID($v_id);
    
    $v_id = decodeValue($zeile[0]);
    $L1 = decodeValue($zeile[1]);
    $L2 = decodeValue($zeile[2]);
    $L3 = decodeValue($zeile[3]);
    $L4 = decodeValue($zeile[4]);
    $L5 = decodeValue($zeile[5]);
    $L6 = decodeValue($zeile[6]);
    $L7 = decodeValue($zeile[7]);

# ================================================================================================================


$objPage->setEncoding('xhtml');
$objPage->initialize();


$objPage->setTitle($objConfig->get("page-title"));

$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'language.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'language.js');


$objTable->addRow();

$objTable->addField('label','a','deutsch');
$objTable->addField('label','b',$objPage->getPopLink2('poplink','http://dict.leo.org/ende' , 'englisch'  )  );
$objTable->addField('label','c',$objPage->getPopLink2('poplink','http://dict.leo.org/frde' , 'spanisch'  )  );

$objTable->addRow();

$objTable->addField('vakabel_insert_td','',$objPage->getArea('L1','vokabel_insert_area',$L1 ));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L2','vokabel_insert_area',$L2 ));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L3','vokabel_insert_area',$L3 ));

$objTable->addRow();

$objTable->addField('label','d',$objPage->getPopLink2('poplink','http://dict.leo.org/esde' , 'franz&ouml;isch'  )  );
$objTable->addField('label','e','italienisch');
$objTable->addField('label','f','portugiesisch');

$objTable->addRow();

$objTable->addField('vakabel_insert_td','',$objPage->getArea('L4','vokabel_insert_area',$L4 ));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L5','vokabel_insert_area',$L5 ));
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L6','vokabel_insert_area',$L6 ));

$objTable->addRow();
$objTable->addField('label','d',$objPage->getPopLink2('poplink','http://dict.leo.org/rude' , 'russiisch'  )  );

$objTable->addRow();
$objTable->addField('vakabel_insert_td','',$objPage->getArea('L7','vokabel_insert_area',$L7 ));

$objTable->addRow();

$objTable->addField('vakabel_insert_td','', $objPage->getHidden('v_a', 'save'). $objPage->getHidden('v_id', $v_id). $objPage->getHidden('v_u', $v_u). $objPage->getHidden('v_s', $v_s). $objPage->getSubmit('L1','Save','Save') . $objPage->getButton('Close','Close','Close','window.close();'));

$objPage->addContent(  $objPage->getForm('this_form','form_class','./edit.pl',$objTable->getTable())  );

#$objPage->addContent(data_connectionstring());

# ====== ab hier darf kein content mehr agefgt werden ==================================
#$objPage->addContent(  $sql_string_stat );
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