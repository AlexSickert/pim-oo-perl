#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;
use LWP::Simple;

my $db;
my $db2;
my $db3;
my $sql;
my $sql_string;
my $sql2;
my $sql_string2;
my $sql3;
my $sql_string3;
my $sql_string_check;
my @zeile = ();
my @zeile2 = ();
my @zeile3 = ();
my $get_html;
my $get_html_2;
my $wkn_isn;

my $v_line_value;
my $v_total_value;
my $v_total_value_purchases;
my $v_total_value_sales;
my $v_total_profit;
my $v_total_roi;


my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_insert = param("v_insert");
my $v_id = param("v_id");

my $v_wkn = param("v_wkn");
my $v_date_of_price ;
my $v_currency = param("v_currency");
my $v_currency_factor = param("v_currency_factor");
my $v_price = param("v_price");



my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_year = $v_year + 1900;
$v_month = $v_month + 1;

$v_date_of_price = $v_year . '-' . $v_month . '-' . $v_day;


do "invest_header.pl";
do "../includes/server_location.pl";
do "../includes/the_base_db_connect.pl";
do "investment_db_connect.pl";


if ($v_s eq '' && $v_u eq '')
{
header("","");
}
else
{
header($v_u,$v_s);
}



if (checklogin($v_u,$v_s) eq 'yes')
{

# ------------------ anfang innerer block mit permission ------------


# ---------------------------prepare update  form ----------------------------





$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql_string =  '
 SELECT  DISTINCT wkn, auto_kennung, currency_factor, currency
FROM investment_current_value
WHERE 
 wkn <> "88888888888888"
and wkn <> "33333"
and wkn <> "999999999"
and wkn <> "0"
and wkn <> "3"
and wkn <> "4"
and wkn <> "5"
and wkn <> "8"
and wkn <> "9"
and wkn <> "22"
AND wkn <>  "967740"

';
 

 

$sql = $db->prepare($sql_string);


$sql->execute();



while(@zeile=$sql->fetchrow_array())
{

# ------------  hier dann fr jede wkn den wert rausziehen

# 1. per post oder get wert html ermitteln

if($zeile[1] eq '')
{
	$wkn_isn = $zeile[0];
}
else
{
	$wkn_isn = $zeile[1];
};
	
	
$get_html = get('http://www.wallstreet-online.de/si/?k=' . $wkn_isn);
$get_html_2 = $get_html;
# 2. diesen html content bereinigen

$get_html =~ m/Letzter Kurs(.*)WKN/si;
$get_html = "$1";
$get_html =~ m/(.*)WKN/si;
$get_html = "$1";
$get_html =~ m/<b>(.*)<font/si;
$get_html = "$1";
#---- neu 2.4.06 -------------------

$get_html =~ m/s12b(.*)<img/si;
$get_html = "$1";
$get_html =~ m/<b>(.*)<\/b>/si;
$get_html = "$1";
#-----------------------------------
$get_html =~ s/\.//g;
$get_html =~ s/,/./g;

#------------------------------------------
# wenn leer dann 2. methode verwenden

if ($get_html eq ''){
  $get_html = $get_html_2;
  $get_html =~ m/Letzter Kurs(.*)ISIN/si;
  $get_html = "$1";
  $get_html =~ m/(.*)Local-Id/si;
  $get_html = "$1";
  $get_html =~ m/<b>(.*)<font/si;
  $get_html = "$1";
  $get_html =~ m/s12b(.*)<img/si;
  $get_html = "$1";
  $get_html =~ m/<b>(.*)<\/b>/si;
  $get_html = "$1";
  $get_html =~ s/\.//g;
  $get_html =~ s/,/./g;
}
#------------------------------------------

# 2a. check ob wert auch numer isch ist 


# 3. sql erstellen und eintragen



$sql_string2 = 'insert into investment_current_value (   
wkn ,
date_of_price,
currency ,
currency_factor , auto_kennung  ,
price) values  (';


$sql_string2 = $sql_string2 . '"' . $zeile[0] . '",' ;
$sql_string2 = $sql_string2 . '"' . $v_date_of_price . '",' ;
$sql_string2 = $sql_string2 . '"' . $zeile[3] . '",' ;
$sql_string2 = $sql_string2 . '"' . $zeile[2] . '",' ;
$sql_string2 = $sql_string2 . '"' . $zeile[1] . '",' ;
$sql_string2 = $sql_string2 . '' . $get_html . ')' ;

print '<br>----------------------<br>';
print $sql_string2;



$db2 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql2 = $db2->prepare($sql_string2);
$sql2->execute();
$sql2->finish;
$db2->disconnect;




# ------------------------------------------------------------


};


$sql->finish;
$db->disconnect;



print "
<script language ='JavaScript' >
window.location ='./investment_deals_actual_value.pl?v_u=".$v_u."&v_s=".$v_s."' ;
</script>";


do "the_base_footer.pl";



}
else
{
print 'permission denied'; 	
};


exit 0;
