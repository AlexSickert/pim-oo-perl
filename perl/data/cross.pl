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
my $linkString;
$v_year = $v_year + 1900;
$v_month = $v_month + 1;

#=======================================================================================
my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_action = param("v_action") ;
my $v_id = param("v_id");
my $v_parent_id =  param("v_parent_id");
my $v_description =  param("v_description");
my $v_list_ids =  param("v_list_ids");
my $v_p_id =  param("v_p_id");

#$v_u="haselmax";
#$v_s="716.543163232064";
#$v_p_id="0";
#$v_action = "insert";
#$v_list_ids = "1,2,3";
#$v_description = "adsfasdfasdfasdf";
#=======================================================================================

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'data.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){

    #-------------------------- new action input form ----------------------------------
    if ($v_action eq 'new_prepare' || $v_action eq 'update_prepare')
    {
        
        if($v_action eq 'new_prepare'){
            
        }
        
        if($v_action eq 'update_prepare'){
            my @zeile=$objDataBusinessLayer->prepareCross($v_id);
            $v_p_id = $zeile[1];
            $v_description = $zeile[2];
            $v_list_ids = $zeile[3];
        }
        $objForm = Form->new();   
        $objForm ->addInput(1, 'v_description','f_input','v_description',$v_description);
        $objForm ->addArea(1, 'v_list_ids','f_area_m','v_list_ids',$v_list_ids);
            
        if($v_action eq 'new_prepare'){
            $objForm ->addHidden('v_action','insert');
        }else{
            $objForm ->addHidden('v_action','update');
        }
        
        $objForm ->addButton(2, 'savebutton','f_databutton','save','sendMyForm();');
        $objForm ->addHidden('v_p_id',$v_p_id);
        $objForm ->addHidden('v_id',$v_id);
        $objForm ->addHidden('v_parent_id',$v_p_id);
        $objForm ->addHidden('v_s',$v_s);
        $objForm ->addHidden('v_u',$v_u);
        $page->addContainer('crossForm','crossForm',$objForm->getForm('cross.pl'));
        $page->positionContainerPercent("crossForm", 30, 30,100);
        
        
    }

# ======= insert table =================================================================
if ($v_action eq 'update')
{
    $objDataBusinessLayer->updateCross($v_parent_id, $v_description, $v_list_ids, $v_id);
};

# ======= insert table =================================================================
if ($v_action eq 'insert')
{

    $v_id = $objDataBusinessLayer->insertCross($v_p_id, $v_description, $v_list_ids);
};
# ======= show table =================================================================
if ($v_action ne 'new_prepare' && $v_action ne 'update_prepare'){

    my $grid = Grid->new();
    my @arr2;
    

    #  $v_p_id, $class, $baseLink
    $linkString = $objDataBusinessLayer->getCrossLinkString($v_p_id, 'MainAreaList', 'cross.pl?action=&v_s='.$v_s . '&v_u='. $v_u);

    @arr2 = $objDataBusinessLayer->getCrossByParentId($v_p_id);

    $grid->setContent(@arr2);
    $grid->addHeader($page->getLink('','./cross.pl?v_u='.$v_u.'&v_s='.$v_s.'&v_action=new_prepare&v_p_id='.$v_p_id,'new'));
    $grid->addHeader('parent');
    $grid->addHeader('description');
    $grid->addHeader('elements');
    $grid->addHeader('goto');
    $grid->setDefaultClass('g_table','g_header','g_row_clean','g_row_clean');
    $grid->addLink(0,'myclass','cross.pl?v_u=#v_u#&v_s=#v_s#&v_p_id=&v_id=#id#&v_action=update_prepare&mode=', 'edit');
    $grid->addLink(2,'myclass','cross.pl?v_u=#v_u#&v_s=#v_s#&v_p_id=#id#&action=edit&v_search=&dateiname=&mode=', '#descr#');
    $grid->addLink(3,'myclass','data.pl?v_u=#v_u#&v_s=#v_s#&id=#id#&action=cross&v_search=&dateiname=&mode=', 'show');
    $grid->addGlobalReplacement('#v_u#', $v_u);
    $grid->addGlobalReplacement('#v_s#', $v_s);
    $grid->addRecordReplacement('#id#', 0);
    $grid->addRecordReplacement('#descr#', 2);
    $grid->addRecordReplacement('#countchild#', 0);
    
    $page->addContainer('linkstring','MainAreaList', $linkString  );
    $page->positionContainerAbsolut("linkstring", "TOP", "CENTER", 100, 100, 100,10);
    $page->addContainer('adiandupdateform','MainAreaList',  $grid->build );
    #$page->positionContainerPercent("adiandupdateform", 30, 20,100);
    $page->positionContainerAbsolut("adiandupdateform", "TOP", "CENTER", 100, 100, 150,10);

}
#=======================================================================================
#now else part  of security check
}else{
   #$page->addContent(  'permission denied'  );
   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
#=======================================================================================

#$page->addContainer('adiandupdateform','MainAreaList',  "Test: " . $test );
$page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"data")  );
#$page->positionContainerPercent("navigation", 1, 1,100);
$page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0
