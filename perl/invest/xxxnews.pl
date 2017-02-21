#!/usr/bin/perl

use lib "/www/htdocs/w006c084/cgi-bin/live/classes";
use strict;
use CGI qw(:standard);
use LWP::Simple;
use warnings;
use Page;
use Table;
use Grid;
use AdminBusinessLayer;
use DataBusinessLayer;
use Form;

# =======================================================================================
do "../includes/server_location.pl";
do "../includes/header.pl";
do "../includes/the_base_db_connect.pl"; # das hier muss raus !!!!!
do "../includes/settings.pl";
# =======================================================================================
my @arr;
my @inner;
my $page = Page->new();
my $objAdminBusinessLayer = AdminBusinessLayer->new();
$objAdminBusinessLayer->setServer(  serverloc()   );

$page->addStyleSheet('../../../'.serverloc().'/style/basicstyle.css');
$page->addStyleSheet('../../../'.serverloc().'/style/classes.css');
$page->addStyleSheet('../../../'.serverloc().'/style/invest.css');
$page->addJavaScript('../../../'.serverloc().'/javascript/classes.js');

my $v_u = param("v_u");
my $v_s = param("v_s");
my $mode = param("mode");
my $section = param("section");
my $get_html;
my @linkArr;
my $linkListAktuell;
my $linkListMostRead;
my $linkListAnalyst;
my $get_html_all;
my $table;
# =======================================================================================
# first check security
if($objAdminBusinessLayer->checkLogin($v_u,$v_s)){
# =======================================================================================
# add if necessary the navigation
if($mode eq '' || $mode eq 'full'){
   $page->addContainer('noname','Header',modulHeader($v_u,$v_s, 'invest') );
}else{
   $page->addContainer('noname','Header',closeButton($v_u,$v_s) );
}

# =======================================================================================
if($section eq '' or $section eq 'basic'){
   $get_html_all = get('http://www.finanznachrichten.de');	
   $get_html = $get_html_all;
   $get_html =~ m/nbsp;Aktuelle Nachrichten auf(.*)FinanzNachrichten\.de-Startseite/si;		
   $get_html = "$1";	
   $get_html =~ m/Analysten-Berichte(.*)<\/table/si;
   $get_html = "$1";	
   
   foreach my $currLink ($page->stripLinks($get_html, 'http://www.finanznachrichten.de','blank') ) {
      $linkListAktuell .= $currLink . "<br />----------------------------------------<br />";
   }
   
   $get_html = $get_html_all;
   $get_html =~ m/Meistgelesene Nachrichten auf FinanzNachrichten(.*)Meistgelesene Aktien-Empfehlungen auf FinanzNachrichten/si;		
   $get_html = "$1";	
   $get_html =~ m/<table(.*)<\/table/si;
   $get_html = "$1";	

   foreach my $currLink ($page->stripLinks($get_html, 'http://www.finanznachrichten.de','blank') ) {
      $linkListMostRead .= $currLink . "<br />----------------------------------------<br />";
   }

   $get_html = $get_html_all;
   $get_html =~ m/Meistgelesene Aktien-Empfehlungen auf FinanzNachrichten(.*)Aktuelle Nachrichten auf FinanzNachrichten/si;		
   $get_html = "$1";	
   $get_html =~ m/<table(.*)<\/table/si;
   $get_html = "$1";	

   foreach my $currLink ($page->stripLinks($get_html, 'http://www.finanznachrichten.de','blank') ) {
      $linkListAnalyst .= $currLink . "<br />----------------------------------------<br />";
   }
}

if($section eq 'special'){

   $get_html_all = get('http://www.finanzen.net/news/news_suchergebnis.asp?RubrikNr=7');	
   $get_html = $get_html_all;
   $get_html =~ m/Wachstumswerte:(.*)<\/table/si;		
   $get_html = "$1";	
   $get_html =~ m/class(.*)textNormalRot/si;
   $get_html = "$1";	
   
   foreach my $currLink ($page->stripLinks($get_html, 'http://www.finanzen.net','blank') ) {
      $linkListAktuell .= $currLink . "<br />----------------------------------------<br />";
   }
   
   $get_html_all = '';   
   $get_html_all = get('http://www.finanzen.net/news/news_suchergebnis.asp?RubrikNr=358');	
   $get_html = $get_html_all;	
   $get_html =~ m/Nebenwerte:(.*)<\/table/si;		
   $get_html = "$1";		
   $get_html = "$1";	
   $get_html =~ m/class(.*)textNormalRot/si;
   $get_html = "$1";		

   foreach my $currLink ($page->stripLinks($get_html, 'http://www.finanzen.net','blank') ) {
      $linkListMostRead .= $currLink . "<br />----------------------------------------<br />";
   }

   $get_html_all = get('http://www.finanzen.net/news/news_suchergebnis.asp?RubrikNr=359');
   $get_html = $get_html_all;
   $get_html =~ m/Pressemitteilungen:(.*)<\/table/si;	
   $get_html = "$1";	
   $get_html =~ m/class(.*)textNormalRot/si;
   $get_html = "$1";	

   foreach my $currLink ($page->stripLinks($get_html, 'http://www.finanzen.net','blank') ) {
      $linkListAnalyst .= $currLink . "<br />----------------------------------------<br />";
   }
}

$table = Table->new();
$table->addRow();
if($section eq '' or $section eq 'basic'){
   $table->addField('','' ,'aktuell');
   $table->addField('','' ,'meist gelesen');
   $table->addField('','' ,'empfelungen');
}

if($section eq 'special'){
   $table->addField('','' ,'Wachstumswerte');
   $table->addField('','' ,'Nebenwerte');
   $table->addField('','' ,'Pressemitteilungen');
}

$table->addRow();
$table->addField('','' , $linkListAktuell);
$table->addField('','' , $linkListMostRead);
$table->addField('','' , $linkListAnalyst);

$page->addContainer('noname','MainAreaNews',$table->getTable);
# =======================================================================================
#now else part  of security check
}else{
   $page->addContent(  'permission denied'  );
}
#end  part  of security check
# =======================================================================================

$page->setEncoding('xhtml');
$page->initialize;
$page->display;

exit 0
