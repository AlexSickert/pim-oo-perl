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

   #print "Content-type: text/html;Charset=utf-8". "\n\n";

# ==========================================================================================================================

my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();


# ==========================================================================================================================
# insert bei request
my $v_s = param("v_s");
my $v_u = param("v_u");
my $words = param("words");

my $sql_string = "";

my $sql_string_stat = "";
my @languages = ();
my @languages2 = ();
my @zeile = ();
my $lCount = -1;
my $tl1 = 0;
my $tl2 = 0;
my $v_id;

my @rows = ();
my @words = ();
my $y;
my $x;
my $row;
my $ret;
my $objPage = Page->new();
$objPage->setEncoding('xhtml');
$objPage->initialize();
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'language.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'language.js');


# eintragen wenn nicht leer
if ($words ne ''){
    
	# remove carriage returns

	$words  =~ s/\n//g;
	$words  =~ s/\r//g;
	$words  =~ s/'/&apos;/g;
	# nest line to prevent shift of words
	$words  =~ s/\|\|/\|-\|/g;

	@rows = split(/#/, $words);
	for $y (0.. $#rows ){
		$row = $rows[$y];
		if(defined($row)){
			if ($row ne ''){
				@words = split(/\|/, $row);
				for $x (0.. $#words){
					if(defined($words[$x])){
						if($words[$x] ne ''){
							if($words[$x] eq '-'){
								$words[$x] = "";
							}
							$ret = $ret . $x . " = " . $words[$x] . "<br>";
						}
					}
				}

				# german word must always be set. 
				if(defined($words[0])){
					if($words[0] ne ''){
						$objDataBusinessLayer ->insertVoc($words[0], $words[1], $words[2], $words[3], $words[4], $words[5], $words[6]);
					}
				}

				$ret = $ret . "-------------------------------------------------------------------" . "<br>";
			}
		}
	}

#    
 

	$objPage ->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"language")  );
	$objPage ->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
	$objPage->addContent( $objPage->getContainer('centeredContainer', 'language_positioner',  $ret)  ) ;
	$objPage->positionContainerAbsolut("centeredContainer", "CENTER", "CENTER", 100, 100, 100,100);
}else{

	my $objTable = Table->new();
	$objPage->setEncoding('xhtml');
	$objPage->initialize();
	$objPage ->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"language")  );
	$objPage ->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
	  
	$objPage->setTitle($objConfig->get("page-title"));

	$objTable->addRow();
	$objTable->addField('label','a','Vocs - columns as DE,EN,ES, FR, IT, PT, RU. Separated by | and at end of row with #');
	$objTable->addRow();
	$objTable->addField('vakabel_insert_td','',$objPage->getArea('words','vokabel_insert_area_bulk',''));
	$objTable->addRow();
	$objTable->addRow();
	$objTable->addField('vakabel_insert_td','', $objPage->getHidden('v_u', $v_u). $objPage->getHidden('v_s', $v_s). $objPage->getSubmit('L1','Save','Save') );
	$objPage->addContent( $objPage->getContainer('centeredContainer', 'language_positioner',  $objPage->getForm('this_form','form_class','./insertBulk.pl',$objTable->getTable())  )  ) ;
	$objPage->positionContainerAbsolut("centeredContainer", "CENTER", "CENTER", 100, 100, 100,100);
}

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