#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;
use DBI;


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
my $v_s = $params->param("v_s");
my $v_u = $params->param("v_u");
my $currentCompany = $params->param("company");

if (! defined $v_s){
	$v_s = "";
}

if (! defined $v_u){
	$v_u = "";
}

if (! defined $currentCompany){
	$currentCompany = "";
}

# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objNavigation;
my $objConfig;
my $objABL;
my $objAccoounting;
my $companyExportLink;

my $vSecond = (localtime())[0];
my $vMinute = (localtime())[1];
my $vNothing = $vSecond . $vMinute;

my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_year = $v_year +1900;
$v_month = $v_month;

# ---------------------- INITIALIZE OBJECTS  ----------------------------------------------------

$objConfig = PageConfig->new();
$objAccoounting = AccountingBusinessLayer->new();

# ---------------------- CODE FOR PAGE LAYOUT ----------------------------------------------------

$objPage = Page->new();
$objNavigation = Navigation->new();
$objPage->setTitle($objConfig->get("page-title"));
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'admin.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');

$objABL = AdminBusinessLayer->new();

if( $objABL->checkLogin($v_u, $v_s) eq 1 ){
    
    # if login successful then display menu 
    $objPage->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"accounting", $currentCompany)  );
    $objPage->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

    # table with links

    my $grid = Grid->new();
    my @arr;
    my @arrCompany;
    
    $currentCompany = $currentCompany . "";
    
    if ($currentCompany ne ''){
    @arrCompany = $objAccoounting->getCompanyById($currentCompany);    

        $companyExportLink = $objPage->getPopLink('','./export.pl?v_u='. $v_u . '&v_s='.$v_s.'&company='.$currentCompany . '&v_nothing='.$vNothing, '<br /><br />Export completely ' . $arrCompany[2] ) ;
        $companyExportLink .= '<br />';
        $companyExportLink .= $objPage->getPopLink('','./ustva.pl?v_u='. $v_u . '&v_s='.$v_s.'&company='.$currentCompany . '&v_nothing='.$vNothing . '&v_offset=1', '<br />' . yearMonthOffset(1) . ' UstVa ' . $arrCompany[2] ) ;
        $v_month = $v_month - 1;
        $companyExportLink .= $objPage->getPopLink('','./ustva.pl?v_u='. $v_u . '&v_s='.$v_s.'&company='.$currentCompany . '&v_nothing='.$vNothing . '&v_offset=2', '<br />' . yearMonthOffset(2) . ' UstVa ' . $arrCompany[2] ) ;
        $v_month = $v_month - 1;
        $companyExportLink .= $objPage->getPopLink('','./ustva.pl?v_u='. $v_u . '&v_s='.$v_s.'&company='.$currentCompany . '&v_nothing='.$vNothing . '&v_offset=3', '<br />' . yearMonthOffset(3) . ' UstVa ' . $arrCompany[2] ) ;
        $companyExportLink .= '<br />';
        $companyExportLink .= $objPage->getPopLink('','./balance.pl?v_u='. $v_u . '&v_s='.$v_s.'&company='.$currentCompany . '&v_nothing='.$vNothing, '<br />Bilanz ' . $arrCompany[2] ) ;

        $objPage->addContainer('currentComp','navigation','Current company: ' . $arrCompany[2] . ' ' . $companyExportLink );
    }else{
        $objPage->addContainer('currentComp','navigation','Currently no company selected.');
    }
    $objPage->positionContainerAbsolut("currentComp", "TOP", "CENTER", 100, 100, 100,10);
    
    @arr = $objAccoounting->getCompanies;
    
    $grid->setContent(@arr);
    #$grid->addHeader($objPage->getLink('','./timesheet.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new','new'));
    $grid->addLink(0,'myclass','index.pl?v_u=#v_u#&v_s=#v_s#&company=#id#', 'select');
    $grid->addGlobalReplacement('#v_u#', $v_u);
    $grid->addGlobalReplacement('#v_s#', $v_s);
    $grid->addRecordReplacement('#id#', 0);
    
    $objPage->addContainer('tableCompanies','navigation',$grid->build);
    $objPage->positionContainerAbsolut("tableCompanies", "TOP", "CENTER", 100, 100, 300,10);
    

}else{
    #login failed
    $objPage->jumpToPage("../admin/login.pl");
}

$objPage->setEncoding('xhtml');
$objPage->initialize;
$objPage->display;

sub yearMonthOffset{

   my $v_offset = $_[0];
   my $v_month = (localtime())[4];
   my $v_year = (localtime())[5];

   my $monthRes;

   $v_year = $v_year +1900;
   $v_month = $v_month + 1;

   $monthRes = $v_month;
 
   if($v_offset eq ''){
      $v_offset = 0;
   }

   if($v_offset > $v_month){
      $monthRes = 12 - ($v_offset - $v_month);
      $v_year = $v_year - 1
   }

   if($v_offset eq $v_month){
      $monthRes= 12;
      $v_year = $v_year - 1
   }  

   if($v_offset < $v_month){
      $monthRes= $v_month - $v_offset;
   }

   return $monthRes . '/' . $v_year
}



# ---------------------- Endo of CODE ---------------------------------------------------------


