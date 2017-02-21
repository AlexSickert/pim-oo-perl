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

# =======================================================================================
#print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; # for debugging
# print "debugging test - please delete";
# =======================================================================================
my @arr;
my @inner;
my $page = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = DataBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();
my @formValuesBeforeSave;
my $messages;
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];
my $v_year_short = (localtime())[5];
my $newId;
my $objForm;
my $form = "";
my $permissions = 0777;
my $data; # Lesepuffer
my $v_folder = param("v_folder");
my $updir = $objConfig->uploadPath();
my $updirVirtual = $objConfig->uploadVirtualPath();
my $dateiname_insert;
my @path_array;
my $a;
my $test = "ssssss";
my $searchStringLast;
my $row;
my $field;
my @zeile;
my $dataIds;



# =======================================================================================
my $datei = param('datei');
my $dateiname = param('dateiname') ;
my $name = param("name");
my $email = param("email");
my $tel = param("tel");
my $v_u = param("v_u");
my $v_s = param("v_s");
my $v_search = param("v_search");
my $mode = param("mode") ;
my $comment = param("comment");
my $action = param("action");
my $mailclip = param("mailclip");
my $id = param("id");
my $treeId = param("treeId");


if (! defined $dateiname){
	$dateiname = "";
}

if (! defined $id){
	$id = "";
}

if (! defined $mode){
	$mode = "";
}

if (! defined $treeId){
	$treeId = "";
}


# =======================================================================================
$page->setTitle($objConfig->get("page-title"));

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'data.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
$page->addJavaScript($objConfig->jsPath() . 'OrganizerCalendar.js');


# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# add if necessary the navigation
if($mode eq '' || $mode eq 'full'){

	$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"admin")  );
	$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);
	$page->addPositionContainerAbsoluteOnWindowResize("navigation", "TOP", "LEFT", 5, 5, 5,1);

	#$page->positionContainerPercent("navigation", 1, 1,100);
}else{
	$page->addContent( closeButton($v_u,$v_s) );
}
# =======================================================================================
if($action eq ''){$action = 'new';} 
# =======================================================================================
#save existing record
if($action eq 'edit_save'){
	$name = $objDataBusinessLayer->encodeValues($name);
	$email= $objDataBusinessLayer->encodeValues($email);
	$comment= $objDataBusinessLayer->encodeValues($comment);
	$tel= $objDataBusinessLayer->encodeValues($tel);

	$messages = $objDataBusinessLayer->updateExistingData($id, $name, $tel, $email, $comment, $mailclip);
	#$page->addContent( $messages );
}
# =======================================================================================
# save new record
if($action eq 'new_save'){

	$name = $objDataBusinessLayer->encodeValues($name);
	$email= $objDataBusinessLayer->encodeValues($email);
	$comment= $objDataBusinessLayer->encodeValues($comment);
	$tel= $objDataBusinessLayer->encodeValues($tel);

	#$newId = $v_year_short . $v_month .  $v_day . $v_hour . $v_minute . $v_second;
	$newId = time() * 1 ;
	$messages = $objDataBusinessLayer->insertNewData($newId, $name, $tel, $email, $comment, $mailclip);
	
	# now save the id in the tree
	$treeId =~ s/explorer/ /ig;
         @zeile=$objDataBusinessLayer->prepareCross($treeId);
	$dataIds = $zeile[3];

	if(length($dataIds) > 1){
		$dataIds = $dataIds . ", " .  $newId;
	}else{
		$dataIds =  $newId;
	}
	$objDataBusinessLayer->updateCross($zeile[1], $zeile[2], $dataIds, $treeId);

}
# =======================================================================================
# file upload 
if($id ne '' && $dateiname ne ''){
	$updir = $updir . "" . $id;
	#print $updir;
	if(! -e $updir){   mkdir($updir,$permissions);};		
	@path_array = split(/\//,$dateiname);     # Array der einzelnen Teilstrings
	$a = @path_array;     # Anzahl der Elemente
	$dateiname = $path_array[$a-1];
	$dateiname_insert = '-' . $v_year . $v_month .  $v_day . $v_hour . $v_minute . $v_second . '.';
	$dateiname =~ s/[.]/$dateiname_insert/;
	if (! open WF, ">$updir/$dateiname"){   print "error upload"; }
	binmode $datei;
	binmode WF;
	while(read $datei,$data,1024){ print WF $data; }
	close WF;
	$test = "in upload";
	#register file for sync
	#$objAdminBusinessLayer->registerFileForSync($updir . "/" . $dateiname, "new");
}

$test .= " dateiname: ".  $dateiname;
# =======================================================================================
# create array with data for form
if($action eq 'edit'){
	@formValuesBeforeSave = $objDataBusinessLayer->getDataById($id);
}
# =======================================================================================
# if we need the form
if($action eq 'edit' || $action eq 'new'){
	
	$formValuesBeforeSave[1] = $objDataBusinessLayer->decodeValues($formValuesBeforeSave[1]);
	$formValuesBeforeSave[2] = $objDataBusinessLayer->decodeValues($formValuesBeforeSave[2]);   
	$formValuesBeforeSave[3] = $objDataBusinessLayer->decodeValues($formValuesBeforeSave[3]);
	$formValuesBeforeSave[4] = $objDataBusinessLayer->decodeValues($formValuesBeforeSave[4]);
	# the mail clip
	# $formValuesBeforeSave[6] = $formValuesBeforeSave[6];

	$objForm = Form->new();
	$objForm ->addInput(1, 'name','f_input','name',$formValuesBeforeSave[1]);
	$objForm ->addInput(1, 'email','f_input','email',$formValuesBeforeSave[3]);
	$objForm ->addInput(1, 'tel','f_input','tel',$formValuesBeforeSave[2]);
	$objForm ->addFile(2,'datei','','file');
	$objForm ->addArea(2, 'comment','f_dataform','comment',$formValuesBeforeSave[4]);
	


	$objForm ->addButton(1, 'savebutton','f_databutton','save','sendMyForm();');
	$objForm ->addInput(1, 'mailclip','f_input','mailclip', $formValuesBeforeSave[6]);

	my $clipTest = $objAdminBusinessLayer->getParameter('mail','mail-clip');

	if($clipTest ne ''){
		$objForm ->addButton(1, 'savebutton','f_databutton','push','dataPushMailClip(\'' . $clipTest . '\');');
	}
	
	$objForm ->addInput(1, 'none','f_input','',$id);

	# der container sollte die klasse   divMailList   bekommen
	$objForm ->addContainer(1, "divMailList", "dataMailList", "mails", "loading...");
	$page->setBodyOnLoad("dataLoadMailList();");
	# dataLoadMailList()
	# the container needs to habve the name mailList



	$objForm ->addHidden('id',$formValuesBeforeSave[0]);
	$objForm ->addHidden('v_u',$v_u);
	$objForm ->addHidden('v_s',$v_s);
	$objForm ->addHidden('v_folder',$id);
	$objForm ->addHidden('folder',$id);
	$objForm ->addHidden('dateiname','');
	$objForm ->addHidden('action', $action . '_save');
	$objForm ->addHidden('mode', $mode );     
	$objForm ->addHidden('treeId', $treeId ); 
	$page->addContainer('adiandupdateform','MainAreaForm', $objForm->getForm('data.pl'));
	$page->positionContainerAbsolut("adiandupdateform", "TOP", "LEFT", 10, 10, 100,1);
	$page->addPositionContainerAbsoluteOnWindowResize("adiandupdateform", "TOP", "LEFT", 10, 10, 100,1);
	$page->setGlobalVariables($v_s, $v_u);  

}
# =======================================================================================
if($action eq 'search' ){

	$form .= $page->getHidden('action','list');
	$form .= $page->getHidden('mode','full');

	$searchStringLast = $objAdminBusinessLayer->getParameter('data','search string');
	$form .= $page->getInput("v_search","",$searchStringLast);
	$form .= $page->getHidden("v_s", $v_s);
	$form .= $page->getHidden("v_u", $v_u);
	$form .= $page->getHidden("v_search", "");
	$form .= $page->getHidden("id", "");
	$form .= $page->getHidden("dateiname", "");
		
	$form .= $page->getSubmit('submit','','submit');
	$form =  $page->getForm('thisform','','./data.pl',$form );
	$page->addContainer('dataSearchForm','dataSearchForm',$form);
	#$page->positionContainerPercent("dataSearchForm", 40, 40,100);
	$page->positionContainerAbsolut("dataSearchForm", "CENTER", "CENTER", 100, 100, 100,100);
	$page->addPositionContainerAbsoluteOnWindowResize("dataSearchForm", "CENTER", "CENTER", 100, 100, 100,100);
	$page->setGlobalVariables($v_s, $v_u);  

}
# =======================================================================================
# if table should be displayed


if($action eq 'list' || $action eq 'edit_save' || $action eq 'new_save' || $action eq 'cross'){

	# followng lines added 29.08.2011 because sometimes table was not shown
	if($action eq 'edit_save' || $action eq 'new_save' ){
		sleep(1);
	}

	# save the search string 
	if ($v_search ne ''){
		$objAdminBusinessLayer->setParameter('data','search string',$v_search);
	}
		
	my $grid = Grid->new();
	my @arr2;
	if($action eq 'list' && $v_search ne '' ){
		$v_search = myTrim($v_search);
		$v_search =~ s/ /%/gi;
		@arr2 = $objDataBusinessLayer->getDataBySearch($v_search);
	}

	if($action eq 'new_save'){
		@arr2 = $objDataBusinessLayer->getDataForTableById($newId);
	}

	if($action eq 'edit_save'){
		@arr2 = $objDataBusinessLayer->getDataForTableById($id);
	}
	
	if($action eq 'cross'){
		$objDataBusinessLayer->getDataByIdCross($id);
		@arr2 = $objDataBusinessLayer->getDataByIdCross($id);
	}

			# clean the content of array  
	for $row (0.. $#arr2 ) {
		for $field (0.. $#{ $arr2 [$row] }) {
			$arr2 [$row][$field ] = $objDataBusinessLayer->decodeValues($arr2 [$row][$field ]);
		}
	}

	$grid->setContent(@arr2);
	$grid->addHeader('&nbsp;');
	#$grid->addHeader('name');
	$grid->addHeaderSortable('name', 1, 's');
	$grid->addHeader('tel');
	$grid->addHeader('mail');
	$grid->addHeader('comment');
	$grid->addHeader('file');
	$grid->setDefaultClass('g_table','g_header','g_row_clean','g_row_clean');
	$grid->addLink(0,'myclass','data.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=edit&v_search=&dateiname=&mode=', 'edit');
	#$grid->addFileList(5,'myclass','myclass2', $updir,$objConfig->uploadVirtualPath(),'#id#');
	$updir = $objConfig->uploadPath();
	$grid->addFileList(5,'myclass','myclass2', $updir,$updirVirtual ,'#id#');
	#$grid->addFileList(5,'myclass','myclass2', $updir,'asdfasdfasdf' ,'#id#');

	$grid->addGlobalReplacement('#v_u#', $v_u);
 	$grid->addGlobalReplacement('#v_s#', $v_s);
 	$grid->addRecordReplacement('#id#', 0);
	$page->addContainer('adiandupdateform','MainAreaList',  $grid->build );
	#$page->positionContainerPercent("adiandupdateform", 10, 20,60);
	$page->positionContainerAbsolut("adiandupdateform", "TOP", "CENTER", 10, 10, 100,10);
 	$page->addPositionContainerAbsoluteOnWindowResize("adiandupdateform", "TOP", "CENTER", 10, 10, 100,10);
	$page->setGlobalVariables($v_s, $v_u);  

}
# =======================================================================================
#now else part  of security check
}else{
	#$page->addContent(  'permission denied'  );
	$page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# =======================================================================================

#$page->addContainer('adiandupdateform','MainAreaList',  "Test: " . $test );
$page->setEncoding('xhtml');
$page->initialize;
$page->display;

sub myTrim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}


# =======================================================================================
exit 0;