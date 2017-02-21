#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;


my $db;
my $sql;
my $sql_string;
my $sql_string_check;
my @zeile = ();


my $v_id = param("v_id");
my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_insert = param("v_insert");

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

my @zeile;

$v_year = $v_year + 1900;
$v_month = $v_month + 1;




do "the_base_header.pl";
do "the_base_db_connect.pl";




header($v_u,$v_s);




if (checklogin($v_u,$v_s) eq 'yes')
{


# ------------------ anfang innerer block mit permission ------------


# --------insert table ----------------------------------------------------------------



if ($v_insert eq 'update')
{
$sql_string = 'update investment_deals set ';
$sql_string = $sql_string . 'created = "' . $v_year .'-' .$v_month . '-' . $v_day . '",' ;
$sql_string = $sql_string . 'wkn = "' . $v_wkn . '",' ;
$sql_string = $sql_string . 'number_of_shares = "' . $v_number_of_shares . '",' ;
$sql_string = $sql_string . 'action = "' . $v_action . '",' ;
$sql_string = $sql_string . 'currency = "' . $v_currency . '",' ;
$sql_string = $sql_string . 'currency_at_date = "' . $v_currency_at_date . '",' ;
$sql_string = $sql_string . 'date_of_deal = "' . $v_date_of_deal . '",' ;
$sql_string = $sql_string . 'comment = "' . $v_comment . '", ' ;
$sql_string = $sql_string . 'transaction_fee = "' . $v_fee . '" ' ;
$sql_string = $sql_string . 'where id = ' . $v_id . '';

print $sql_string;

$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;


print "
<script language ='JavaScript' >
 window.location ='investment_deals.pl?step=form&v_u=".$v_u."&v_s=".$v_s."' ;
 </script>";


};
# --------end insert table ------------------------------------------------------------


#-------------------------- action update form ----------------------------------

$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

$sql_string =  "select * from investment_deals where ";
$sql_string = $sql_string . "id = ".$v_id."  " ;
$sql = $db->prepare($sql_string);
$sql->execute();



@zeile=$sql->fetchrow_array();


print'		<form method="POST" action="/cgi-bin/investment_deals_update.pl">

		<table>
		


		<tr><td>
			<table>
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_id"  value="'.$v_id.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_insert"  value="update"></td></tr>
								
				<tr><td>WKN</td><td><input name="v_wkn" size="50" value="'.$zeile[2].'"></td></tr>
				<tr><td>number of shares</td><td><input name="v_number_of_shares" size="50" value="'.$zeile[3].'"></td></tr>
				<tr><td>action</td><td>
						<select  name="v_action" size="1" >
						<option selected value="'.$zeile[4].'">'.$zeile[4].'</option>						
						<option value="purchase">purchase</option>
						<option value="sale">sale</option>						
						</select>
				    </td></tr>
				
				<tr><td>price (1.5432)</td><td><input name="v_price" size="50" value="'.$zeile[5].'"></td></tr>
				<tr><td>currency</td><td><input name="v_currency" size="50" value="'.$zeile[6].'"></td></tr>
				<tr><td>currency at date (GBP=1.5)</td><td><input name="v_currency_at_date" size="50" value="'.$zeile[7].'"></td></tr>
				<tr><td>date of deal(2004-06-30)</td><td><input name="v_date_of_deal" size="50" value="'.$zeile[8].'"></td></tr>
				<tr><td>transaction fee in EUR</td><td><input name="v_fee" size="50" value="'.$zeile[12].'"></td></tr>
				
				
		
				<tr><td>comment</td><td><textarea name="v_comment" rows="10" cols="50" >'.$zeile[9].'</textarea></td></tr>
				<tr><td>
				<input type="submit" value="save">
				</td></tr>
			</table>
		</td></tr>

			</table>
		</form>

';



# ---------------------------end new action input form ----------------------------


# ---------------- display table -----------------------------------------------------

$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";



$sql_string =  "select * from investment_deals  ";





$sql = $db->prepare($sql_string);


$sql->execute();


print "<table border = '1' >";

print "<td  >update</td>";
print "<td  >id</td>";
print "<td  >created</td>";
print "<td  >wkn</td>";
print "<td  >number_of_shares</td>";
print "<td  >action</td>";
print "<td  >price </td>";
print "<td  >currency</td>";
print "<td  >currency_at_date</td>";
print "<td  >date_of_deal</td>";
print "<td  >fee</td>";
print "<td  >comment</td>";




while(@zeile=$sql->fetchrow_array())
{
print "<tr>";

  print "<td><a href='investment_deals_update.pl?v_u=".$v_u."&v_s=".$v_s."&v_id=".$zeile[0]."&v_id_action=$zeile[0]'><b>update</b></a></td>";
  print "<td> $zeile[0] &nbsp;</td>";
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


$sql->finish;
$db->disconnect;

do "the_base_footer.pl";


# ------------------ ende innerer block mit permission ------------

}
else
{
print 'permission denied'; 	
};

exit 0;
