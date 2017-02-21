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

#=======================================================================================
my $page = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();

#=======================================================================================
my $v_u = param("v_u");
my $v_s = param("v_s");
my $location = param("location");
my $category = param("category");

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security

	$page->setGlobalVariables($v_s, $v_u);  
	$page->setTitle($objConfig->get("page-title"));
	$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
	$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
	$page->addStyleSheet($objConfig->cssPath() . 'data.css');
	$page->addStyleSheet($objConfig->cssPath() . 'mail.css');
	$page->addJavaScript($objConfig->jsPath() . 'classes.js');
	$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
	$page->addJavaScript($objConfig->jsPath() . 'data.js');
	$page->addJavaScript($objConfig->jsPath() . 'OrganizerCalendar.js');

	$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"org")  );
	$page->addContainer('folderDropDwon','mailAttachmentsDiv',''  );
	$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
	$page->addContainer('organizer','mailForm',  '<div style="width: 5000px;  height: 1000px"  >loading...</div>');
	$page->positionContainerAbsolut("organizer", "CENTER", "CENTER", 10, 10, 100,10);


	if($category eq 'day' || $category eq 'week' || $category eq 'month' || $category eq 'year'){
		if($category eq 'day'){
			$page->setBodyOnLoad("orgLoadCalendar(\"d\");");
		}
		if($category eq 'week'){
			$page->setBodyOnLoad("orgLoadCalendar(\"w\");");
		}
		if($category eq 'month'){
			$page->setBodyOnLoad("orgLoadCalendar(\"m\");");
		}
		if($category eq 'year'){
			$page->setBodyOnLoad("orgLoadCalendar(\"y\");");
		}
	}else{
		$page->setBodyOnLoad("dataAjaxLoadOrganizer(\"./ajaxOrg.pl?\",\"organizer\",\"" . $category . "\",0\,\"all\");");
	}



# =======================================================================================
#now else part  of security check
}else{
		$page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# =======================================================================================

$page->setEncoding('xhtml');
$page->initialize;

$page->display;

exit 0
