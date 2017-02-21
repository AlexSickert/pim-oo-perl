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


#do "the_base_header.pl";
#do "the_base_db_connect.pl";

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




# ------------------ anfang innerer block mit permission ------------


# ---------------------------prepare update  form ----------------------------





# $db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

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

# ------------  hier dann für jede wkn den wert rausziehen

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

# $db2 = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

$db2 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql2 = $db2->prepare($sql_string2);
$sql2->execute();
$sql2->finish;
$db2->disconnect;




# ------------------------------------------------------------


};


$sql->finish;
$db->disconnect;



print '<br>------------------ START VON AKTIEN TRACKER  ------------<br>';
print '<br>------------------ START VON AKTIEN TRACKER  ------------<br>';
print '<br>------------------ START VON AKTIEN TRACKER  ------------<br>';
print '<br>------------------ START VON AKTIEN TRACKER  ------------<br>';



# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------


# $db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql_string =  '

SELECT  id, wkn, isin
FROM  investment_companies
WHERE papier_art <>  "" and (isin <> "" or wkn <> "")



and id not in (331,
4864,
5904,
4783,
4780,
1180,
5148,
107,
5054,
1425,
1921,
4547,
4974,
5103,
351,
1197,
5104,
5037,
5249,
5134,
5093,
3454,
5048,
5256,
1469,
4967,
1178,
5106,
5264,
5281,
5735,
5141,
4982,
5149,
5034,
5076,
1462,
489,
1216,
1520,
1196,
4859,
1194,
1490,
4766,
5159,
4765,
5223,
5809,
5142,
5111,
5090,
4820)

';
 

 

$sql = $db->prepare($sql_string);


$sql->execute();



while(@zeile=$sql->fetchrow_array())
{

# ------------  hier dann für jede wkn den wert rausziehen

# 1. per post oder get wert html ermitteln

if($zeile[2] eq '')
{
	$wkn_isn = $zeile[1];
}
else
{
	$wkn_isn = $zeile[2];
};
	
	
$get_html = get('http://www.wallstreet-online.de/si/?k=' . $wkn_isn);

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

# 2a. check ob wert auch numer isch ist 


# 3. sql erstellen und eintragen



$sql_string2 = 'insert into investment_companies_tracker (   
id_base ,
date_of_price,
price) values  (';


$sql_string2 = $sql_string2 . '"' . $zeile[0] . '",' ;
$sql_string2 = $sql_string2 . '"' . $v_date_of_price . '",' ;
$sql_string2 = $sql_string2 . '' . $get_html . ')' ;


print $sql_string2;

print '<br>--------------------------------------------------------------------<br>';

# $db2 = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";


$db2 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql2 = $db2->prepare($sql_string2);
$sql2->execute();


$sql2->finish;
$db2->disconnect;




# ------------------------------------------------------------


};


$sql->finish;


$sql = "delete from investment_companies_tracker where price = 0 ";
$sql = $db->prepare($sql);
$sql->execute();
$sql->finish;

$db->disconnect;

# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------
# ------------------ ENDE VON AKTIEN TRACKER  ------------


print "
<script language ='JavaScript' >
window.location ='./mycronjob-loop.cgi?v_u=".$v_u."&v_s=".$v_s."' ;
</script>";

do "the_base_footer.pl";

exit 0;
