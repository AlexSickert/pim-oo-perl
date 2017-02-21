#!/usr/bin/perl
use strict;
use CGI qw(:standard);
use warnings;
use DBI;

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
# =======================================================================================
print  "Content-type: text/html;Charset=iso-8859-1". "\n\n"; 
# =======================================================================================
# ---------------------- REQUEST VARIABLES --------------------------------------------------
my $params = CGI->new();
my $v_s = $params->param("v_s");
my $v_u = $params->param("v_u");
my $t_s = $params->param("t_s");
my $div_id = $params->param("div_id");
my $action = $params->param("action");
my $parent = $params->param("parent");

if (defined $action ){
# und tu nochwas vernünftiges
}else{
   $action  = "";
}

# ---------------------- VARIABLES  ---------------------------------------------------------
my $objDBL = DataBusinessLayer->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s) eq 1 ){
# ---------------------- CODE---------------------------------------------------------


my $objDataBusinessLayer = DataBusinessLayer->new();
my @arr = $objDataBusinessLayer->getExplorerByParentId($parent);
my $y;
my $header;

my $child_div_id;
my $url;
my $onclick_string;
my @arrHeader ;

#-------------------------------------

if($parent eq '0'){
   $header = "root";
}else{
   @arrHeader = $objDataBusinessLayer->getExplorerGetHeader($parent);
   $header = $arrHeader[2];
}


if ($action eq ""){


$child_div_id = "explorer" . $parent;
$url =  "./ajaxExplorer.pl?action=clear&parent=" . $parent . "&div_id=" . $parent . "&v_u=" . $v_u . "&v_s=" . $v_s;

print "<div style='padding-bottom:5px'><span onclick='dataAjaxLoadExplorer(\"" . $url . "\",\"" . $child_div_id . "\")' ><b>-&nbsp;" . $header . "</b></span>&nbsp;<span onclick='prepareCutFolder(" . $parent . ")'>[<u>cut</u>]</span><span onclick='pasteFolderOrData(" . $parent . ")'>[<u>paste</u>]</span>[new Folder]<span onclick='dataNewData(\"" . $parent . "\")' >[<u>new Doc</u>]</span></div>";
print "<div id='xxx' >";

# load child elements from tree

my $hasElements = 0;

for $y (0.. $#arr){

   $child_div_id = "explorer" . $arr[$y][0];
   $url =  "./ajaxExplorer.pl?parent=" . $arr[$y][0] . "&div_id=" . $child_div_id . "&v_u=" . $v_u . "&v_s=" . $v_s;

   print "<div style='padding-left:50px; padding-bottom:5px' id='" . $child_div_id . "' ><span  onclick='dataAjaxLoadExplorer(\"" . $url . "\",\"" . $child_div_id . "\")' ><b>+&nbsp;" . $arr[$y][2]  . "</b></span>&nbsp;<span onclick='prepareCutFolder(" . $arr[$y][0] . ")'>[<u>cut</u>]</span><span onclick='pasteFolderOrData(" . $arr[$y][0] . ")'>[<u>paste</u>]</span></div>";
   $hasElements = 1;
}

if($hasElements == 0){
print "<div style='padding-left:50px' ><i>[no subfolders]</i></div>";
}

# load elements from the_list

if($parent ne '0'){

   @arr = $objDataBusinessLayer->getExplorerDataElements($arrHeader[3]);
 
   $hasElements = 0;

   for $y (0.. $#arr){

      $url =  "./data.pl?action=edit&id=" . $arr[$y][0] . "&v_u=" . $v_u . "&v_s=" . $v_s;

      print "<div style='padding-left:50px'><a href='" . $url  . "' target='#'>" . $arr[$y][1] . "</a>&nbsp;<span onclick='prepareCutData(" . $arr[$y][0] . "," . $parent . ")'>[<u>cut</u> ]</span><span onclick='prepareCopyData(" . $arr[$y][0] . ")'>[<u>copy</u>]</span></div>";
      $hasElements = 1;
   }

   if($hasElements == 0){
      print "<div style='padding-left:50px' ><i>[no data elements]</i></div>";
   }

}

print "</div>";

}else{
   $child_div_id = "explorer" . $parent;
   $url =  "./ajaxExplorer.pl?parent=" . $parent  . "&div_id=" . $parent . "&v_u=" . $v_u . "&v_s=" . $v_s;
   print "<div  id='" . $child_div_id . "' ><span  onclick='dataAjaxLoadExplorer(\"" . $url . "\",\"" . $child_div_id . "\")' ><b>+&nbsp;" . $header   . "</b></span>&nbsp;[paste]</div>";
}


# ---------------------- END OF CODE---------------------------------------------------------
}
exit 0;