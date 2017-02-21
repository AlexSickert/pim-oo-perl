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

#=======================================================================================

my @formValuesBeforeSave;
my $action = param("action");
my $id = param("id");
my $messages;

my $v_u = param("v_u");
my $v_s = param("v_s");

my $comment = param("comment");
my $title = param("title");
my $urgent = param("urgent");
my $important = param("important");
my $category = param("category");

my $mode = param("mode");
my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];
my $v_year_short = (localtime())[5];
my $newId;
my $form = "";

# =======================================================================================

if (! defined($action)){ $comment = "";};
if (! defined($comment)){ $comment = "";};
if (! defined($title)){ $title = "";};
if (! defined($urgent)){ $urgent = "";};
if (! defined($important)){ $important = "";};
if (! defined($category)){ $category = "";};
if (! defined($mode)){ $mode = "";};

# ===================================================

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){

# =======================================================================================


   # =======================================================================================
   #save existing record
   if($action eq 'edit_save'){
      $objDataBusinessLayer->updateExistingToDo( $id,$category,$important, $urgent, $title, $comment);
   }
   # =======================================================================================
   # save new record
   if($action eq 'new_save'){
     # $category,$important, $urgent, $title, $comment
     $objDataBusinessLayer->insertIntoToDo($category,$important, $urgent, $title, $comment);   
   }

   # save data if necessary

   # deleteToDo
   if($action eq 'delete' ){
      $objDataBusinessLayer->deleteToDo($id);
   }


   
   if($action eq 'edit' || $action eq 'new'){

      # id ,category, important, urgent, title, comment
      @formValuesBeforeSave = $objDataBusinessLayer->getToDoById($id);

      if($important ne ''){
         $formValuesBeforeSave[2] = $important;
      }

      if($urgent ne ''){
         $formValuesBeforeSave[3] = $urgent;
      }

      $objForm = Form->new();
      $objForm ->addInput(1, 'sheet_year','f_input','category',$formValuesBeforeSave[1]);
      $objForm ->addInput(1, 'important','f_input','important',$formValuesBeforeSave[2]);
      $objForm ->addInput(1, 'urgent','f_input','urgent',$formValuesBeforeSave[3]);
      $objForm ->addInput(1, 'title','f_input','title',$formValuesBeforeSave[4]);
      $objForm ->addArea(1, 'comment','data_todo_area','comment',$formValuesBeforeSave[5]);

      $objForm ->addButton(2, 'savebutton','f_databutton','save','document.myform.submit();');
      $objForm ->addHidden('id',$formValuesBeforeSave[0]);
      $objForm ->addHidden('v_u',$v_u);
      $objForm ->addHidden('v_s',$v_s);
      $objForm ->addHidden('v_folder',$id);
      $objForm ->addHidden('action', $action . '_save');
      $page->addContainer('MainAreaToDo','MainAreaToDo', $objForm->getForm('todo.pl'));
      $page->positionContainerAbsolut("MainAreaToDo", "CENTER", "CENTER", 100, 100, 100,100);

   }else{
      # ===== table hold 4 parts - in 3 lines and 3 cols
      my $objTable = Table->new();

      my $grid1 = Grid->new();
      my $grid2 = Grid->new();
      my $grid3 = Grid->new();
      my $grid4 = Grid->new();
   
      my @arr1 = $objDataBusinessLayer->getToDoByCategory('yes', 'yes');
      my @arr2 = $objDataBusinessLayer->getToDoByCategory('yes', 'no');
      my @arr3 = $objDataBusinessLayer->getToDoByCategory('no', 'yes');
      my @arr4 = $objDataBusinessLayer->getToDoByCategory('no', 'no');
   
      $grid1->setContent(@arr1);
      $grid1->addHeader($page->getLink('','./todo.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new&important=yes&urgent=yes','new'));
      $grid1->addHeader('&nbsp;');
      $grid1->setDefaultClass('g_table','g_header','g_row_1','g_row_2');
      $grid1->addLink(0,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=edit', 'edit'); 
      $grid1->addLink(3,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=delete', 'del');    
      $grid1->addGlobalReplacement('#v_u#', $v_u);
      $grid1->addGlobalReplacement('#v_s#', $v_s);
      $grid1->addRecordReplacement('#id#', 0);


      $grid2->setContent(@arr2);
      $grid2->addHeader($page->getLink('','./todo.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new&important=yes&urgent=no','new'));
      $grid2->addHeader('&nbsp;');
      $grid2->setDefaultClass('g_table','g_header','g_row_1','g_row_2');
      $grid2->addLink(0,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=edit', 'edit');  
      $grid2->addLink(3,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=delete', 'del'); 
      $grid2->addGlobalReplacement('#v_u#', $v_u);
      $grid2->addGlobalReplacement('#v_s#', $v_s);
      $grid2->addRecordReplacement('#id#', 0);

      $grid3->setContent(@arr3);
      $grid3->addHeader($page->getLink('','./todo.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new&important=no&urgent=yes','new'));
      $grid3->addHeader('&nbsp;');
      $grid3->setDefaultClass('g_table','g_header','g_row_1','g_row_2');
      $grid3->addLink(0,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=edit', 'edit');  
      $grid3->addLink(3,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=delete', 'del'); 
      $grid3->addGlobalReplacement('#v_u#', $v_u);
      $grid3->addGlobalReplacement('#v_s#', $v_s);
      $grid3->addRecordReplacement('#id#', 0);

      $grid4->setContent(@arr4);
      $grid4->addHeader($page->getLink('','./todo.pl?v_u='.$v_u.'&v_s='.$v_s.'&action=new&important=no&urgent=no','new'));
      $grid4->addHeader('&nbsp;');
      $grid4->setDefaultClass('g_table','g_header','g_row_1','g_row_2');
      $grid4->addLink(0,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=edit', 'edit');
      $grid4->addLink(3,'myclass','todo.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=delete', 'del');   
      $grid4->addGlobalReplacement('#v_u#', $v_u);
      $grid4->addGlobalReplacement('#v_s#', $v_s);
      $grid4->addRecordReplacement('#id#', 0);

      $objTable->addRow();
      $objTable->addField('','',"&nbsp;"  );
      $objTable->addField('','',"important");
      $objTable->addField('','',"less important" );
      $objTable->addRow();
      $objTable->addField('','',"urgent"  );
      $objTable->addField('','',$grid1->build);
      $objTable->addField('','',$grid3->build );
      $objTable->addRow();
      $objTable->addField('','',"less urgent"  );
      $objTable->addField('','',$grid2->build);
      $objTable->addField('','',$grid4->build);

      $page->addContent(  $page->getContainer('MainAreaToDo', 'MainAreaToDo', $objTable->getTable()  ));
      $page->positionContainerAbsolut("MainAreaToDo", "TOP", "CENTER", 10, 10, 100,10);

      #$page->addPositionContainerAbsoluteOnWindowResize

   }


#=======================================================================================
#now else part  of security check
}else{

   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
#=======================================================================================

$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"data")  );

$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);


$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0
