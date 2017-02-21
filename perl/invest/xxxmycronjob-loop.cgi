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
my $sql4;
my $sql_string4;
my $already_done;

my $sql_string_check;
my @zeile = ();
my @zeile2 = ();
my @zeile3 = ();
my @zeile4 = ();
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
my $v_counter = param("v_counter");
my $v_counter_max;
my $v_where_clause;

if ($v_counter eq '')
{
$v_counter = 0;	
};



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



# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------
# ------------------ START VON AKTIEN TRACKER  ------------




#   	ablauf:
#	1. anzahl records rausfinden
# 	2. wenn anzahl records kleiner ist als cpunter dann weiter machen sonst zu indes springen
# 	3. sql nochmal aufrufen und ab Limit 30 records raussucen
#	4. counter bei jedem aufruf erhöhen um 1


# ------------------------------------------------------------------------
# where clause für alle statements:

print "1" ;

$v_where_clause = ' WHERE 
(papier_art = "" or papier_art is null)

AND (isin <>  "" OR wkn <>  "" ) 

and found_flag = "yes"

AND (
(isin  like "%DE%")  or 
(isin  like "%FR%")  or
(isin  like "%FR%")  or
(isin  like "%IT%")  or
(isin  like "%DK%")  or
(isin  like "%SE%")  or
(isin  like "%NL%")  or
(isin  like "%GB%")  or

isin = "" or isin is null)';

print "2" ;
# ------------------------------------------------------------------------

# $db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";


$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";


$sql_string =  ' SELECT  count(id) FROM  investment_companies ';
$sql_string = $sql_string  .  $v_where_clause;

print "3" ;
print "<br>----------------------<br>" ;
print $sql_string;
print "<br>----------------------<br>" ;

$sql = $db->prepare($sql_string);
print "5" ;
$sql->execute();
print "6" ;
while(@zeile=$sql->fetchrow_array())
{
print "7" ;
$v_counter_max = $zeile[0];
print $zeile[0];
print "8" ;
};

$sql->finish;

print "4" ;
print "<br>------COUNTER MAX-------<br>" ;
print $v_counter_max . "<br>";
print "<br>------COUNTER -------<br>" ;
print $v_counter . "<br>";
print "<br>----------------------<br>" ;



# --------------------- 2. aufruf wenn noch was zu tun----------------------------------

if ($v_counter_max != $v_counter)
{
	
	$sql_string =  ' SELECT  id, wkn, isin, symbol FROM  investment_companies ';
	$sql_string = $sql_string  .  $v_where_clause;
	$sql_string = $sql_string  . ' Limit ' . $v_counter . ',20 ';
	 
	$sql = $db->prepare($sql_string);
	$sql->execute();
	
	while(@zeile=$sql->fetchrow_array())
	{
		$v_counter = $v_counter + 1;
		
		# ------------  hier dann für jede wkn den wert rausziehen
		
		
		# zuerst checken ob dieser werte heute schon analysiert wurde.
		$sql_string4 =  ' SELECT  * FROM  investment_companies_tracker ';
		$sql_string4 = $sql_string4  .  ' where date_of_price = "' . $v_date_of_price . '" and id_base = ' . $zeile[0] . ' ';
		$sql4 = $db->prepare($sql_string4);
		$sql4->execute();
		print $sql_string4;
		
		
		
		
		$already_done = "no";
			
		while(@zeile4=$sql4->fetchrow_array())
		{
		$already_done = "yes";	
		print "value already exists - in schleife<br>";
		}
		print "value already exists<br>";
		
		# 1. per post oder get wert html ermitteln
		
		print $already_done . "<br>";
		
		
		
		# von den 3 spalten mit den symbolen die rausfinden die die beste ist
		
		if ($already_done eq 'no')
		{
			print $already_done . "-- in schliefe -- <br>";
			print $already_done . "-- in schliefe -- <br>";
			print $already_done . "-- in schliefe -- <br>";
			print $already_done . "-- in schliefe -- <br>";
			print $already_done . "-- in schliefe -- <br>";
			
			
			if( ($zeile[3] ne "notfound") && ($zeile[3] ne "todo"))
			{
				$wkn_isn = $zeile[3];	# dann yahoo auslesen
			}
			else
			{
				if($zeile[2] eq '')
				{
					$wkn_isn = $zeile[1];
				}
				else
				{
					$wkn_isn = $zeile[2];
				}	
			}
				
				if(($zeile[3] ne "notfound") && ($zeile[3] ne "todo"))
				{	
					$get_html = get('http://de.finance.yahoo.com/q?s=' . $wkn_isn);	
					#print '<br>yahoo: ' . $get_html . '<br>';	
					$get_html =~ m/Letzter Kurs(.*)\#8364/si;		
					$get_html = "$1";
					#print '<br>yahoo: ' . $get_html . '<br>';		
					$get_html =~ m/<b>(.*)&/si;
					$get_html = "$1";
					#print '<br>yahoo: ' . $get_html . '<br>';		
					$get_html =~ s/\.//g;		
					$get_html =~ s/,/./g;
				}
				else
				{
					$get_html = get('http://www.wallstreet-online.de/si/?k=' . $wkn_isn);		
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
				}
				
				
			if($zeile[3] ne 'notfound' && $zeile[3] ne 'todo')
			{
				# deaktiviert um javascript code zu unterbinden
				# print '<br>yahoo: ' . $get_html . '<br>';
			}
			else
			{
				# deaktiviert um javascript code zu unterbinden
				# print '<br>wallstreet: ' . $get_html . '<br>';	
			}	
			
			# 2a. check ob wert auch numer isch ist 
			
			
			
			
			# 2b. wenn wert leer oder null dann setzt ein flag damit beim nächsten mal nicht gesucht wird
			if ($get_html eq '')
			{
				$sql_string3 = ' update investment_companies set found_flag = "no" where id = ' . $zeile[0];
				print $sql_string3;
				# $db3 = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
                                
                $db3 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";
                
				$sql3 = $db3->prepare($sql_string3);
			#	$sql3->execute();
				$sql3->finish;
				$db3->disconnect;
			}
			# 3. sql erstellen und eintragen
			
			
			
			$sql_string2 = 'insert into investment_companies_tracker (   
			id_base ,
			date_of_price,
			price) values  (';
			
			
			$sql_string2 = $sql_string2 . '"' . $zeile[0] . '",' ;
			$sql_string2 = $sql_string2 . '"' . $v_date_of_price . '",' ;
			$sql_string2 = $sql_string2 . ' ' . $get_html . ')' ;
			
			# deaktiviert um javascript code zu unterbinden
			# print $sql_string2;
			print '<br>------------------------------------------------------------<br>';
			
			# $db2 = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
            $db2 = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";
                
			$sql2 = $db2->prepare($sql_string2);
			$sql2->execute();
			
			
			$sql2->finish;
			$db2->disconnect;
			
			
			
			
			# ------------------------------------------------------------
		
		}; # end of if already done
	};
	
	
	$sql->finish;
	
	print "nur DELETE statment";
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
	window.location ='./mycronjob-loop.cgi?v_u=".$v_u."&v_s=".$v_s."&v_counter=".$v_counter."&v_counter_max=".$v_counter_max."' ;
	</script>";
	
	
	
	# --------------------- else von 2. aufruf wenn noch was zu tun----------------------------------
	


}
else
{
	print "
	<script language ='JavaScript' >
	window.location ='../admin/index.pl?v_u=".$v_u."&v_s=".$v_s."' ;
	</script>";
	
}

# --------------------- ende von 2. aufruf wenn noch was zu tun----------------------------------


do "the_base_footer.pl";






exit 0;
