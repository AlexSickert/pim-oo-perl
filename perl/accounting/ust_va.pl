#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use DBI;


#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!
#        this page is not used yet !!!!!



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
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AccountingBusinessLayer.pm';



# ---------------------- REQUEST VARIABLES --------------------------------------------------
my $params = CGI->new();
my $v_p = $params->param("v_p");
my $v_s = $params->param("v_s");
my $v_u = $params->param("v_u");
my $v_x = $params->param("v_x");
# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objNavigation;
my $objConfig;
my $objABL;

# ---------------------- INITIALIZE OBJECTS  ----------------------------------------------------


$objConfig = PageConfig->new();


# ---------------------- CODE FOR PAGE LAYOUT ----------------------------------------------------

$objPage = Page->new();
$objNavigation = Navigation->new();
$objPage->setTitle($objConfig->get("page-title"));
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'admin.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');

$objABL = AdminBusinessLayer->new();

if(($objABL->checkPassword($v_u, $v_p, $v_x) eq 1) || ($objABL->checkLogin($v_u, $v_s) eq 1) ){
    
    # wenn passowrd und time nicht null dann neue session
    if($v_p ne '' && $v_x ne ''){
        $v_s = $objABL->getNewSession($v_u)        
    }
    # if login successful then display menu 
    $objPage->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"accounting")  );
    $objPage->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

    $objPage->addContainer('messages','navigation','display ust va - this page is not used yes !!!!!');
    $objPage->positionContainerAbsolut("messages", "TOP", "CENTER", 100, 100, 100,10);

}else{
    #login failed
    $objPage->jumpToPage("../admin/login.pl");
}

$objPage->setEncoding('xhtml');
$objPage->initialize;
$objPage->display;

# ---------------------- Endo of CODE ---------------------------------------------------------


