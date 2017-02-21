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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';

if($@) { 
	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print "Error evaluating objects: $@"; 
}

# =======================================================================================
#print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; # for debugging
# print "debugging test - please delete";
# =======================================================================================
my @arr;
my @inner;
my $page = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = DataBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();
my @formValuesBeforeSave;
my $messages;
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];
my $v_year_short = (localtime())[5];
my $newId;
my $objForm;
my $form = "";
my $permissions = 0777;
my $data; # Lesepuffer
my $v_folder = param("v_folder");
my $updir = $objConfig->uploadPath();
my $updirVirtual = $objConfig->uploadVirtualPath();
my $dateiname_insert;
my @path_array;
my $a;
my $test = "ssssss";
my $searchStringLast;
my $row;
my $field;



# =======================================================================================
my $datei = param('datei');
my $dateiname = param('dateiname') ;
my $name = param("name");
my $email = param("email");
my $tel = param("tel");
my $v_u = param("v_u");
my $v_s = param("v_s");
my $v_search = param("v_search");
my $mode = param("mode") ;
my $comment = param("comment");
my $action = param("action");
my $mailclip = param("mailclip");
my $id = param("id");


if (! defined $dateiname){
	$dateiname = "";
}

if (! defined $id){
	$id = "";
}

if (! defined $mode){
	$mode = "";
}


# =======================================================================================
$page->setTitle($objConfig->get("page-title"));

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'data.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================

$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"admin")  );
$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
$page->addPositionContainerAbsoluteOnWindowResize("navigation", "TOP", "LEFT", 5, 5, 5,1);


# =======================================================================================


#$form .= $page->getHidden('action','list');
#$form .= $page->getHidden('mode','full');


$searchStringLast = $objAdminBusinessLayer->getParameter('data','filesystemcheck');

my $theDate;
open(DATE, "date|");
$theDate = <DATE>;
close(DATE);


open(PS_F, "df -k|");

$form = $theDate . ":<br /><br />";
$form .= "<table>";
while (<PS_F>) {
my ($one,$two,$three,$four,$five,$six) = split;
## do whatever I want with the variables here ...
	$form .= "<tr><td>" . $one . "</td><td>" .$two . "</td><td>" . $three . "</td><td>" . $four . "</td><td>" . $five . "</td><td>" . $six . "</td></tr>" ;

}
close(PS_F);
$form .= "</table>";






$form .= "<br /><br />" . $searchStringLast;

$objAdminBusinessLayer->setParameter('data','filesystemcheck',$form);

$form = "What we need also is a method to detect double entry files in the CMS - this can be checked via the file size<br /><br />" . $form;
$page->addContainer('fileSysStatDivId','fileSysStatDiv',$form);
$page->positionContainerAbsolut("fileSysStatDivId", "CENTER", "CENTER", 100, 100, 100,100);
$page->addPositionContainerAbsoluteOnWindowResize("fileSysStatDivId", "CENTER", "CENTER", 100, 100, 100,100);



# =======================================================================================
#now else part  of security check
}else{
	#$page->addContent(  'permission denied'  );
	$page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# =======================================================================================

#$page->addContainer('adiandupdateform','MainAreaList',  "Test: " . $test );
$page->setEncoding('xhtml');
$page->initialize;
$page->display;

sub myTrim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}


# =======================================================================================
exit 0;