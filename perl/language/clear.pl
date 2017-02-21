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

# ==========================================================================================================================

my $objPage = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();


my $v_s  = param("v_s");
my $v_u  = param("v_u");

# ==========================================================================================================================

# delete dable contents
my $objDAL = DataAccessLayer->new();
$objDAL->setModul('data');
$objDAL->executeSQL("DELETE FROM dictionary_tracker");
$objDAL->executeSQL("DELETE FROM dictionary");
$objDAL->executeSQL("DELETE FROM dictionary_statistics");

#create page
$objPage->setEncoding('xhtml');
$objPage->initialize();
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'language.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'language.js');
$objPage ->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"language")  );
$objPage ->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
$objPage->addContent( $objPage->getContainer('centeredContainer', 'language_positioner',  "done")  ) ;
$objPage->positionContainerAbsolut("centeredContainer", "CENTER", "CENTER", 100, 100, 100,100);
$objPage->display();


exit 0