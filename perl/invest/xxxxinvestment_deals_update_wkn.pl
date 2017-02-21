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

my $wkn;
my $isn;
my $symbol;

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


do "the_base_header.pl";
do "the_base_db_connect.pl";




header("","");





# ------------------ anfang innerer block mit permission ------------


# ---------------------------prepare update  form ----------------------------





$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

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

$get_html =~ m/Letzter Kurs(.*)TABLE/si;

$get_html = "$1";

# --------------
$wkn = "$1";
$wkn =~ m/WKN:(.*)rowSpan/si;
$wkn = "$1";
$wkn =~ s/\<TD width=100>//g;
$wkn =~ s/\<\/TD>//g;
$wkn =~ s/\<\/B>//g;
$wkn =~ s/\<B>//g;
$wkn =~ s/\<TD>//g;
$wkn =~ s/width=100//g;
$wkn =~ s/>//g;
$wkn =~ s/width=15//g;

print '<br>AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA<br>';
print $wkn;
print '<br>BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB<br>';

$isn = "$1";
$symbol = "$1";

# --------------

$get_html =~ m/<b>(.*)<font/si;
$get_html = "$1";


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
$sql_string2 = $sql_string2 . '"' . $get_html . '")' ;

#print $sql_string2;

#$db2 = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
#$sql2 = $db2->prepare($sql_string2);
#$sql2->execute();
#$sql2->finish;
#$db2->disconnect;




# ------------------------------------------------------------


};


$sql->finish;
$db->disconnect;



do "the_base_footer.pl";


# ------------------ ende innerer block mit permission ------------



exit 0;
