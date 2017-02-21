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
# Parameters
my $v_u = param("v_u");
my $v_s = param("v_s");

# ==========================================================================================================================
# Variables

my @arr;


# ==========================================================================================================================
# Objects

my $grid = Grid->new();
my $page = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = LanguageBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();


# ==========================================================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# ==========================================================================================================================

$page->setEncoding('xhtml');
$page->initialize();
$page->setTitle($objConfig->get("page-title"));
$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'language.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
$page->addJavaScript($objConfig->jsPath() . 'language.js');
$page->addJavaScript($objConfig->jsPath() . 'OrganizerCalendar.js');

$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"language")  );
$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

@arr = $objDataBusinessLayer->getStatisticsRatios();

$grid->setContent(@arr);

# add here another and better export of the file with a popup - use method of page object and then export table only

$grid->addHeader('ID');
$grid->addHeader('L1');
$grid->addHeader('L2');
$grid->addHeader('pos');
$grid->addHeader('neg');
$grid->addHeader('ratio');

$grid->addButton(0,'myclass',"showPop('./edit.pl?v_id=#id#')", 'edit');

#$grid->addGlobalReplacement('#v_u#', $v_u);
#$grid->addGlobalReplacement('#v_s#', $v_s);
$grid->addRecordReplacement('#id#', 0);
#$grid->addRecordReplacement('#switch#', 13);
$page->addContainer('adiandupdateform','MainAreaLanguageAll',  $grid->build );
$page->positionContainerAbsolut("adiandupdateform", "TOP", "CENTER", 10, 10, 100,10);
$page->display();
# ==========================================================================================================================
#now else part  of security check
}else{
   $page->jumpToPage("../admin/login.pl");
}
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

my $elapsed = Time::HiRes::tv_interval( $start );
print "<!-- $elapsed -->\n";
exit 0