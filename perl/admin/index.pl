#!/usr/bin/perl


use strict;
use CGI qw(:standard);
use warnings;


require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Utility.pm';
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
#print "debugging test";
# =======================================================================================

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
my $returnValue;
my $commandString;
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_year = (localtime())[5];
my $v_day_of_week = (localtime())[6];
   $v_year = $v_year +1900;
   $v_month = $v_month + 1;
my @modules;  
my $tmpPathString; 
my $dateiName;
# my $timeStamp = $v_year . "-" . $v_month . "-" . $v_day . "-" . $v_hour . "-" . $v_minute . "-" . $v_second;
my $timeStamp = $v_day_of_week ;

$objConfig = PageConfig->new();

# create backup if not logged on so far
$returnValue = "creating backup please wait...";

# ---------------------- CODE FOR PAGE LAYOUT ----------------------------------------------------

$objPage = Page->new();
$objNavigation = Navigation->new();
$objPage->setTitle($objConfig->get("page-title"));
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'admin.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'ajax.js');
$objPage->setBodyOnLoad("getMethodAnswerInId(\"./ajaxMakeBackup.pl\",pushAnswerInId,\"messages\");");
$objABL = AdminBusinessLayer->new();


# here we need a new login check with images.
# the images are located here: /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/images




if(($objABL->checkPassword($v_u, $v_p, $v_x) eq 1) || ($objABL->checkLogin($v_u, $v_s) eq 1) ){
    
    # wenn passowrd und time nicht null dann neue session
    if($v_p ne '' && $v_x ne ''){
        $v_s = $objABL->getNewSession($v_u)        
    }
    # if login successful then display menu 
    $objPage->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"admin")  );
    $objPage->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

    $objPage->addContainer('messages','navigation',$returnValue  );
    $objPage->positionContainerAbsolut("messages", "TOP", "LEFT", 100, 100, 100,10);


    # This is for Mail component. we reset the blocking that no parallel downloads of mails are possible. 
    $objABL->setParameter('mail','currentlyLoading','no');


}else{
    #login failed
    $objPage->jumpToPage("../admin/login.pl");
}

$objPage->setEncoding('xhtml');
$objPage->initialize;
$objPage->display;


# ---------------------- Endo of CODE ---------------------------------------------------------

    #my $util;
    #$util = Utility->new();
    #print $util->getRandomString(50);

exit 0;
