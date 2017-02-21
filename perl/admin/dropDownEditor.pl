#!/usr/bin/perl


use strict;
use CGI qw(:standard);
use warnings;

eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/LanguageBusinessLayer.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm`;
eval ` cat /var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm`;

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

#=======================================================================================

my @formValuesBeforeSave;
my $action = param("action");
my $id = param("id");
my $messages;
my $v_u = param("v_u");
my $v_s = param("v_s");
my $modul = param("modul");
my $drop_down_name = param("drop_down_name");
my $drop_down_value = param("drop_down_value");
my $drop_down_text = param("drop_down_text");

# =======================================================================================

if (! defined($id)){ $id = "";};
if (! defined($drop_down_name)){ $drop_down_name = "";};
if (! defined($drop_down_value)){ $drop_down_value = "";};
if (! defined($drop_down_text)){ $drop_down_text = "";};
if (! defined($modul)){ $modul = "";};
#=======================================================================================

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){

# =======================================================================================
# add if necessary the navigation

$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"admin")  );

# =======================================================================================
#save existing record
if($action eq 'edit_save'){
   $messages = $objAdminBusinessLayer->updateDropDown( $id, $drop_down_value , $drop_down_text );
}

# =======================================================================================
# save new record
if($action eq 'new_save'){

   $messages = $objAdminBusinessLayer->insertDopDown($modul, $drop_down_name, $drop_down_value , $drop_down_text );
}

# =======================================================================================
# create array with data for form
if($action eq 'edit'){
   @formValuesBeforeSave = $objAdminBusinessLayer->getDropDownById($id);

}

# =======================================================================================
# if we need the form
if($action eq 'edit' || $action eq 'new'){

# drop_down_value, drop_down_text

   $objForm = Form->new();
   $objForm ->addInput(1, 'drop_down_value','f_input','drop_down_value',$formValuesBeforeSave[1]);
   $objForm ->addInput(1, 'drop_down_text','f_input','drop_down_text',$formValuesBeforeSave[2]);
   
   $objForm ->addButton(2, 'savebutton','f_databutton','save','document.myform.submit();');
   $objForm ->addHidden('id',$formValuesBeforeSave[0]);
   $objForm ->addHidden('v_u',$v_u);
   $objForm ->addHidden('v_s',$v_s);
   $objForm ->addHidden('modul',$modul);
   $objForm ->addHidden('drop_down_name',$drop_down_name);
   $objForm ->addHidden('action', $action . '_save');
   $page->addContainer('adiandupdateform','MainAreaTimesheet', $objForm->getForm('dropDownEditor.pl'));
}

# =======================================================================================
# if table should be displayed

if( $action ne 'edit' && $action ne 'new'){
   
   my $grid = Grid->new();
   my @arr2;
   
   @arr2 = $objAdminBusinessLayer->getDropDown($modul, $drop_down_name);
   
   $grid->setContent(@arr2);
   $grid->addHeader($page->getLink('','./dropDownEditor.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new&modul='.$modul.'&drop_down_name='.$drop_down_name,'new'));
   $grid->addHeader('drop_down_value');
   $grid->addHeader('drop_down_text'); 

   $grid->setDefaultClass('g_table','g_header','g_row_1','g_row_2');
   $grid->addLink(0,'myclass','dropDownEditor.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=edit&modul='.$modul.'&drop_down_name='.$drop_down_name, 'edit');   
   $grid->addGlobalReplacement('#v_u#', $v_u);
   $grid->addGlobalReplacement('#v_s#', $v_s);
   $grid->addRecordReplacement('#id#', 0);
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

#$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"data")  );
$page->positionContainerPercent("navigation", 1, 1,100);
$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0


