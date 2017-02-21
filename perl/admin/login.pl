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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';


if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objConfig;

my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_year = (localtime())[5];
my $v_day_of_week = (localtime())[6];
my $timeString = "";

# ---------------------- CODE ---------------------------------------------------------

$objConfig = PageConfig->new();
$objForm = Form->new();
$objPage = Page->new();
$objPage->setTitle($objConfig->get("page-title"));
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'admin.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');

$objForm ->addPassword(1, 'v_u','f_input','v_u','');
$objForm ->addPassword(1, 'v_p','f_input','v_p','');
$objForm ->addPassword(1, 'v_x','f_input','v_x','');
$objForm ->addHidden('v_s','0');
$objForm ->addButton(1, 'savebutton','f_databutton','GO','document.myform.submit();');




$timeString .= "<br />hour : " . $v_hour ;
$timeString .= "<br />day: " . $v_day;
$timeString .= "<br />month : " . $v_month ;
$timeString .= "<br />second : " . $v_second ;
$timeString .= "<br />minute : " . $v_minute ;
$timeString .= "<br />year : " . $v_year ;
$timeString .= "<br />day_of_week: " . $v_day_of_week;

$objPage->addContainer('loginContainer','loginContainer', $objForm->getForm('index.pl') . $timeString);

#$objPage->addContainer('timeContainer','loginContainer', $timeString );

#$objPage->positionContainerPercentPos("loginContainer", 50, 50,0, 'center-center');

$objPage->positionContainerAbsolut("loginContainer", "CENTER", "CENTER", 70, 100, 100,10);
#$objPage->positionContainerAbsolut("timeContainer", "CENTER", "CENTER", 400, 100, 100,10);

$objPage->setEncoding('xhtml');
$objPage->setMaximised();
$objPage->initialize;
$objPage->display;





# ---------------------- Endo of CODE ---------------------------------------------------------



