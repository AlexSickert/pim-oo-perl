#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use warnings;

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


#=======================================================================================
my $page = Page->new();
my $objForm;
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = DataBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();
my $db;
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];
my $a;
$v_year = $v_year + 1900;
$v_month = $v_month + 1;
my $newId;
my $moneyOpen;

#=======================================================================================

my @formValuesBeforeSave;
my $action = param("action");
my $id = param("id");
my $messages;
my $v_u = param("v_u");
my $v_s = param("v_s");
my $sheet_year = param("sheet_year");
my $sheet_month = param("sheet_month"); 
my $sheet_day = param("sheet_day");
my $sheet_from = param("sheet_from"); 
my $sheet_to = param("sheet_to"); 
my $sheet_client = param("sheet_client"); 
my $sheet_project = param("sheet_project"); 
my $sheet_bill_time = param("sheet_bill_time"); 
my $comment = param("comment");
my $status = param("status");
my $mode = param("mode");
my $rate = param("rate");
my $fixed_price = param("fixed_price");

my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];
my $v_year_short = (localtime())[5];

my $javaScript;
my @tableContent;
my $yTableRow;
my $yInExcelTable;
my $yTableRow;

# =======================================================================================
if (! defined($sheet_year)){ $sheet_year = 0;};
if (! defined($sheet_month)){ $sheet_month= 0;};
if (! defined($sheet_day)){ $sheet_day= 0;};
if (! defined($sheet_from)){ $sheet_from= 0;};
if (! defined($sheet_to)){ $sheet_to= 0;};
if (! defined($sheet_client)){ $sheet_client= 0;};
if (! defined($sheet_project)){ $sheet_project= 0;};
if (! defined($sheet_bill_time)){ $sheet_bill_time= 0;};
if (! defined($comment)){ $comment = 0;};
if (! defined($status)){ $status = 0;};
if (! defined($mode)){ $mode= 0;};
if (! defined($fixed_price)){ $fixed_price = 0;};
if (! defined($rate )){ $rate = 0;};
#=======================================================================================

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');

$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'data.js');


# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){

# =======================================================================================
# add if necessary the navigation
if($action eq 'export' || $action eq 'exportAll'){
	# nothing
}else{
	if($mode eq '' || $mode eq 'full'){	
	   $page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"admin")  );
	}else{
	 # nothing
	}
}

# =======================================================================================
#save existing record
if($action eq 'edit_save'){
   $messages = $objDataBusinessLayer->updateExistingTimesheet( $id,$sheet_year, $sheet_month, $sheet_day , $sheet_from, $sheet_to, $sheet_client, $sheet_project, $sheet_bill_time, $comment, $status, $rate, $fixed_price);
   #$page->addContent( $messages );
}
# =======================================================================================
# save new record
if($action eq 'new_save'){
   $newId = $v_year_short . $v_month .  $v_day . $v_hour . $v_minute . $v_second;
   $messages = $objDataBusinessLayer->insertIntoTimesheet($sheet_year, $sheet_month, $sheet_day , $sheet_from, $sheet_to, $sheet_client, $sheet_project, $sheet_bill_time, $comment, $status,  $rate, $fixed_price);
}
# =======================================================================================
# create array with data for form
if($action eq 'edit'){
   @formValuesBeforeSave = $objDataBusinessLayer->getTimesheetById($id);
}
# =======================================================================================
# if we need the form
if($action eq 'edit' || $action eq 'new'){

   $objForm = Form->new();
   $objForm ->addDropdownEditable(1, 'sheet_year','f_input','year','data', 'years', $formValuesBeforeSave[1], $v_u, $v_s);
   $objForm ->addDropdownEditable(1, 'sheet_month','f_input','month','data', 'months', $formValuesBeforeSave[2], $v_u, $v_s);
   $objForm ->addDropdownEditable(1, 'sheet_day','f_input','day','data', 'days', $formValuesBeforeSave[3], $v_u, $v_s);
   $objForm ->addDropdownEditable(1, 'sheet_from','f_input','from','data', 'hours', $formValuesBeforeSave[4], $v_u, $v_s);
   $objForm ->addDropdownEditable(1, 'sheet_to','f_input','to','data', 'hours', $formValuesBeforeSave[5], $v_u, $v_s);
   $objForm ->addDropdownEditable(1, 'sheet_client','f_input','client','data', 'clients', $formValuesBeforeSave[6], $v_u, $v_s);
   #$objForm ->addInput(1, 'sheet_project','f_input','project',$formValuesBeforeSave[7]);
   $objForm ->addDropdownEditable(1, 'sheet_project','f_input','project','data', 'projects', $formValuesBeforeSave[7], $v_u, $v_s);
   $objForm ->addInput(1, 'sheet_bill_time','f_input','billed time',$formValuesBeforeSave[8]);
   #$objForm ->addInput(1, 'rate','f_input','rate',$formValuesBeforeSave[11]);
   $objForm ->addDropdownEditable(1, 'rate','f_input','rate','data', 'rates', $formValuesBeforeSave[11], $v_u, $v_s);

   $objForm ->addInput(1, 'fixed_price','f_input','fixed_price',$formValuesBeforeSave[12]);
   $objForm ->addInput(1, 'comment','f_input','comment',$formValuesBeforeSave[9]);
   #$objForm ->addInput(1, 'status','f_input','status',$formValuesBeforeSave[10]);
   $objForm ->addDropdownEditable(1, 'status','f_input','status','data', 'status', $formValuesBeforeSave[10], $v_u, $v_s);
   $objForm ->addButton(2, 'savebutton','f_databutton','save','document.myform.submit();');
   $objForm ->addHidden('id',$formValuesBeforeSave[0]);
   $objForm ->addHidden('v_u',$v_u);
   $objForm ->addHidden('v_s',$v_s);
   $objForm ->addHidden('v_folder',$id);
   $objForm ->addHidden('action', $action . '_save');
   $page->addContainer('adiandupdateform','MainAreaTimesheet', $objForm->getForm('timesheet.pl'));
}

# =======================================================================================
# excel export of table

if($action eq 'export' || $action eq 'exportAll'){

	if($action eq 'export' ){
		@tableContent = $objDataBusinessLayer->getTimesheetForExcel();
	}else{
		@tableContent = $objDataBusinessLayer->getTimesheetForExcelAll();
	}


$javaScript = "<table>";

$javaScript .= "<tr>";
$javaScript .= "<td>Jahr</td>";
$javaScript .= "<td>Monat</td>";
$javaScript .= "<td>Tag</td>";
$javaScript .= "<td>Von</td>";
$javaScript .= "<td>Bis</td>";
$javaScript .= "<td>Kunde</td>";
$javaScript .= "<td>Projekt</td>";
$javaScript .= "<td>Stunden</td>";
$javaScript .= "<td>Satz</td>";
$javaScript .= "<td>Fixbetrag</td>";
$javaScript .= "<td>Betrag</td>";
$javaScript .= "<td>Kommentar</td>";
$javaScript .= "</tr>";

for $yTableRow (0.. $#tableContent ){

		$javaScript .= "<tr>";
		#$javaScript .= "<td>" . $tableContent [$yTableRow ][0]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][1]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][2]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][3]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][4]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][5]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][6]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][7]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][8]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][9]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][10]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][11]. "</td>";
		$javaScript .= "<td>" . $tableContent [$yTableRow ][12]. "</td>";
		$javaScript .= "</tr>";
}

$javaScript .= "</table>";


$page->addContainer('javaScriptBlock','javaScriptContainer',$javaScript);

}
# =======================================================================================
# if table should be displayed

if( $action ne 'edit' && $action ne 'new' && $action ne 'export' && $action ne 'exportAll'){
   
   my $grid = Grid->new();
   my @arr2;
   my @arr3;
   
   @arr2 = $objDataBusinessLayer->getTimesheet();
   @arr3 = $objDataBusinessLayer->getTimesheetMoneyOpen();

   $moneyOpen = $arr3[0];
   
   $grid->setContent(@arr2);

   # add here another and better export of the file with a popup - use method of page object and then export table only

   $grid->addHeader($page->getLink('','./timesheet.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new','new') . '<br />' . $page->getPopLink('dataExport','./timesheet.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=export','[export]') . '<br />' . $page->getPopLink('dataExport','./timesheet.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=exportAll','[export&nbsp;all]'));
   $grid->addHeader('year');
   $grid->addHeader('month');
   $grid->addHeader('day');
   $grid->addHeader('from');
   $grid->addHeader('to');
   $grid->addHeader('client');
   $grid->addHeader('project');
   $grid->addHeader('bill&nbsp;time');
   $grid->addHeader('rate');
   $grid->addHeader('fixed price');
   $grid->addHeader('money made <br />[' . $moneyOpen  . ']');
   $grid->addHeader('comment');
   $grid->addHeader('status');

   $grid->setDefaultClass('g_table','g_header','g_row_1','g_row_2');
   $grid->addLink(0,'myclass','timesheet.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=edit', 'edit');

   #button
   $grid->addButtonWithId(13, 'switch_#id#', 'default', 'changeStatusTimesheetEntry(\'#id#\', this.value)', '#switch#');

   $grid->addGlobalReplacement('#v_u#', $v_u);
   $grid->addGlobalReplacement('#v_s#', $v_s);
   $grid->addRecordReplacement('#id#', 0);
   $grid->addRecordReplacement('#switch#', 13);
   $page->addContainer('adiandupdateform','MainAreaList',  $grid->build );
   $page->positionContainerAbsolut("adiandupdateform", "TOP", "CENTER", 10, 10, 100,10);
}


#=======================================================================================
#now else part  of security check
}else{

   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
#=======================================================================================
if($action ne 'export' && $action ne 'exportAll'){
	$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"data")  );
	$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
}
$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0
