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
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm`;

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
my $v_s = $params->param("v_s");
my $v_u = $params->param("v_u");
# ---------------------- VARIABLES  ---------------------------------------------------------

my $objABL;
my $objPage;
my $objConfig;

# ---------------------- CODE FOR PAGE LAYOUT ----------------------------------------------------

$objABL = AdminBusinessLayer->new();
$objPage = Page->new();
$objConfig = PageConfig->new();

$objPage->setTitle($objConfig->get("page-title"));
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'admin.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');
$objPage->addJavaScript($objConfig->jsPath() . 'ajax.js');



if( $objABL->checkLogin($v_u, $v_s) eq 1 ){
    
   $objABL->logout($v_u);
   # closing window
   $objPage->setBodyOnLoad("window.close()");

   #print "check login ok";

}else{
    #login failed
    #$objPage->jumpToPage("../admin/login.pl");

   #print "login failed";
}

$objPage->setEncoding('xhtml');
$objPage->initialize;
$objPage->display; 

#----------------------------------------------------------------------------------------------------------------------
my $iii;
my $yClean = 0;
foreach (@INC) {
    #print ++$iii,". Pfad: $_<br>\n";
    if($_ eq '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes'){
        $INC[$yClean] = "";
        $yClean = $yClean +1;
    }
}
#----------------------------------------------------------------------------------------------------------------------


