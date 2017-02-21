#!/usr/bin/perl


use strict;
use CGI qw(:standard);
use warnings;


require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';





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

#=======================================================================================

my @formValuesBeforeSave;
my $action = param("action");
my $id = param("id");
my $messages;

my $v_u = param("v_u");
my $v_s = param("v_s");

my $comment = param("comment");
my $title = param("title");
my $urgent = param("urgent");
my $important = param("important");
my $category = param("category");



# =======================================================================================

if (! defined($action)){ $comment = "";};
if (! defined($comment)){ $comment = "";};
if (! defined($title)){ $title = "";};
if (! defined($urgent)){ $urgent = "";};
if (! defined($important)){ $important = "";};
if (! defined($category)){ $category = "";};


# ===================================================

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');


$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"data")  );

$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);


$page->setEncoding('xhtml');
$page->initialize;
$page->display;


#----------------------------------------------------------------------------------------------------------------------
print "<br><br><br><br><br><br>\n";


my $iii = 1;
my $yClean = 0;
foreach (@INC) {
    print ++$iii,". Pfad: $_<br>\n";
}

foreach (%INC) {
    print ++$iii,". Pfad: $_<br>\n";
}
#----------------------------------------------------------------------------------------------------------------------




exit 0
