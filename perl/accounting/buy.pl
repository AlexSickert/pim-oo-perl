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

#accounts:
my $transactionProductType = $params->param("transactionProductType");    
my $transactionPaymentWith = $params->param("transactionPaymentWith");
my $transactionSupplier = $params->param("transactionSupplier");
my $transactionVatType  = $params->param("transactionVatType");

#bill parameter
my $transactionDateBill = $params->param("transactionDateBill");
my $transactionDatePayment = $params->param("transactionDatePayment");
my $transactionAmountBill = $params->param("transactionAmountBill");
my $transactionAmountVat = $params->param("transactionAmountVat");
my $transactionComment = $params->param("transactionComment");
my $totalAmount;

$totalAmount = $transactionAmountVat + $transactionAmountBill;


           


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


        # ---------------------- Save default settings -----------------------------------------------
        if($action eq 'save'){
           $objABL->setParameter('accounting', $currentCompany . 'transactionSupplier',$transactionSupplier);
           $objABL->setParameter('accounting', $currentCompany . 'transactionProductType',$transactionProductType);
           $objABL->setParameter('accounting', $currentCompany . 'transactionPaymentWith',$transactionPaymentWith);
           $objABL->setParameter('accounting', $currentCompany . 'transactionVatType',$transactionVatType);

           $objABL->setParameter('accounting', $currentCompany . 'transactionDateBill',$transactionDateBill);
           $objABL->setParameter('accounting', $currentCompany . 'transactionDatePayment',$transactionDatePayment);
           $objABL->setParameter('accounting', $currentCompany . 'transactionAmountBill',$transactionAmountBill);
           $objABL->setParameter('accounting', $currentCompany . 'transactionAmountVat',$transactionAmountVat);

           $objABL->setParameter('accounting', $currentCompany . 'transactionComment ',$transactionComment );
        }

        if ($currentCompany ne ''){
            @arrCompany = $objAccoounting->getCompanyById($currentCompany);  
            $companyPrefix = $arrCompany[1];   
            $objPage->addContainer('currentComp','navigation','Current company: ' . $arrCompany[2] . ' <br />Prefix: ' . $companyPrefix);
            
            
            $objForm = Form->new();
            
            

            #if action = save then save transaction
            if($action eq 'save'){

                #transaction of product
                $objAccoounting->makeTransaction($transactionSupplier, $transactionProductType , $transactionDateBill , $transactionAmountBill , $transactionComment );
                # transaction of VAT
                $objAccoounting->makeTransaction($transactionSupplier, $transactionVatType  , $transactionDateBill , $transactionAmountVat , $transactionComment ); 
                # transaction of payment
                $objAccoounting->makeTransaction($transactionPaymentWith , $transactionSupplier, $transactionDatePayment , $totalAmount  , $transactionComment ); 
   

                $transactionId = $objAccoounting->getMaxTransactionId;
                $objPage->addContainer('transactionMessage','navigation','transaction ' . $transactionId . ' performed');
                $objPage->positionContainerAbsolut("transactionMessage", "TOP", "CENTER", 100, 100, 250,10);


                #save default settings
            }
            
            $transactionId = $objAccoounting->getMaxTransactionId;
            $transactionId = $transactionId + 1;
            
            #get dropdown of accounts            
            
            
            
            $objForm ->addLabel(1, 'BUY - Transaction: ' . $transactionId);

            $dropdown = $objAccoounting->getAccountsForDropdownByCategory($companyPrefix, 'supplier_account_liability');
            $objForm ->addDropdown(1, 'transactionSupplier','f_input','supplier account', $dropdown, $objABL->getParameter('accounting', $currentCompany . 'transactionSupplier'), '-none-', 0); 
            
            $dropdown = $objAccoounting->getAccountsForDropdownByCategory($companyPrefix, 'supplier_product_type');
            $objForm ->addDropdown(1, 'transactionProductType','f_input','product type', $dropdown, $objABL->getParameter('accounting', $currentCompany . 'transactionProductType'), '-none-', 0); 

            $dropdown = $objAccoounting->getAccountsForDropdownByCategory($companyPrefix, 'supplier_pay_type');
            $objForm ->addDropdown(1, 'transactionPaymentWith','f_input','payment with', $dropdown, $objABL->getParameter('accounting', $currentCompany . 'transactionPaymentWith'), '-none-', 0);


            $dropdown = $objAccoounting->getAccountsForDropdownByCategory($companyPrefix, 'supplier_vat ');
            $objForm ->addDropdown(1, 'transactionVatType','f_input','ust type', $dropdown, $objABL->getParameter('accounting', $currentCompany . 'transactionVatType'), '-none-', 0);

            
            $objForm ->addInput(1, 'transactionDateBill','f_input','date bill',$objABL->getParameter('accounting', $currentCompany . 'transactionDateBill') );
            $objForm ->addInput(1, 'transactionDatePayment','f_input','date payment',$objABL->getParameter('accounting', $currentCompany . 'transactionDatePayment') );
            $objForm ->addInput(1, 'transactionAmountBill','f_input','amount bill','');
            $objForm ->addInput(1, 'transactionAmountVat','f_input','amount vat','');
            
            
            $objForm ->addInput(1, 'transactionComment','f_input','comment',$objABL->getParameter('accounting', $currentCompany . 'transactionComment'));

            $objForm ->addHidden('action', 'save');
            $objForm ->addHidden('v_u', $v_u);
            $objForm ->addHidden('v_s', $v_s);
            $objForm ->addHidden('company', $currentCompany);
            
            $objForm ->addButton(2, 'savebutton','f_databutton','save','document.myform.submit();');

            $objPage->addContainer('transactionForm','navigation',$objForm->getForm('buy.pl'));
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

