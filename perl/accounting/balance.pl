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
my $v_p = $params->param("v_p");
my $v_s = $params->param("v_s");
my $v_u = $params->param("v_u");
my $v_x = $params->param("v_x");
my $currentCompany = $params->param("company");
# ---------------------- VARIABLES  ---------------------------------------------------------

my $objPage;
my $objForm;
my $objNavigation;
my $objConfig;
my $objABL;
my $objAccoounting;

my $javaScript;
my @listOfTables,
my @arrCompany;
my @arrValues;
my $yPos;
my $y;
my $yTableOffset;


# ---------------------- INITIALIZE OBJECTS  ----------------------------------------------------


$objConfig = PageConfig->new();
$objAccoounting = AccountingBusinessLayer->new();


# ---------------------- SET INITIAL VALUES ----------------------------------------------------

my $yearStart = 2006;
my $v_year = (localtime())[5];
$v_year = $v_year + 1900 - 1;
my $yearEnd = $v_year;

$v_year = 2006; 

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


	print "Content-Type:application/octet-stream; name=\"" . "BALANCE-" . $yearStart . "-" . $yearEnd . ".html" . "\"\r\n";
	print "Content-Disposition: attachment; filename=\"" . "BALANCE-" . $yearStart . "-" . $yearEnd . ".html"  .  "\"\r\n\n";

#    $objPage->addContainer('messages','navigation','creating blalance ' . $yearStart . " - " . $yearEnd);
#    $objPage->positionContainerAbsolut("messages", "TOP", "CENTER", 100, 100, 100,10);
    #vb code for excel

        $javaScript = "";
        $javaScript .= '' . "\n";
        $javaScript .= '<SCRIPT LANGUAGE="VBScript">' . "\n";
        $javaScript .= 'dim app' . "\n\r";
	$javaScript .= '' . "\r\n\r\n";
        $javaScript .= 'set app = createobject("Excel.Application")' . "\r\n\r\n";
	$javaScript .= '' . "\r\n\r\n";
	$javaScript .= '' . "\r\n\r\n";
        $javaScript .= 'app.Visible = true' . "\r\n\r\n";
        $javaScript .= 'dim wb' . "\n";
        $javaScript .= 'dim ws' . "\n";
        $javaScript .= 'set wb = app.workbooks.add' . "\n";

        # get list of tables

           
           @arrCompany = $objAccoounting->getCompanyById($currentCompany);    
           $objPage->addContainer('currentComp','navigation','Current company: ' . $arrCompany[2]);

           @listOfTables = $objAccoounting->getAccountsForExport($arrCompany[1]);
           #@listOfTables = $objAccoounting->getAccountsForExportSorted($arrCompany[1]);

           $javaScript .= 'app.ScreenUpdating = True' . "\n";


# for each year
for $v_year ($yearStart.. $yearEnd ){

           $javaScript .= 'set ws = app.worksheets.add' . "\n";

           # substr (STRING,OFFSET,LEN)
           $javaScript .= 'wb.Activesheet.name = "Balance '.$v_year.'"' . "\n";

        #for each table new worsheet
           $yTableOffset = 5;

           for $y (0.. $#listOfTables){


              $yPos = $y + $yTableOffset + 1;

         

              

               
              @arrValues = $objAccoounting->getBalance($listOfTables[$y][0], $v_year);

              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , 2) = "'. $arrValues[0] .'"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , 3) = "'. $arrValues[1] .'"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , 4) = "'. $arrValues[2] .'"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , 5) = "'. $arrValues[3] .'"' . "\n";
              $javaScript .= 'wb.Activesheet.Cells(' . $yPos  . ' , 6) = "'. $arrValues[4] .'"' . "\n";

           }

           $javaScript .= 'wb.Activesheet.Cells(' . $yTableOffset . ',2) = "Account"' . "\n";
           $javaScript .= 'wb.Activesheet.Cells(' . $yTableOffset . ',3) = "In (31.12.'.$v_year.')"' . "\n";
           $javaScript .= 'wb.Activesheet.Cells(' . $yTableOffset . ',4) = "Out (31.12.'.$v_year.')"' . "\n";
           $javaScript .= 'wb.Activesheet.Cells(' . $yTableOffset . ',5) = "In (01.01.'.$v_year.')"' . "\n";
           $javaScript .= 'wb.Activesheet.Cells(' . $yTableOffset . ',6) = "Out (01.01.'.$v_year.')"' . "\n";

           $javaScript .= 'wb.Activesheet.Range("A1:FF5").Font.Bold = "True"'  . "\n";
           $javaScript .= 'wb.Activesheet.Columns("A:Z").AutoFit'  . "\n";


# for each year end
}

           $javaScript .= 'app.ScreenUpdating = True' . "\n";
           $javaScript .= 'app.UserControl = true ' . "\n";
           
	   $javaScript .= 'msgbox("done") ' . "\n";
           $javaScript .= '</SCRIPT>' . "\n";

       

#           $objPage->addContainer('javaScriptBlock','javaScriptContainer',$javaScript);

        #end of VBA code

	# make html site

	print '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
	print '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">';
	print "<html>";
	print "<body>";
	print 'creating blalance ' . $yearStart . " - " . $yearEnd;
	print $javaScript ;
	print "</body>";
	print "</html>";
 

}else{
    #login failed
    $objPage->jumpToPage("../admin/login.pl");
}

#$objPage->setEncoding('xhtml');
#$objPage->initialize;
#$objPage->display;

# ---------------------- Endo of CODE ---------------------------------------------------------


