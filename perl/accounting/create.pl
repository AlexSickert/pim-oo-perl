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
my $action = $params->param("action");

# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objNavigation;
my $objConfig;
my $objABL;
my $objAccoounting;
my $objForm;

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
    
    if( $currentCompany ne '' ){
        
        # if login successful then display menu 
        $objPage->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"accounting", $currentCompany)  );
        $objPage->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

        # table with links

        my $grid = Grid->new();
        my @arr;
        my @arrCompany;
        my $companyPrefix;
        
        $currentCompany = $currentCompany . "";
        
        if ($currentCompany ne ''){
            @arrCompany = $objAccoounting->getCompanyById($currentCompany);  
            $companyPrefix = $arrCompany[1];   
            $objPage->addContainer('currentComp','navigation','Current company: ' . $arrCompany[2] . ' <br />Prefix: ' . $companyPrefix);
        }else{
            $objPage->addContainer('currentComp','navigation','Currently no company selected.');
        }
        $objPage->positionContainerAbsolut("currentComp", "TOP", "CENTER", 100, 100, 100,10);
        
        
        #form to insert new account

        $objForm = Form->new();
        $objForm ->addInput(1, 'number','f_input','number (SQL table name - example: "777_xxx")','');
        $objForm ->addInput(1, 'description','f_input','description (example: "777 xxx")','');
        $objForm ->addButton(2, 'savebutton','f_databutton','save','document.myform.submit();');
        $objForm ->addHidden('v_u',$v_u);
        $objForm ->addHidden('v_s',$v_s);
        $objForm ->addHidden('company',$currentCompany);
        $objForm ->addHidden('action', 'save');
        $objPage->addContainer('formAccounts','navigation', $objForm->getForm('create.pl'));
        $objPage->positionContainerAbsolut("formAccounts", "TOP", "CENTER", 100, 100, 200,10);
            
        # if action = save then create account and insert account
        if($action eq 'save'){
            
            # create account
            my $accountNumber = $params->param("number");
            my $accountDescription = $params->param("description");
            $objAccoounting->createAccountandRegister($companyPrefix, $accountNumber,$accountDescription); 
            
        }   
        
        # create table of accounts   
        
        @arr = $objAccoounting->getAccountsByPrefix($companyPrefix);
        
        $grid->setContent(@arr);
        #$grid->addHeader($objPage->getLink('','./timesheet.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new','new'));
        #$grid->addLink(0,'myclass','index.pl?v_u=#v_u#&v_s=#v_s#&company=#id#', 'select');
        #$grid->addGlobalReplacement('#v_u#', $v_u);
        #$grid->addGlobalReplacement('#v_s#', $v_s);
        #$grid->addRecordReplacement('#id#', 0);
        
        $objPage->addContainer('tableCompanies','navigation',$grid->build);
        $objPage->positionContainerAbsolut("tableCompanies", "TOP", "CENTER", 100, 100, 300,10);
        
    }else{
        $objPage->jumpToPage("./index.pl?v_u=".$v_u."&v_s=".$v_s);    
    }

}else{
    #login failed
    $objPage->jumpToPage("../admin/login.pl");
}

$objPage->setEncoding('xhtml');
$objPage->initialize;
$objPage->display;

# ---------------------- Endo of CODE ---------------------------------------------------------


