#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;


my $db;
my $db2;
my $sql;
my $sql2;
my $sql_string;
my $sql_string2;
my $sql_string_check;
my @zeile = ();
my @zeile2 = ();
my $dividend;


my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_insert = param("v_insert");

my $v_id = param("v_id");
my $v_date_created = param("v_date_created");
my $v_wkn = param("v_wkn");
my $v_number_of_shares = param("v_number_of_shares");
my $v_action = param("v_action");
my $v_price = param("v_price");
my $v_currency = param("v_currency");
my $v_currency_at_date = param("v_currency_at_date");
my $v_date_of_deal = param("v_date_of_deal");
my $v_comment = param("v_comment");
my $v_fee = param("v_fee");


my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_year = $v_year + 1900;
$v_month = $v_month + 1;



do "invest_header.pl";
do "../includes/server_location.pl";
do "../includes/the_base_db_connect.pl";
do "investment_db_connect.pl";






header($v_u,$v_s);




if (checklogin($v_u,$v_s) eq 'yes')
{


# ------------------ anfang innerer block mit permission ------------



#-------------------------- new action input form ----------------------------------
if ($v_insert eq 'insert_prepare')
{
print'		<form method="POST" action="./investment_deals.pl">

		<table>
		


		<tr><td>
			<table>
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_insert"  value="yes"></td></tr>
								
				<tr><td>WKN</td><td><input name="v_wkn" size="50" value=""></td></tr>
				<tr><td>number of shares</td><td><input name="v_number_of_shares" size="50" value=""></td></tr>
				<tr><td>action</td><td>
						<select  name="v_action" size="1" >
						<option value="purchase">purchase</option>
						<option value="sale">sale</option>						
						</select>
				    </td></tr>
				
				<tr><td>price (1.5432)</td><td><input name="v_price" size="50" value=""></td></tr>
				<tr><td>currency</td><td><input name="v_currency" size="50" value="EUR"></td></tr>
				<tr><td>currency at date (GBP=1.5)</td><td><input name="v_currency_at_date" size="50" value="1.0000"></td></tr>
				<tr><td>date of deal(2004-06-30)</td><td><input name="v_date_of_deal" size="50" value=""></td></tr>
				
				<tr><td>transaction fee in EUR</td><td><input name="v_fee" size="50" value=""></td></tr>
				
		
				<tr><td>comment</td><td><textarea name="v_comment" rows="10" cols="50" ></textarea></td></tr>
				<tr><td>
				<input type="submit" value="save">
				</td></tr>
			</table>
		</td></tr>

			</table>
		</form>

';
};
# ---------------------------end new action input form ----------------------------

# --------insert table ----------------------------------------------------------------
if ($v_insert eq 'yes')
{

$sql_string = 'insert into investment_deals (   
created ,
wkn,
number_of_shares ,
action  ,
price,  
currency ,
currency_at_date , 
date_of_deal ,
comment, transaction_fee ) values  (';


$sql_string = $sql_string . '"' . $v_year .'-' .$v_month . '-' . $v_day . '",' ;
$sql_string = $sql_string . '"' . $v_wkn . '",' ;
$sql_string = $sql_string . '"' . $v_number_of_shares . '",' ;
$sql_string = $sql_string . '"' . $v_action . '",' ;
$sql_string = $sql_string . '"' . $v_price . '",' ;
$sql_string = $sql_string . '"' . $v_currency . '",' ;
$sql_string = $sql_string . '"' . $v_currency_at_date . '",' ;
$sql_string = $sql_string . '"' . $v_date_of_deal . '",' ;
$sql_string = $sql_string . '"' . $v_comment . '",' ;
$sql_string = $sql_string . '"' . $v_fee . '")' ;



$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};




# --------end insert table ------------------------------------------------------------

print "<br><a href='investment_deals.pl?v_u=".$v_u."&v_s=".$v_s."&v_insert=insert_prepare'><b>insert new deal</b></a><br>";


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";



$sql_string =  "select * from investment_deals order by id desc ";





$sql = $db->prepare($sql_string);


$sql->execute();


print "<table border = '1' >";


print "<td  ><b>update</b></td>";
print "<td  ><b>id</b></td>";
print "<td  ><b>dividende</b></td>";
print "<td  ><b>created</b></td>";
print "<td  ><b>wkn</b></td>";
print "<td  ><b>number_of_shares</b></td>";
print "<td  ><b>action</b></td>";
print "<td  ><b>price </b></td>";
print "<td  ><b>currency</b></td>";
print "<td  ><b>currency_at_date</b></td>";
print "<td  ><b>date_of_deal</b></td>";
print "<td  ><b>fee</b></td>";
print "<td  ><b>comment</b></td>";



$db2 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


while(@zeile=$sql->fetchrow_array())
{
print "<tr>";

  print "<td><a href='investment_deals_update.pl?v_u=".$v_u."&v_s=".$v_s."&v_id=$zeile[0]'><b>update</b></a></td>";
  print "<td> $zeile[0] &nbsp;</td>";
  
 	$sql_string2 = "select sum(betrag) from investment_dividend  where id_deals = '" . $zeile[2] . "'";
	#print $sql_string2;
	$sql2 = $db2->prepare($sql_string2);
	$sql2->execute();
	
  
  	$dividend = '0';
  	while(@zeile2=$sql2->fetchrow_array())
	{
		$dividend = '' . $zeile2[0] . '';		
  	}
  	$sql2->finish;
  	
  	if ($dividend eq '')
  	{
  		$dividend = '0';
  	}
  	
  print "<td><a href='investment_dividend.pl?v_u=".$v_u."&v_s=".$v_s."&v_wkn=$zeile[2]'><b>[" . $dividend . "]</b></a></td>";  

  	
  	
  print "<td> $zeile[1] &nbsp;</td>";
  print "<td> $zeile[2] &nbsp;</td>";
  print "<td> $zeile[3] &nbsp;</td>";
  print "<td> $zeile[4] &nbsp;</td>";
  print "<td> $zeile[5] &nbsp;</td>";
  print "<td> $zeile[6] &nbsp;</td>";
  print "<td> $zeile[7] &nbsp;</td>";
  print "<td> $zeile[8] &nbsp;</td>";
  print "<td> $zeile[12] &nbsp;</td>";
  print "<td> $zeile[9] &nbsp;</td>";
 


 print "</tr>";
};
print "</table>";

print "finished";
$sql->finish;
$db->disconnect;
$db2->disconnect;

do "the_base_footer.pl";


# ------------------ ende innerer block mit permission ------------

}
else
{
print 'permission denied'; 	
};

exit 0;
