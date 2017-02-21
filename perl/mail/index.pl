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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';


if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}

#rint "Content-type: text/html;Charset=iso-8859-1". "\n\n";
#print "test in index.pl";

# =======================================================================================
my @arr;
my @inner;
my $test;
my $page = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = DataBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();

my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5] + 1900;
my $random;

my $timestamp = $v_year . "-" . $v_month . "-" . $v_day . "-" . $v_hour . "-" . $v_minute . "-" . $v_second ;
# =======================================================================================
# ToDo
# - mail needs button to load mails
# - body needs on load event that triggers getMails the first time
# - getMails triggers also ajax getNewMails()
# - timout loop to trigger getNewMails()
# - siehe artiekl append-child-dom-javascript.pdf
#
#
#
# =======================================================================================

my $v_u = param("v_u");
my $v_s = param("v_s");

# =======================================================================================
$page->setTitle($objConfig->get("page-title"));

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'mail.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
$page->addJavaScript($objConfig->jsPath() . 'mail.js');
$page->addJavaScript($objConfig->jsPath() . 'OrganizerCalendar.js');


# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

   $page->setGlobalVariables($v_s, $v_u);   
   $page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"mail")  );
   $page->addContainer('folderDropDwon','mailAttachmentsDiv',''  );
   $page->addContainer('orgAction','mailAttachmentsDiv',''  );
   $page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
   $page->addContainer('mailFormId','mailForm',  '');
   #$page->positionContainerAbsolut("mailFormId", "TOP", "LEFT", 10, 10, 100,10);
   $page->positionContainerAbsolut("mailFormId", "CENTER", "CENTER", 10, 10, 100,10);

   $page->setBodyOnLoad("getMailsOnLoad(\"./ajaxLoadExistingMail.pl?category=unread&\", \"./ajaxLoadExistingMail.pl?category=read\", \"./ajaxLoadMail.pl\", \"mailFormId\");");

# =======================================================================================
#now else part  of security check
}else{
   #$page->addContent(  'permission denied'  );
   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# =======================================================================================

$page->setEncoding('xhtml');
$page->initialize;

$page->display;

my $elapsed = Time::HiRes::tv_interval( $start );
print "<!-- $elapsed -->\n";

exit 0