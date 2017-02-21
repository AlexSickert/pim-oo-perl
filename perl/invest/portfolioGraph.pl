#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use LWP::Simple;

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
}else{
	# print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; 
}

# ======================= PARAMETERS ==================================================
my $v_u = param("v_u");
my $v_s = param("v_s");
# ======================= OBJECTS =======================================================
my $objConfig = PageConfig->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objNavigation = Navigation->new();
my $page = Page->new();
# =======================================================================================

$page->setTitle($objConfig->get("page-title"));
$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'data.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');

if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
	$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"invest")  );
	$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
	$page->addPositionContainerAbsoluteOnWindowResize("navigation", "TOP", "LEFT", 5, 5, 5,1);

	$page->addContainer('content','navigation',"a graph that contains 3 lines - 3 tables with div tags with different height...  to show cash in cash out and total value and performance." );
	$page->positionContainerAbsolut("content", "TOP", "LEFT", 250, 250, 250,250);
	$page->addPositionContainerAbsoluteOnWindowResize("content", "TOP", "LEFT", 250, 250, 250,250);

	$page->setEncoding('xhtml');
	$page->initialize;
	$page->display;
# =======================================================================================
}else{

}


# =======================================================================================

# ---------------------- Endo of CODE ---------------------------------------------------------
0;

