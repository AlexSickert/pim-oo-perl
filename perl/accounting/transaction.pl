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

my $transactionFrom = $params->param("transactionFrom");
my $transactionTo = $params->param("transactionTo");
my $transactionDate = $params->param("transactionDate");
my $transactionAmount = $params->param("transactionAmount");
my $transactionComment = $params->param("transactionComment");

# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objNavigation;
my $objConfig;
my $objABL;
my $objAccoounting;
my @arrCompany;
my $companyPrefix;
my $dropdown;
my $transactionId;

# ---------------------- INITIALIZE OBJECTS  ----------------------------------------------------

$objConfig = PageConfig->new();
$objAccoounting = AccountingBusinessLayer->new();

# ---------------------- CODE FOR PAGE LAYOUT ----------------------------------------------------

$objPage = Page->new();
$objNavigation = Navigation->new();
$objPage->setTitle($objConfig->get("page-title"));
$objPage->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'classes.css');
$objPage->addStyleSheet($objConfig->cssPath() . 'accounting.css');
$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');

$objABL = AdminBusinessLayer->new();

# first check security
# ------------------------------------------------------------------------------------------------

if($objABL->checkLogin($v_u,$v_s) eq 1 ){
    
    if( $currentCompany ne '' ){
    
        # if login successful then display menu 
        $objPage->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"accounting", $currentCompany)  );
        $objPage->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);





        if ($currentCompany ne ''){
            @arrCompany = $objAccoounting->getCompanyById($currentCompany);  
            $companyPrefix = $arrCompany[1];   
            $objPage->addContainer('currentComp','navigation','Current company: ' . $arrCompany[2] . ' <br />Prefix: ' . $companyPrefix);
            
            
            $objForm = Form->new();
            
            

            #if action = save then save transaction
            if($action eq 'save'){

                #save settings
                $objABL->setParameter('accounting', $currentCompany . 'transaction_simple_account_1',$transactionFrom);
                $objABL->setParameter('accounting', $currentCompany . 'transaction_simple_account_2',$transactionTo);
                $objABL->setParameter('accounting', $currentCompany . 'transaction_simple_date',$transactionDate);
                $objABL->setParameter('accounting', $currentCompany . 'transaction_simple_comment',$transactionComment);

                #make transaction
                $objAccoounting->makeTransaction($transactionFrom, $transactionTo, $transactionDate, $transactionAmount, $transactionComment);              
                $transactionId = $objAccoounting->getMaxTransactionId;
                $objPage->addContainer('transactionMessage','navigation','transaction ' . $transactionId . ' performed');
                $objPage->positionContainerAbsolut("transactionMessage", "TOP", "CENTER", 100, 100, 250,10);
            }
            
            $transactionId = $objAccoounting->getMaxTransactionId;
            $transactionId = $transactionId + 1;
            
            #get dropdown of accounts            
            
            $dropdown = $objAccoounting->getAccountsForDropdown($companyPrefix);
            
            $objForm ->addLabel(1, 'Transaction: ' . $transactionId);
            
            $objForm ->addDropdown(1, 'transactionFrom','f_input','from', $dropdown, $objABL->getParameter('accounting', $currentCompany . 'transaction_simple_account_1'), '', 0);            
            $objForm ->addDropdown(1, 'transactionTo','f_input','to', $dropdown, $objABL->getParameter('accounting', $currentCompany . 'transaction_simple_account_2'), '', 0);
            
            $objForm ->addInput(1, 'transactionDate','f_input','date',$objABL->getParameter('accounting', $currentCompany . 'transaction_simple_date'));
            $objForm ->addInput(1, 'transactionAmount','f_input','amount','');
            
            
            $objForm ->addInput(1, 'transactionComment','f_input','comment',$objABL->getParameter('accounting', $currentCompany . 'transaction_simple_comment'));

            $objForm ->addHidden('action', 'save');
            $objForm ->addHidden('v_u', $v_u);
            $objForm ->addHidden('v_s', $v_s);
            $objForm ->addHidden('company', $currentCompany);
            
            $objForm ->addButton(2, 'savebutton','f_databutton','save','document.myform.submit();');

            $objPage->addContainer('transactionForm','navigation',$objForm->getForm('transaction.pl'));
            $objPage->positionContainerAbsolut("transactionForm", "TOP", "CENTER", 100, 100, 300,10);
                
        }else{
            $objPage->addContainer('currentComp','navigation','Currently no company selected.');
        }
        $objPage->positionContainerAbsolut("currentComp", "TOP", "CENTER", 100, 100, 100,10);

        
        
    }else{
        $objPage->jumpToPage("./index.pl?v_u=".$v_u."&v_s=".$v_s);    
    }

# ------------------------------------------------------------------------------------------------
}else{
    #login failed
    $objPage->jumpToPage("../admin/login.pl");
}
# ------------------------------------------------------------------------------------------------


$objPage->setEncoding('xhtml');
$objPage->initialize;
$objPage->display;

# ---------------------- Endo of CODE ---------------------------------------------------------


