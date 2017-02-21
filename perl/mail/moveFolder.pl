#!/usr/bin/perl


require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DbConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/DataAccessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Page.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Table.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Grid.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/AdminBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailBusinessLayer.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Form.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/PageConfig.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/Navigation.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailSender.pm';
require '/var/www/vhosts/alex-admin.net/httpdocs/alex-admin/live/perl/classes/MailParser.pm';



# =======================================================================================
my @arr;
my @inner;
my $test;
my $page = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
my $objDataBusinessLayer = DataBusinessLayer->new();
my $objNavigation = Navigation->new();
my $objConfig = PageConfig->new();

my $v_second = (localtime())[0];
my $v_minute = (localtime())[1];
my $v_hour = (localtime())[2];
my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5] + 1900;
my $random;
my $searchForm;

my $timestamp = $v_year . "-" . $v_month . "-" . $v_day . "-" . $v_hour . "-" . $v_minute . "-" . $v_second ;
# =======================================================================================
# ToDo
# - mail needs button to load mails
# - body needs on load event that triggers getMails the first time
# - getMails triggers also ajax getNewMails()
# - timout loop to trigger getNewMails()
# - siehe artiekl append-child-dom-javascript.pdf
#
#
#
# =======================================================================================

my $v_u = param("v_u");
my $v_s = param("v_s");

# =======================================================================================
$page->setTitle($objConfig->get("page-title"));

$page->addStyleSheet($objConfig->cssPath() . 'basicStyle.css');
$page->addStyleSheet($objConfig->cssPath() . 'classes.css');
$page->addStyleSheet($objConfig->cssPath() . 'mail.css');
$page->addJavaScript($objConfig->jsPath() . 'classes.js');
$page->addJavaScript($objConfig->jsPath() . 'ajax.js');
$page->addJavaScript($objConfig->jsPath() . 'mail.js');

# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# =======================================================================================
# content with security


   $page->addContainer('navigation','navigation',$objNavigation->get($v_u, $v_s,"mail")  );
   $page->positionContainerAbsolut("navigation", "TOP", "LEFT", 5, 5, 5,1);

   $searchForm = "from folder: " . $page->getDropdownEditable('fromFolderId','','mail','folder','1', $v_u,$v_s);
   $searchForm .= "&nbsp;&nbsp;&nbsp;&nbsp;to folder: " . $page->getDropdownEditable('toFolderId','','mail','folder','1', $v_u,$v_s);
   $searchForm .= " " . $page->getButton( '', '', 'move folder', 'moveFolder()');

   $page->addContainer('searchFormId','searchForm',  $searchForm);
   $page->positionContainerAbsolut("searchFormId", "TOP", "LEFT", 100, 100, 200,100);



   #$page->setBodyOnLoad("getMailsOnLoad(\"./ajaxLoadExistingMail.pl?category=unread&nothing=".$timestamp ."\", \"./ajaxLoadExistingMail.pl?category=read&nothing=".$timestamp ."\", \"./ajaxLoadMail.pl\", \"mailFormId\");");


# =======================================================================================
#now else part  of security check
}else{
   #$page->addContent(  'permission denied'  );
   $page->jumpToPage("../admin/login.pl");
}
#end  part  of security check
# =======================================================================================

$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0