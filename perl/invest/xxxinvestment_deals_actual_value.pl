#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;


my $db;
my $db2;
my $db3;
my $db5;
my $sql;
my $sql_string;
my $sql2;
my $sql_string2;
my $sql3;
my $sql_string3;
my $sql4;
my $sql_string4;
my $sql5;
my $purchase_price;
my $purchase_delta;
my $purchase_delta_percent;
my $sql_string5;
my $sql_string_check;
my @zeile = ();
my @zeile2 = ();
my @zeile3 = ();
my @zeile4 = ();
my @zeile5 = ();

my $v_line_value;
my $v_total_value;
my $v_total_value_purchases;
my $v_total_value_sales;
my $v_total_profit;
my $v_total_roi;
my $v_dividenden;
my $v_gebuehren;


my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_insert = param("v_insert");
my $v_id = param("v_id");

my $v_wkn = param("v_wkn");
my $v_date_of_price = param("v_date_of_price");
my $v_currency = param("v_currency");
my $v_currency_factor = param("v_currency_factor");
my $v_price = param("v_price");



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
# include welches mails abholt
print '<script src="../../../live/javascript/ajax.js" type="text/javascript"></script>';
print '<script src="../../../live/javascript/ajaxMailChecker.js" type="text/javascript"></script>';
print ' <script language ="JavaScript"> 
 function action_opener(id)
 {
        window.open("http://www.wallstreet-online.de/si/?k="+id+"","Actions","menubar=no,scrollbars=yes,resizeable=yes");
        
 };
 </script>';

#-------------------------- new action input form ----------------------------------
if ($v_insert eq 'new_prepare')
{
print'		<form method="POST" action="./investment_deals_actual_value.pl">

		<table>
		


		<tr><td>
			<table>
				
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_id"  value="'.$v_id.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_insert"  value="yes"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_wkn"  value="'.$v_id.'"></td></tr>
				
				<tr><td>date of price</td><td><input name="v_date_of_price" size="50" value="' . $v_year .'-' .$v_month . '-' . $v_day . '"></td></tr>
				<tr><td>currency</td><td><input name="v_currency" size="50" value="'. $v_currency .'"></td></tr>
				
				<tr><td>currency facor</td><td><input name="v_currency_factor" size="50" value="'. $v_currency_factor .'"></td></tr>
				
				<tr><td>price</td><td><input name="v_price" size="50" value=""></td></tr>
								
				<tr><td>
				<input type="submit" value="save">
				</td></tr>
			</table>
		</td></tr>

			</table>
		</form>

';
}
else
{

	
	
	
}
;
# ---------------------------end new action input form ----------------------------

# ---------------------------prepare update  form ----------------------------

if ($v_insert eq 'update_prepare')
{



$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql_string =  "select * from investment_current_value where ";
$sql_string = $sql_string . "id = ".$v_id."  " ;
$sql = $db->prepare($sql_string);
$sql->execute();



@zeile=$sql->fetchrow_array();





print'		<form method="POST" action="./investment_deals_actual_value.pl">

		<table>
		


		<tr><td>
			<table>
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_id"  value="'.$v_id.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_insert"  value="update"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_wkn"  value="'.$zeile[1].'"></td></tr>
				
				
				
				<tr><td>date of price</td><td><input name="v_date_of_price" size="50" value="'.$zeile[2].'"></td></tr>
				<tr><td>currency</td><td><input name="v_currency" size="50" value="'.$zeile[3].'"></td></tr>
				
				<tr><td>currency facor</td><td><input name="v_currency_factor" size="50" value="'.$zeile[4].'"></td></tr>
				
				<tr><td>price</td><td><input name="v_price" size="50" value="'.$zeile[5].'"></td></tr>
				
				
				
				<tr><td>
				<input type="submit" value="save">
				</td></tr>
			</table>
		</td></tr>

			</table>
		</form>

';

};


# --------------------------- end prepare update ----------------------------

# --------insert table ----------------------------------------------------------------



if ($v_insert eq 'update')
{
$sql_string = 'update investment_current_value set ';
$sql_string = $sql_string . 'date_of_price = "' . $v_date_of_price . '",' ;
$sql_string = $sql_string . 'currency = "' . $v_currency . '",' ;
$sql_string = $sql_string . 'currency_factor = "' . $v_currency_factor . '",' ;
$sql_string = $sql_string . 'price = "' . $v_price . '"' ;
$sql_string = $sql_string . 'where id = ' . $v_id . '';


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};
# --------end insert table ------------------------------------------------------------



# --------insert table ----------------------------------------------------------------
if ($v_insert eq 'yes')
{

$sql_string = 'insert into investment_current_value (   
wkn ,
date_of_price,
currency ,
currency_factor  ,
price ) values  (';


$sql_string = $sql_string . '"' . $v_wkn . '",' ;
$sql_string = $sql_string . '"' . $v_date_of_price . '",' ;
$sql_string = $sql_string . '"' . $v_currency . '",' ;
$sql_string = $sql_string . '"' . $v_currency_factor . '",' ;
$sql_string = $sql_string . '"' . $v_price . '")' ;



$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};




# --------end insert table ------------------------------------------------------------


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql_string =  "select wkn,  
 sum(case action when 'purchase' then number_of_shares else  (number_of_shares  * -1) end) as shares 
 from investment_deals group by wkn";


$sql = $db->prepare($sql_string);


$sql->execute();


print "<br><a href='investment_deals_actual_value_update_values.pl?v_u=".$v_u."&v_s=".$v_s."'><b>auto update values</b></a><br><br>";
  

print "<center>";
print "<table border = '1' ><tr>";
print "<td  ><b>insert</b>&nbsp;</td>";
print "<td  ><b>update</b>&nbsp;</td>";
print "<td  ><b>wkn</b>&nbsp;</td>";
print "<td  ><b>NOS</b>&nbsp;</td>";

print "<td  ><b>max id</b>&nbsp;</td>";

print "<td  ><b>date_of_price</b>&nbsp;</td>";
print "<td  ><b>currency</b>&nbsp;</td>";
print "<td  ><b>c. fac.</b>&nbsp;</td>";

print "<td  ><b>price</b>&nbsp;</td>";
print "<td  ><b>value</b>&nbsp;</td>";
print "<td  ><b>Pur.<br>Price</b>&nbsp;</td>";
print "<td  ><b>DELTA</b>&nbsp;</td>";
print "<td  ><b>D Total</b>&nbsp;</td>";
print "<td  ><b>Name</b>&nbsp;</td>";
print "</tr>";


while(@zeile=$sql->fetchrow_array())
{
if ($zeile[1] ne 0 )
{	
# -------------------------------------------------------------------	
# select the correct ids


$db2 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string2 =  "
SELECT v1.wkn, max( v1.id ) AS maxid
FROM investment_current_value AS v1
WHERE v1.wkn = '".$zeile[0]."'
GROUP BY v1.wkn
";

$sql2 = $db2->prepare($sql_string2);
$sql2->execute();
@zeile2=$sql2->fetchrow_array()	;
# -------------------------------------------------------------------	
	
# -------------------------------------------------------------------	
# select the prices


$db3 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string3 =  "
SELECT date_of_price, currency, currency_factor, price
FROM investment_current_value 
WHERE id  = ".$zeile2[1]."
GROUP BY wkn
";

$sql3 = $db3->prepare($sql_string3);
$sql3->execute();
@zeile3=$sql3->fetchrow_array()	;	
# -------------------------------------------------------------------
	
# select the purchase price


$db5 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string5 =  "
SELECT  max(id), max(`price`) 
FROM  `investment_deals` 
WHERE 1  AND  `wkn` 
LIKE  '".$zeile[0]."' AND  `action` 
LIKE  'purchase'
";

$purchase_price = 0;
$sql5 = $db5->prepare($sql_string5);
$sql5->execute();
@zeile5=$sql5->fetchrow_array()	;

# hier mssen alle preise hin die ich gezahlt hab...
$purchase_price =  $zeile5[1];


	
# -------------------------------------------------------------------	
	
	
print "<tr>";
  print "<td><a href='investment_deals_actual_value.pl?v_insert=new_prepare&v_u=".$v_u."&v_s=".$v_s."&v_id=".$zeile[0]."&v_currency=".$zeile3[1]."&v_currency_factor=".$zeile3[2]."'><b>insert</b></a></td>";
  
  print "<td><a href='investment_deals_actual_value.pl?v_insert=update_prepare&v_u=".$v_u."&v_s=".$v_s."&v_id=$zeile2[1]'><b>update</b></a></td>";
  
  print '<td onclick="action_opener(\''.$zeile[0].'\')" ><b>'. $zeile[0] .'</b></td>';
  print "<td  class='numbers' >". $zeile[1] ."</td>";
  # now correct max id
  print "<td  class='numbers' >". $zeile2[1] ."</td>";
  # now prices of max date  
  print "<td  >". $zeile3[0] ."</td>";
  print "<td  >". $zeile3[1] ."</td>";
  print "<td  class='numbers'>". $zeile3[2] ."</td>";
  print "<td  class='numbers'>". $zeile3[3] ."</td>";

  $v_line_value = $zeile[1] * $zeile3[2] * $zeile3[3] ;
 
  $v_total_value = $v_total_value + $v_line_value;
  
  print "<td  class='numbers'> ".$v_line_value." &nbsp;</td>";
  
  #difference bewtween current price and pruchase price
  
  print "<td class='numbers'>"  ;
  
  prices($zeile[0]);
  
  print "</td>";
  
  
  
  price_delta($zeile[0], $zeile3[3]);
  
  print "<td>";
  get_name($zeile[0]);
  print "</td>";
  
  print "</tr>";
 
 $sql2->finish;
$db2->disconnect;
 $sql3->finish;
$db3->disconnect;
 $sql5->finish;
$db5->disconnect;
};
};

print "<td colspan='9' > <b>Total portfolio value in EUR</b></td>";
print "<td  ><b>".$v_total_value."</b></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

$sql->finish;
$db->disconnect;
# ---------- berechne das bisher investierte geld --------------------



$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string =  "select sum( number_of_shares * price * currency_at_date) as purchase_value  from  investment_deals where  action = 'purchase' ";
$sql = $db->prepare($sql_string);
$sql->execute();
@zeile=$sql->fetchrow_array()	;
$v_total_value_purchases = $zeile[0];
$v_total_value_purchases = sprintf("%.2f" , $v_total_value_purchases);

print "<tr><td colspan='9' > <b>Total value purchases in EUR</b></td>";
print "<td  ><b>".$v_total_value_purchases."</b></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
# ---------- berechne das bisher abgezogene geld --------------------
$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";

$sql_string =  "select sum( number_of_shares * price * currency_at_date) as purchase_value  from  investment_deals where  action = 'sale' ";
$sql = $db->prepare($sql_string);
$sql->execute();
@zeile=$sql->fetchrow_array()	;
$v_total_value_sales = $zeile[0];
$v_total_value_sales = sprintf("%.2f" , $v_total_value_sales);

print "<tr><td colspan='9' > <b>Total value sales in EUR</b></td>";
print "<td  ><b>".$v_total_value_sales."</b></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

# ---------- berechne erhaltene Dividenden  --------------------


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string =  "SELECT sum( betrag ) AS betrag FROM investment_dividend ";
$sql = $db->prepare($sql_string);
$sql->execute();
@zeile=$sql->fetchrow_array()	;
$v_dividenden = $zeile[0];
$v_dividenden = sprintf("%.2f" , $v_dividenden);

print "<tr><td colspan='9' > <b>Total amount dividends in EUR</b></td>";
print "<td  ><b>".$v_dividenden."</b></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

$sql->finish;
# ---------- berechne gezahlte Gebhren  --------------------


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string =  "SELECT sum( transaction_fee ) AS betrag FROM investment_deals  ";
$sql = $db->prepare($sql_string);
$sql->execute();
@zeile=$sql->fetchrow_array()	;
$v_gebuehren = $zeile[0];
$v_gebuehren = sprintf("%.2f" , $v_gebuehren);

print "<tr><td colspan='9' > <b>Total amount transaction fees in EUR</b></td>";
print "<td  ><b>".$v_gebuehren."</b></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

$sql->finish;
# ---------- berechne das bisherigen Profit  --------------------

$v_total_profit = $v_total_value + $v_total_value_sales + $v_dividenden - $v_total_value_purchases - $v_gebuehren;
$v_total_profit = sprintf("%.2f" , $v_total_profit);

print "<tr><td colspan='9' > <b>Total profit in EUR</b></td>";
print "<td  ><b>".$v_total_profit ."</b></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";

# ---------- berechne return on investment  --------------------

$v_total_roi = ($v_total_profit / $v_total_value_purchases) * 100 ;

$v_total_roi = sprintf("%.2f" , $v_total_roi);

print "<tr><td colspan='9' > <b>Return on investment in % </b></td>";
print "<td  ><b>".$v_total_roi ."</b></td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
# --------------------------------------------------------------

# speicehre aktuelle werte in investment_portf_tracker


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string =  "INSERT INTO  investment_portf_tracker (insert_date, portfolio_value, portfolio_profit, portfolio_roi, portfolio_purchases , portfolio_sales, portfolio_gebuehren ) VALUES ('" .$v_year ."-". $v_month ."-". $v_day ."', " . $v_total_value . ", " . $v_total_profit . ", " . $v_total_roi . ", " . $v_total_value_purchases . ", " . $v_total_value_sales . ", " . $v_gebuehren . " )  ";
$sql = $db->prepare($sql_string);
$sql->execute();

$sql->finish;

# --------------------------------------------------------------

print "</table>";
print "</center>";



do "the_base_footer.pl";


# ------------------ ende innerer block mit permission ------------

}
else
{
print 'permission denied'; 	
};


# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------
# ---------------------------- FUNKTIONEN --------------------------------------------
# ------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------


sub price_delta{

my $isin = $_[0];
my $price_now = $_[1];



my $db_price_delta = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";



my $sql_string_price_delta =  " SELECT price, number_of_shares FROM investment_deals WHERE  wkn LIKE '" . $isin . "' AND action LIKE 'purchase'  ";

my $sql_price_delta = $db->prepare($sql_string_price_delta);
$sql_price_delta->execute();
	
my @zeile_price_delta;
my $purchase_price_delta;
my $share_counter = 0;
my $part_value = 0;
my $curr_value = 0;
my $total_profit_loss = 0;
my $total_profit_loss_percent = 0;

	print "<td>"  ;
	
	while(@zeile_price_delta=$sql_price_delta->fetchrow_array())
	{
		print "DELTA: " ;
		$purchase_price_delta =  $price_now - $zeile_price_delta[0] ;
		print sprintf("%.2f" , $purchase_price_delta);
		print " (" ;
		
		$share_counter = $share_counter + $zeile_price_delta[1] ;
		
		$part_value = $part_value + ($zeile_price_delta[0] * $zeile_price_delta[1]);
		#--------------------------
		
			if ($price_now == 0 || $zeile_price_delta[0] == 0 )
	  		{
	 		print '0;'
	  		}
	  		else
	  		{
	  		$purchase_delta_percent = ($purchase_price_delta / $zeile_price_delta[0]) * 100;
	  		print sprintf("%.2f" , $purchase_delta_percent);
	  		print "% ";
	  		}
		
		#--------------------------
		print "NOS: " ; 
		print $zeile_price_delta[1];
		print " )<br> " ;	
	}

	print "</td>"  ;

	# n�htes td - gebe total frofit loss aus
	$curr_value = $share_counter * $price_now;
	
	if($curr_value <= $part_value)
	{
		print "<td class='numbers_negative'><b>" ;
	}
	else
	{
		print "<td class='numbers_positive'><b>" ;	
	}
	
	$total_profit_loss = $curr_value - $part_value ;
	
	if ($part_value != 0 || $total_profit_loss != 0 )
	{
	$total_profit_loss_percent = ($total_profit_loss / $part_value) * 100;
	}
	print sprintf("%.2f" , $total_profit_loss);
	print " (";
	print sprintf("%.2f" , $total_profit_loss_percent);
	print "%)";
	print "</b></td>";

$sql_price_delta->finish;
  
}


# ------------------------------------------------------------------------------------

sub prices{

my $isin = $_[0];




my $db_prices = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";



my $sql_string_prices =  " SELECT price, number_of_shares FROM investment_deals WHERE  wkn LIKE '" . $isin . "' AND action LIKE 'purchase'  ";
my $sql_prices = $db->prepare($sql_string_prices);
$sql_prices->execute();

my @zeile_prices;
	
	while(@zeile_prices=$sql_prices->fetchrow_array())
	{
		
		print sprintf("%.2f" , $zeile_prices[0]);
		print "<br>";
		
	}

$sql_prices->finish;
  
}

# ------------------------------------------------------------------------------------

sub get_name{
	
	my $isin = $_[0];	
	
my $db_names = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


	my $sql_string_names =  " SELECT left( COMMENT , 10 ) FROM investment_deals WHERE ACTION LIKE 'purchase' and  wkn LIKE '" . $isin . "' order by id desc  ";
		
	my $sql_names = $db->prepare($sql_string_names);
	$sql_names->execute();
	
	my @zeile_names;
		
	@zeile_names=$sql_names->fetchrow_array();	
			
	print $zeile_names[0];			
	
	$sql_names->finish;	  
}

# ------------------------------------------------------------------------------------

exit 0;
