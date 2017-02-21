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
   print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
print '
<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" 
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" > 
<head> 
<title>One Hundred percent height divs</title> 
<style type="text/css" media="screen"> 
body { 
margin:0; 
padding:0; 
height:100%; /* this is the key! */ 
background:#ff0000; 
} 
#navi { 
position:absolute; 
left:0; 
top:0%; 
padding:0; 
width:100%; 
height:10%; /* works only if parent container is assigned a height value */ 
color:#333; 
background:#eaeaea; 
border:1px solid #333; 
} 
#sqlstatement { 
position:absolute; 
left:0; 
top:10%; 
padding:0; 
width:100%; 
height:40%; /* works only if parent container is assigned a height value */ 
color:#333; 
background:#eaeaea; 
border:1px solid #333; 
} 
#execute { 
position:absolute; 
left:0; 
top:50%; 
padding:0; 
width:100%; 
height:5%; /* works only if parent container is assigned a height value */ 
color:#333; 
background:#eaeaea; 
border:1px solid #333; 
} 
#result { 
position:absolute; 
left:0; 
top:55%; 
padding:0; 
width:100%; 
height:45%; /* works only if parent container is assigned a height value */ 
color:#333; 
background:#eaeaea; 
border:1px solid #333; 
} 

</style> 
</head> 
<body> 
	<div id="navi"> 
		<p>top navi</p> 
	</div> 
	<div id="sqlstatement"> 
		<p class="top">sql statemet</p> 
	</div> 

	<div id="execute"> 
		<p>execute buttons</p> 
	</div> 
	<div id="result"> 
		<p class="top">result</p> 
	</div>
</body> 
</html> 
';
#=======================================================================================
#now else part  of security check
}else{
   	print "Content-type: text/html;Charset=iso-8859-1". "\n\n";
	print "login failed";
}
#end  part  of security check
#=======================================================================================
exit 0
