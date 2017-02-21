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
my $v_offset = $params->param("v_offset");
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
my $x;
my $xYear;
my $xMonth;
my $yPos;
my $xPos;
my $yTableRow;
my $yInExcelTable;

my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_year = $v_year +1900;
$v_month = $v_month + 1;
my $monthRes;

# --------------------------

   if($v_offset eq ''){
      $v_offset = 0;
   }
   
   $monthRes = $v_month;


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

   $v_month = $monthRes;

# -------------------------
my $v_yearMin;

$v_yearMin = $v_year - 3;

my $currMonth;
my $deltaMonth;
my $currYear;

my $yTableOffset;
my $xMonthOffset;

$yTableOffset = 10;
$xMonthOffset = 5;


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
    
    if ($currentCompany ne ''){
        @arrCompany = $objAccoounting->getCompanyById($currentCompany);    
        $objPage->addContainer('currentComp','navigation','UstVA - Current company: ' . $arrCompany[2] . ' year: ' . $v_year . ' month: ' . $v_month );

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

           #@listOfTables = $objAccoounting->getAccountsForExport($arrCompany[1]);
           @listOfTables = $objAccoounting->getAccountsForExportSorted($arrCompany[1]);


           $javaScript .= 'app.ScreenUpdating = True' . "\n";
           $javaScript .= 'set ws = app.worksheets.add' . "\n";

           # substr (STRING,OFFSET,LEN)
           $javaScript .= '\'wb.Activesheet.name = "UstVa-'.$v_year.'-' .$v_month. '"' . "\n";

           $javaScript .= 'wb.Activesheet.name = "UstVa-'.$v_year.'-' .$v_month. '"' . "\n";

        #for each table new worsheet
           for $y (0.. $#listOfTables){

              $yPos = $y + $yTableOffset;

              #formula for subtraction
              $javaScript .= 'wb.Activesheet.Range("B'. $yPos  .'").Formula = "=( (F'. $yPos  .' - G'. $yPos  .'))"'. "\n";


              $xPos = $xMonthOffset;

              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , ' . ($xMonthOffset - 0)  . ') = "'. $listOfTables[$y][0] .'"' . "\n";
               
              #money inflow
              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , ' . ($xMonthOffset - 2) . ') = "'. $objAccoounting->getInflowByMonth($listOfTables[$y][0], $v_year  , $v_month) .'"' . "\n";

              #money outflow
              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , ' . ($xMonthOffset - 1) . ') = "'. $objAccoounting->getOutflowByMonth($listOfTables[$y][0], $v_year  , $v_month) .'"' . "\n"; 


              for $xYear (0..2){

                 if($xYear eq '0'){
                    $deltaMonth = 12 - $v_month;
                 }else{
                    $deltaMonth = 0;
                 }

                 for $xMonth ($deltaMonth..11){
                    $xPos = $xPos +1;
                    $currMonth = 12 - $xMonth ;
                    $currYear = $v_year - $xYear ;

                    $javaScript .= 'wb.Activesheet.Cells(' . ($yTableOffset - 1)  . ' , ' . $xPos  . ') = "'. $currMonth . '"'. "\n";
                    $javaScript .= 'wb.Activesheet.Cells(' . ($yTableOffset - 2) . ' , ' . $xPos  . ') = "'. $currYear . '"'. "\n";

                    #$javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , ' . $xPos  . ') = "' . $currYear . '-' . $currMonth  . '"'. "\n";
                    $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , ' . $xPos  . ') = "'. $objAccoounting->getBalanceByMonth($listOfTables[$y][0], $currYear , $currMonth) .'"' . "\n";

                 }
              }
           } # end of loop for all tables
        # end of for each table new worsheet

           $javaScript .= 'wb.Activesheet.Cells(8,2) = "Delta"' . "\n";
           $javaScript .= 'wb.Activesheet.Cells(8,3) = "In"' . "\n";
           $javaScript .= 'wb.Activesheet.Cells(8,4) = "Out"' . "\n";


           $javaScript .= 'wb.Activesheet.Range("A1:FF9").Font.Bold = "True"'  . "\n";
           $javaScript .= 'wb.Activesheet.Range("E1:E100").Font.Bold = "True"'  . "\n";
           $javaScript .= 'wb.Activesheet.Columns("A:Z").AutoFit'  . "\n";



           $javaScript .= 'app.ScreenUpdating = True' . "\n";
           $javaScript .= 'app.UserControl = true ' . "\n";
           $javaScript .= '</SCRIPT>' . "\n";

           $objPage->addContainer('javaScriptBlock','javaScriptContainer',$javaScript);

    }else{
        $objPage->addContainer('currentComp','navigation','Currently no company selected. Export  not possible');
    }


}else{
    #login failed
    $objPage->jumpToPage("../admin/login.pl");
}

$objPage->setEncoding('xhtml');
$objPage->initialize;
$objPage->display;

# ---------------------- Endo of CODE ---------------------------------------------------------


