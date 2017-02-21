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

my $from = $params->param("v_from");
my $to = $params->param("v_to");

my $action = $params->param("action");

my $transactionFrom = $params->param("transactionFrom");

# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objTable;
my $objNavigation;
my $objConfig;
my $objABL;
my $objAccoounting;
my @arrCompany;
my @arrBalance;
my $companyPrefix;
my $dropdown;
my $transactionId;
my $grid;
my $balance;
my @arr;
# ---------------------- INITIALIZE OBJECTS  ----------------------------------------------------

$objConfig = PageConfig->new();
$objAccoounting = AccountingBusinessLayer->new();
$grid = Grid->new();
$objTable = Table->new();
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
            
            @arrBalance = $objAccoounting->getAccountInOutBalance($transactionFrom);
            #show balance of account
            $objTable->addRow();
            $objTable->addField('','label','In');
            $objTable->addField('','acountingNumber',$arrBalance[0]);
            $objTable->addRow();
            $objTable->addField('','label','Out');
            $objTable->addField('','acountingNumber',$arrBalance[1]);
            $objTable->addRow();
            $objTable->addField('','label','Balance');
            $objTable->addField('','acountingNumber',$arrBalance[2]);
            
            $balance = "BALANCE";
            $objPage->addContainer('currentBalance','navigation',$objTable->getTable());
            $objPage->positionContainerAbsolut("currentBalance", "TOP", "LEFT", 500, 100, 100,10);
            
            $objForm = Form->new();
        
            #get dropdown of accounts    
            $dropdown = $objAccoounting->getAccountsForDropdown($companyPrefix);            
            $objForm ->addDropdown(1, 'transactionFrom','f_input','account: ', $dropdown, $transactionFrom, '', 0);            
            $objForm ->addHidden('action', 'save');
            $objForm ->addHidden('v_u', $v_u);
            $objForm ->addHidden('v_s', $v_s);
            $objForm ->addHidden('company', $currentCompany);


            $objForm ->addInput(2, 'v_from','','from','0000-00-00');
            $objForm ->addInput(3, 'v_to','','to','2099-00-00');
            $objForm ->addButton(4, 'savebutton','f_databutton','save','document.myform.submit();');

            $objPage->addContainer('transactionForm','navigation',$objForm->getForm('show_by_date.pl'));
            $objPage->positionContainerAbsolut("transactionForm", "TOP", "LEFT", 100, 100, 150,10);
            
            if ($action eq 'save'){
                                
                @arr = $objAccoounting->getAccountByDate($transactionFrom, $from, $to);

                $grid->setDefaultClass('accTab', 'accHead', 'acfi1', 'acfi2');

                $grid->setContent(@arr);
                $grid->addHeader('&nbsp;order-date&nbsp;');
                $grid->addHeader('&nbsp;date-in&nbsp;');
                $grid->addHeader('&nbsp;account-in&nbsp;');
                $grid->addHeader('&nbsp;currency-in&nbsp;');
                $grid->addHeader('&nbsp;amount-in&nbsp;');
                $grid->addHeader('&nbsp;comment-in&nbsp;');
                
                $grid->addHeader('&nbsp;date-out&nbsp;');
                $grid->addHeader('&nbsp;account-out&nbsp;');
                $grid->addHeader('&nbsp;currency-out&nbsp;');
                $grid->addHeader('&nbsp;amount-out&nbsp;');
                $grid->addHeader('&nbsp;comment-out&nbsp;');
                
                $objPage->addContainer('accountTable','navigation',$grid->build);
                $objPage->positionContainerAbsolut("accountTable", "TOP", "CENTER", 10, 10, 200,10);

            }
                
        }else{
            $objPage->addContainer('currentComp','navigation','Currently no company selected.');
        }
        $objPage->positionContainerAbsolut("currentComp", "TOP", "LEFT", 100, 100, 100,10);

        
        
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


