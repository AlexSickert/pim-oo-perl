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



# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objNavigation;
my $objConfig;
my $objABL;
my $objAccoounting;
my $javaScript;
my @listOfTables;
my @tableContent;
my $y;
my $yTableRow;
my $yInExcelTable;
my $year = 0;

my $v_year = (localtime())[5];
$v_year = $v_year + 1900 - 1;
$year = $v_year;
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
#$objPage->addJavaScript($objConfig->jsPath() . 'classes.js');

$objABL = AdminBusinessLayer->new();

if( $objABL->checkLogin($v_u, $v_s) eq 1 ){

    my @arr;
    my @arrCompany;
    
    $currentCompany = $currentCompany . "";


	print "Content-Type:application/octet-stream; name=\"" . "ACCOUNTING-ALL-" . $currentCompany . ".html" . "\"\r\n";
	print "Content-Disposition: attachment; filename=\"" . "ACCOUNTING-ALL-" . $currentCompany . ".html"  .  "\"\r\n\n";
    
    if ($currentCompany ne ''){
        @arrCompany = $objAccoounting->getCompanyById($currentCompany);    
        #$objPage->addContainer('currentComp','navigation','Current company: ' . $arrCompany[2]);

        #--------------------

        $javaScript = "";
        $javaScript .= '' . "\n";
        $javaScript .= '<SCRIPT LANGUAGE="VBScript">' . "\n";
        $javaScript .= 'dim app' . "\n";
        $javaScript .= 'set app = createobject("Excel.Application")' . "\n";
        $javaScript .= 'app.Visible = true' . "\n";
        $javaScript .= 'dim wb' . "\n";
        $javaScript .= 'dim ws' . "\n";
        $javaScript .= 'set wb = app.workbooks.add' . "\n";


        # get list of tables

            @listOfTables = $objAccoounting->getAccountsForExport($arrCompany[1]);


        #for each table new worsheet
           for $y (0.. $#listOfTables){

              $javaScript .= 'app.ScreenUpdating = True' . "\n";
              $javaScript .= 'set ws = app.worksheets.add' . "\n";

              # substr (STRING,OFFSET,LEN)
              $javaScript .= 'wb.Activesheet.name = "' . substr($listOfTables[$y][0],0,30) . '"' . "\n";

              # balance
              $javaScript .= 'wb.Activesheet.Cells(2 , 6) = "Year"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(3 , 6) = "Opening Balance"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(4 , 6) = "Inflow"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(5 , 6) = "Outflow"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(6 , 6) = "Closing Balance"' . "\n";

              $javaScript .= 'wb.Activesheet.Cells(2 , 7) = ' . $year . '' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(3 , 7) = "'. $objAccoounting->getOpeningBalance($listOfTables[$y][0], $year) .'"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(4 , 7) = "'. $objAccoounting->getInflow($listOfTables[$y][0], $year) .'"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(5 , 7) = "'. $objAccoounting->getOutflow($listOfTables[$y][0], $year) .'"' . "\n";              
              $javaScript .= 'wb.Activesheet.Cells(6 , 7) = "'. $objAccoounting->getClosingBalance($listOfTables[$y][0], $year) .'"' . "\n";



              # get content of table    $listOfTables[$y][0]
              @tableContent = $objAccoounting->getAccount($listOfTables[$y][0]);
               
              for $yTableRow (0.. $#tableContent ){
                 $yInExcelTable = $yTableRow + 10;
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 2) = "'.$tableContent [$yTableRow ][0].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 3) = "'.$tableContent [$yTableRow ][1].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 4) = "'.$tableContent [$yTableRow ][2].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 5) = "'.$tableContent [$yTableRow ][3].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 6) = "'.$tableContent [$yTableRow ][4].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 7) = "'.$tableContent [$yTableRow ][5].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 8) = "'.$tableContent [$yTableRow ][6].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 9) = "'.$tableContent [$yTableRow ][7].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 10) = "'.$tableContent [$yTableRow ][8].'"' . "\n";
                 $javaScript .= 'wb.Activesheet.Cells(' . $yInExcelTable  . ' , 11) = "'.$tableContent [$yTableRow ][9].'"' . "\n";
              }

              # loop through table
              


           } # end of loop for all tables
        # end of for each table new worsheet

           $javaScript .= 'app.ScreenUpdating = True' . "\n";
           $javaScript .= 'app.UserControl = true ' . "\n";
	   $javaScript .= 'msgbox("done") ' . "\n";
           $javaScript .= '</SCRIPT>' . "\n";

           #$objPage->addContainer('javaScriptBlock','javaScriptContainer',$javaScript);


	print '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
	print '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">';
	print "<html>";
	print "<body>";
	print "ACCOUNTING-ALL-" . $currentCompany . ".html";
	print $javaScript ;
	print "</body>";
	print "</html>";


    }else{
        $objPage->addContainer('currentComp','navigation','Currently no company selected. Export  not possible');
    }
    #$objPage->positionContainerAbsolut("currentComp", "TOP", "CENTER", 100, 100, 100,10);
    
    @arr = $objAccoounting->getCompanies;
    

}else{
	#login failed
	$objPage->jumpToPage("../admin/login.pl");
	$objPage->setEncoding('xhtml');
	$objPage->initialize;
	$objPage->display;
}



# ---------------------- Endo of CODE ---------------------------------------------------------


