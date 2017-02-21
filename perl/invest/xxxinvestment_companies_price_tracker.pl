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


do "the_base_header.pl";
do "the_base_db_connect.pl";




header("","");





# ------------------ anfang innerer block mit permission ------------


# ---------------------------prepare update  form ----------------------------





$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

$sql_string =  '

SELECT  id, wkn, isin
FROM  investment_companies
WHERE papier_art <>  "" and (isin <> "" or wkn <> "")

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

$get_html =~ m/<b>(.*)<font/si;
$get_html = "$1";


$get_html =~ s/,/./g;

# 2a. check ob wert auch numer isch ist 


# 3. sql erstellen und eintragen



$sql_string2 = 'insert into investment_companies_tracker (   
id_base ,
date_of_price,
price) values  (';


$sql_string2 = $sql_string2 . '"' . $zeile[0] . '",' ;
$sql_string2 = $sql_string2 . '"' . $v_date_of_price . '",' ;
$sql_string2 = $sql_string2 . '"' . $get_html . '")' ;

print '<br>----------------------<br>';
print $sql_string2;

$db2 = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
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



do "the_base_footer.pl";


# ------------------ ende innerer block mit permission ------------



exit 0;
