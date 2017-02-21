#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;

my $v_u = param("v_u");
my $v_s = param("v_s");
my $v_sort = param("v_sort");

my $v_acc_from = param("acc");

my $v_amount_in_sum;
my $v_amount_out_sum;

my $db;
my $db2;
my $sql;
my $sql2;
my $sql_string;
my $sql_string_1;
my $sql_string_2;
my $sql_string_3;
my $sql_prio;
my @zeile = ();

my @date = ();
my $x;
my $y;

do "invest_header.pl";
do "../includes/server_location.pl";
do "../includes/the_base_db_connect.pl";
do "investment_db_connect.pl";

header($v_u,$v_s);

if (checklogin($v_u,$v_s) eq 'yes')
{
# ------------------ anfang innerer block mit permission ------------
print "\n";


print ' <script language ="JavaScript"> 
 function action_opener(id)
 {
        window.open("http://www.wallstreet-online.de/si/?k="+id+"","Actions","menubar=no,scrollbars=yes,resizeable=yes");
        
 };
 </script>';




print '<center>';


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";



$db2 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string = "

SELECT DISTINCT date_of_price
FROM investment_companies_tracker
order by date_of_price desc
LIMIT 0 , 11

";

$sql = $db->prepare($sql_string);

$sql->execute();

$x = 0;
while(@zeile=$sql->fetchrow_array())
{
	$date[$x] = $zeile[0];
	$x = $x + 1;
};	

$sql->finish;

$sql_string = "

SELECT  distinct

com.name,
com.wkn,
com.isin,

(
( CASE WHEN((t1.price - t2.price)/t2.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t2.price - t3.price)/t3.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t3.price - t4.price)/t4.price)  > 0 THEN 1 ELSE 0 end ) 

) as x_ges,

round(
(
((t1.price - t2.price)/t1.price) +
((t2.price - t3.price)/t2.price) +
((t3.price - t4.price)/t3.price) 

) 
* 100
) as d_ges,

( CASE WHEN((t1.price - t2.price)/t2.price)  > 0 THEN 1 ELSE 0 end ) as x1,
( CASE WHEN((t2.price - t3.price)/t3.price)  > 0 THEN 1 ELSE 0 end ) as x2,
( CASE WHEN((t3.price - t4.price)/t4.price)  > 0 THEN 1 ELSE 0 end ) as x3




FROM 

investment_companies_tracker t1, 
investment_companies_tracker t2,
investment_companies_tracker t3,
investment_companies_tracker t4,
investment_companies com

WHERE 
com.name <> 'x' and 
com.id = t1.id_base and
t1.id_base = t2.id_base and 
t1.id_base = t3.id_base and
t1.id_base = t4.id_base 

and t1.date_of_price = '$date[0]'
and t2.date_of_price = '$date[1]'
and t3.date_of_price = '$date[2]'
and t4.date_of_price = '$date[3]'


and com.id not in (331,
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

and com.name <> 'x'

order by ";


$sql_string_1 = $sql_string . "
	x_ges desc,
	d_ges desc,
	x1 desc,
	x2 desc,
	x3 desc
	

	 limit 0, 15";


$sql_string_2 = $sql_string . "
	
	d_ges desc,
	x1 desc,
	x2 desc,
	x3 desc
	

	 limit 0, 15";

$sql_string_3 = $sql_string . "
		
	x1 desc,
	x2 desc,
	x3 desc
	

	limit 0,15";

# ----------------------------------------------------------------------

$sql_prio = "delete from investment_prios";
$sql = $db->prepare($sql_prio);
$sql->execute();
$sql->finish;
# ----------------------------------------------------------------------
print "<table><tr><td>";





$sql = $db->prepare($sql_string_1);

$sql->execute();

print "<table>";
print "<tr>";
print "<td><b>name - NACH KONSTANZ X-GES</b></td>"; 
print "<td><b>wkn</b></td>"; 
print "<td><b>isin</b></td>"; 
print "</tr>";

$v_amount_in_sum = 0;
$v_amount_out_sum = 0;
$x = 15;
while(@zeile=$sql->fetchrow_array())
{
	
$sql_prio = "insert into investment_prios (position, a_name, wkn) values (".$x .",'" . $zeile[0] ."','" . $zeile[1] ."' )";
$sql2 = $db2->prepare($sql_prio);
$sql2->execute();
$sql2->finish;

	
print "<tr>";
print "<td> $zeile[0] &nbsp;</td>";
print '<td onclick="action_opener(\''.$zeile[1].'\')" ><b>'.$zeile[1].'&nbsp;</b></td>';
print '<td onclick="action_opener(\''.$zeile[2].'\')" ><b>'.$zeile[2].'&nbsp;</b></td>';
print "</tr>";
$x = $x - 1;
};
print "</table>";

$sql->finish;
# ----------------------------------------------------------------------
print "</td><td>";


$sql = $db->prepare($sql_string_2);

$sql->execute();

print "<table>";
print "<tr>";
print "<td><b>name - NACH DELTA GESAMT </b></td>"; 
print "<td><b>wkn</b></td>"; 
print "<td><b>isin</b></td>"; 
print "</tr>";

$v_amount_in_sum = 0;
$v_amount_out_sum = 0;
$x = 15;
while(@zeile=$sql->fetchrow_array())
{
	
$sql_prio = "insert into investment_prios (position, a_name, wkn) values (".$x .",'" . $zeile[0] ."','" . $zeile[1] ."' )";
$sql2 = $db2->prepare($sql_prio);
$sql2->execute();
$sql2->finish;

	
print "<tr>";
print "<td> $zeile[0] &nbsp;</td>";
print '<td onclick="action_opener(\''.$zeile[1].'\')" ><b>'.$zeile[1].'&nbsp;</b></td>';
print '<td onclick="action_opener(\''.$zeile[2].'\')" ><b>'.$zeile[2].'&nbsp;</b></td>';
print "</tr>";
$x = $x - 1;
};
print "</table>";

$sql->finish;
# ----------------------------------------------------------------------
print "</td></tr><tr><td>";


$sql = $db->prepare($sql_string_3);

$sql->execute();

print "<table>";
print "<tr>";
print "<td><b>name - NACH X1 - X3</b></td>"; 
print "<td><b>wkn</b></td>"; 
print "<td><b>isin</b></td>"; 
print "</tr>";

$v_amount_in_sum = 0;
$v_amount_out_sum = 0;
$x = 15;
while(@zeile=$sql->fetchrow_array())
{
	
$sql_prio = "insert into investment_prios (position, a_name, wkn) values (".$x .",'" . $zeile[0] ."','" . $zeile[1] ."' )";
$sql2 = $db2->prepare($sql_prio);
$sql2->execute();
$sql2->finish;

	
print "<tr>";
print "<td> $zeile[0] &nbsp;</td>";
print '<td onclick="action_opener(\''.$zeile[1].'\')" ><b>'.$zeile[1].'&nbsp;</b></td>';
print '<td onclick="action_opener(\''.$zeile[2].'\')" ><b>'.$zeile[2].'&nbsp;</b></td>';
print "</tr>";
$x = $x - 1;
};
print "</table>";

$sql->finish;
# ----------------------------------------------------------------------
# ergebnistabelle machen
print "</td><td>";


$sql_string = " 

SELECT sum( position ) AS positionx, a_name, wkn
FROM investment_prios
GROUP BY a_name, wkn
ORDER BY positionx DESC  

";




$sql = $db->prepare($sql_string);

$sql->execute();

print "<table>";
print "<tr>";
 
print "<td><b>name - GESAMTPERFORMANCE</b></td>"; 
print "<td><b>wkn</b></td>"; 
print "<td><b>isin</b></td>"; 
print "</tr>";


while(@zeile=$sql->fetchrow_array())
{

	
print "<tr>";

print "<td> $zeile[1] &nbsp;</td>";
print '<td onclick="action_opener(\''.$zeile[2].'\')" ><b>'.$zeile[2].'&nbsp;</b></td>';
#print '<td onclick="action_opener(\''.$zeile[2].'\')" ><b>'.$zeile[2].'&nbsp;</b></td>';
print '<td  >&nbsp;</b></td>';
print "</tr>";

};
print "</table>";

$sql->finish;


# ----------------------------------------------------------------------
print "</td></tr></table>";

$db->disconnect;

# ------------------ ende innerer block mit permission ------------

}
else
{
print 'permission denied'; 	
};


exit 0;