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
my $sql;
my $sql_string;
my @zeile = ();

my @date = ();
my $x;



do "invest_header.pl";
do "../includes/server_location.pl";
do "../includes/the_base_db_connect.pl";
do "investment_db_connect.pl";


header($v_u,$v_s);

if (checklogin($v_u,$v_s) eq 'yes')
{


# ------------------ anfang innerer block mit permission ------------


print ' <script language ="JavaScript"> 
 function action_opener(id)
 {
        window.open("http://www.wallstreet-online.de/si/?k="+id+"","Actions","menubar=no,scrollbars=yes,resizeable=yes");
        
 };
 
 
 
 
 </script>';


print "\n";







print '<center>

<br><br>
<a href="investments_filter_01.pl?v_sort=x_ges&v_u='.$v_u.'&v_s='.$v_s.'">nach x_ges</a>
&nbsp;&nbsp;&nbsp;
<a href="investments_filter_01.pl?v_sort=d_ges&v_u='.$v_u.'&v_s='.$v_s.'">nach d_ges</a>
&nbsp;&nbsp;&nbsp;
<a href="investments_filter_01.pl?v_sort=x1x10&v_u='.$v_u.'&v_s='.$v_s.'">nach x1x10</a>
<br><br>
				
';


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


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

SELECT  

com.name,
com.wkn,


(
( CASE WHEN((t1.price - t2.price)/t2.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t2.price - t3.price)/t3.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t3.price - t4.price)/t4.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t4.price - t5.price)/t5.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t5.price - t6.price)/t6.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t6.price - t7.price)/t7.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t7.price - t8.price)/t8.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t8.price - t9.price)/t9.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t9.price - t10.price)/t10.price)  > 0 THEN 1 ELSE 0 end ) +
( CASE WHEN((t10.price - t11.price)/t11.price)  > 0 THEN 1 ELSE 0 end ) 
) as x_ges,

(
(
((t1.price - t2.price)/t1.price) +
((t2.price - t3.price)/t2.price) +
((t3.price - t4.price)/t3.price) +
((t4.price - t5.price)/t4.price) +
((t5.price - t6.price)/t5.price) +
((t6.price - t7.price)/t6.price) +
((t7.price - t8.price)/t7.price) +
((t8.price - t9.price)/t8.price) +
((t9.price - t10.price)/t9.price) +
((t10.price - t11.price)/t10.price) 
) 
* 100
) as d_ges,

( CASE WHEN((t1.price - t2.price)/t2.price)  > 0 THEN 1 ELSE 0 end ) as x1,
( CASE WHEN((t2.price - t3.price)/t3.price)  > 0 THEN 1 ELSE 0 end ) as x2,
( CASE WHEN((t3.price - t4.price)/t4.price)  > 0 THEN 1 ELSE 0 end ) as x3,
( CASE WHEN((t4.price - t5.price)/t5.price)  > 0 THEN 1 ELSE 0 end ) as x4,
( CASE WHEN((t5.price - t6.price)/t6.price)  > 0 THEN 1 ELSE 0 end ) as x5,
( CASE WHEN((t6.price - t7.price)/t7.price)  > 0 THEN 1 ELSE 0 end ) as x6,
( CASE WHEN((t7.price - t8.price)/t8.price)  > 0 THEN 1 ELSE 0 end ) as x7,
( CASE WHEN((t8.price - t9.price)/t9.price)  > 0 THEN 1 ELSE 0 end ) as x8,
( CASE WHEN((t9.price - t10.price)/t10.price)  > 0 THEN 1 ELSE 0 end ) as x9,
( CASE WHEN((t10.price - t11.price)/t1.price)  > 0 THEN 1 ELSE 0 end ) as x10,

((t1.price - t2.price)/t2.price) as d1,
((t2.price - t3.price)/t3.price) as d2,
((t3.price - t4.price)/t4.price) as d3,
((t4.price - t5.price)/t5.price) as d4,
((t5.price - t6.price)/t6.price) as d5,
((t6.price - t7.price)/t7.price) as d6,
((t7.price - t8.price)/t8.price) as d7,
((t8.price - t9.price)/t9.price) as d8,
((t9.price - t10.price)/t10.price) as d9,
((t10.price - t11.price)/t11.price) as d10,

com.isin

FROM 

investment_companies_tracker t1, 
investment_companies_tracker t2,
investment_companies_tracker t3,
investment_companies_tracker t4,
investment_companies_tracker t5,
investment_companies_tracker t6,
investment_companies_tracker t7,
investment_companies_tracker t8,
investment_companies_tracker t9,
investment_companies_tracker t10,
investment_companies_tracker t11,
investment_companies com

WHERE 
com.id = t1.id_base and
t1.id_base = t2.id_base and 
t1.id_base = t3.id_base and 
t1.id_base = t4.id_base and 
t1.id_base = t5.id_base and 
t1.id_base = t6.id_base and 
t1.id_base = t7.id_base and 
t1.id_base = t8.id_base and 
t1.id_base = t9.id_base and 
t1.id_base = t10.id_base and 
t1.id_base = t11.id_base  



and t1.date_of_price = '$date[0]'
and t2.date_of_price = '$date[1]'
and t3.date_of_price = '$date[2]'
and t4.date_of_price = '$date[3]'
and t5.date_of_price = '$date[4]'
and t6.date_of_price = '$date[5]'
and t7.date_of_price = '$date[6]'
and t8.date_of_price = '$date[7]'
and t9.date_of_price = '$date[8]'
and t10.date_of_price = '$date[9]'
and t11.date_of_price = '$date[10]'


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

if ($v_sort eq 'x_ges' || $v_sort eq '')
{
	$sql_string = $sql_string . "
	x_ges desc,
	d_ges desc,
	x1 desc,
	x2 desc,
	x3 desc,
	x4 desc,	
	x5 desc,
	x6 desc,
	x7 desc,
	x8 desc,
	x9 desc,
	x10 desc,

	d1 desc,
	d2 desc,
	d3 desc,
	d4 desc,
	d5 desc,
	d6 desc,
	d7 desc,
	d8 desc,
	d9 desc,
	d10 desc ";

};

if ($v_sort eq 'd_ges')
{
	$sql_string = $sql_string . "
	
	d_ges desc,
	x1 desc,
	x2 desc,
	x3 desc,
	x4 desc,	
	x5 desc,
	x6 desc,
	x7 desc,
	x8 desc,
	x9 desc,
	x10 desc,

	d1 desc,
	d2 desc,
	d3 desc,
	d4 desc,
	d5 desc,
	d6 desc,
	d7 desc,
	d8 desc,
	d9 desc,
	d10 desc ";

};


if ($v_sort eq 'x1x10')
{
	$sql_string = $sql_string . "
	
	
	x1 desc,
	x2 desc,
	x3 desc,
	x4 desc,	
	x5 desc,
	x6 desc,
	x7 desc,
	x8 desc,
	x9 desc,
	x10 desc,

	d1 desc,
	d2 desc,
	d3 desc,
	d4 desc,
	d5 desc,
	d6 desc,
	d7 desc,
	d8 desc,
	d9 desc,
	d10 desc ";

};


$sql = $db->prepare($sql_string);



$sql->execute();

print "<table>";
print "<tr>";
print "<td>name</td>"; 
print "<td>wkn</td>"; 
print "<td>isin</td>"; 
print "<td>x-ges</td>"; 
print "<td>d-ges</td>"; 
print "<td>x1</td>"; 
print "<td>x2</td>"; 
print "<td>x3</td>"; 
print "<td>x4</td>"; 
print "<td>x5</td>"; 
print "<td>x6</td>"; 
print "<td>x7</td>"; 
print "<td>x8</td>"; 
print "<td>x9</td>"; 
print "<td>x10</td>"; 
print "<td>d1</td>"; 
print "<td>d2</td>"; 
print "<td>d3</td>"; 
print "<td>d4</td>"; 
print "<td>d5</td>"; 
print "<td>d6</td>"; 
print "<td>d7</td>"; 
print "<td>d8</td>"; 
print "<td>d9</td>"; 
print "<td>d10</td>"; 


print "</tr>";

$v_amount_in_sum = 0;
$v_amount_out_sum = 0;

while(@zeile=$sql->fetchrow_array())
{
print "<tr>";

   print "<td> $zeile[0] &nbsp;</td>";
   print '<td onclick="action_opener(\''.$zeile[1].'\')" ><b>'.$zeile[1].'&nbsp;</b></td>';
      print '<td onclick="action_opener(\''.$zeile[24].'\')" ><b>'.$zeile[24].'&nbsp;</b></td>';
  #print "<td> $zeile[1] &nbsp;</td>";
  print "<td> $zeile[2] &nbsp;</td>";
  print "<td> $zeile[3] &nbsp;</td>";
  print "<td> $zeile[4] &nbsp;</td>";
  print "<td> $zeile[5] &nbsp;</td>";
  print "<td> $zeile[6] &nbsp;</td>";
  print "<td> $zeile[7] &nbsp;</td>";
  print "<td> $zeile[8] &nbsp;</td>";
  print "<td> $zeile[9] &nbsp;</td>";
  print "<td> $zeile[10] &nbsp;</td>";
  print "<td> $zeile[11] &nbsp;</td>";
  print "<td> $zeile[12] &nbsp;</td>";
  print "<td> $zeile[13] &nbsp;</td>";
  print "<td> $zeile[14] &nbsp;</td>";
  print "<td> $zeile[15] &nbsp;</td>";
  print "<td> $zeile[16] &nbsp;</td>";
  print "<td> $zeile[17] &nbsp;</td>";
  print "<td> $zeile[18] &nbsp;</td>";
  print "<td> $zeile[19] &nbsp;</td>";
  print "<td> $zeile[20] &nbsp;</td>";
  print "<td> $zeile[21] &nbsp;</td>";
  print "<td> $zeile[22] &nbsp;</td>";
  print "<td> $zeile[23] &nbsp;</td>";
  
 

 print "</tr>";
};




print "</table>";




$sql->finish;

$db->disconnect;






# ------------------ ende innerer block mit permission ------------

}
else
{
print 'permission denied'; 	
};


exit 0;