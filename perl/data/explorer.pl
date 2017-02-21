#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;



eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm`;



if($@) { 
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
   print "Error evaluating objects: $@"; 
}


#=======================================================================================
my $page = Page->new();
my $objForm;
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = DataBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();
my $objTable = Table->new();
my $db;
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];
my $a;
my $linkString;
$v_year = $v_year + 1900;
$v_month = $v_month + 1;

#=======================================================================================
my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_action = param("v_action") ;
my $v_id = param("v_id");
my $v_parent_id =  param("v_parent_id");
my $v_description =  param("v_description");
my $v_list_ids =  param("v_list_ids");
my $v_p_id =  param("v_p_id");


#=======================================================================================

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
$page->addJavaScript($objConfig->jsPath() . 'data.js');
$page->addJavaScript($objConfig->jsPath() . 'OrganizerCalendar.js');



# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){


    $objTable->addRow();
    $objTable->addField('xxx','yyy',$page->getContainer('explorerTree','aaa',  'here is the tree construct'));
    $objTable->addField('xxx','yyy',$page->getContainer('contantArea','bbb',  'here is the content'));
    
    $page->addContainer('contentDiv','MainAreaList', $objTable->getTable());
    $page->positionContainerAbsolut("contentDiv", "TOP", "LEFT", 10, 10, 100,10);
    $page->setBodyOnLoad("dataAjaxLoadExplorer(\"./ajaxExplorer.pl?parent=0&div_id=explorerTree&v_u=" . $v_u . "&v_s=".$v_s."\", \"explorerTree\");");
    $page->setGlobalVariables($v_s, $v_u);  

#=======================================================================================
#now else part  of security check
}else{
   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
#=======================================================================================

# add navigation
$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"data")  );
$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0
