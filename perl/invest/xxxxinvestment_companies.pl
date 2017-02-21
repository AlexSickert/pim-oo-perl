#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;


my $db;
my $db2;
my $db3;
my $sql;
my $sql_string;
my $sql2;
my $sql_string2;

my @zeile = ();


my $v_line_value;
my $v_total_value;


my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_insert = param("v_insert");
my $v_id = param("v_id");

my $v_1 = param("v_1");
my $v_2 = param("v_2");
my $v_3 = param("v_3");
my $v_4 = param("v_4");
my $v_5 = param("v_5");
my $v_6 = param("v_6");
my $v_7 = param("v_7");
my $v_8 = param("v_8");
my $v_9 = param("v_9");
my $v_10 = param("v_10");
my $v_11 = param("v_11");
my $v_12 = param("v_12");
my $v_13 = param("v_13");
my $v_14 = param("v_14");
my $v_15 = param("v_15");
my $v_16 = param("v_16");
my $v_17 = param("v_17");
my $v_18 = param("v_18");
my $v_limit;

my $v_filter = param("v_filter");
my $v_search  = param("v_search");




do "invest_header.pl";
do "../includes/server_location.pl";
do "../includes/the_base_db_connect.pl";
do "investment_db_connect.pl";






$v_limit = '';

if ($v_filter eq "")
{
$v_filter = " papier_art = 'aktie' ";	
}
else
{
	if ($v_filter eq "nur aktien")
	{
	$v_filter = " papier_art = 'aktie' ";	
	}
	else
	{
		if ($v_filter eq "Neue 10")
		{
		$v_filter = " papier_art IS NULL    ";	
		$v_limit = ' LIMIT 0 , 30 ';
		}
		else
		{
		$v_filter = " sektor_1 = '" . $v_filter . "' ";	
		}
	}	
};






if ($v_search ne "")
{
$v_filter = " name like '%" . $v_search . "%'  ";	
};



# ------------ die felder der tabelle
# id  papier_art  sektor_1  sektor_2  sektor_3  sektor_4  name  wkn  land  webseite  currency  share_price  number_shares  rating_1_10  short_comment  details  ISIN  
# ------------------------------------------------------------


my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_year = $v_year + 1900;
$v_month = $v_month + 1;




do "the_base_header.pl";
do "the_base_db_connect.pl";




header($v_u,$v_s);


print ' <script language ="JavaScript"> 
 function action_opener(id)
 {
        window.open("http://www.wallstreet-online.de/si/?k="+id+"","Actions","menubar=no,scrollbars=yes,resizeable=yes");
        
 };
 
 
 function detail_opener(v_u, v_s, v_id)
 {

        window.open("http://www.solenski.co.uk/cgi-bin/investment_companies_detail.pl?v_id="+v_id+"&v_u="+v_u+"&v_s="+v_s+"","Detail","menubar=no,scrollbars=yes,resizeable=yes");
 };
 
 
 </script>';


if (checklogin($v_u,$v_s) eq 'yes')
{


# ------------------ anfang innerer block mit permission ------------



#-------------------------- new action input form ----------------------------------
if ($v_insert eq 'new_prepare')
{
print'		<form method="POST" action="./investment_companies.pl">

		<table>
		


		<tr><td>
			<table>
				
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				
				<tr><td></td><td><input type="hidden" name="v_insert"  value="yes"></td></tr>
				
				<tr><td>papier_art </td><td><input name="v_2" size="50" value=""></td></tr> 
				<tr><td>sektor_1 </td><td><input name="v_3" size="50" value=""></td></tr>  
				<tr><td>sektor_2 </td><td><input name="v_4" size="50" value=""></td></tr> 
				<tr><td>sektor_3 </td><td><input name="v_5" size="50" value=""></td></tr> 
				<tr><td>sektor_4 </td><td><input name="v_6" size="50" value=""></td></tr> 
				<tr><td>name </td><td><input name="v_7" size="50" value=""></td></tr>   
				<tr><td>wkn </td><td><input name="v_8" size="50" value=""></td></tr> 
				<tr><td>land </td><td><input name="v_9" size="50" value=""></td></tr>  
				<tr><td>webseite  </td><td><input name="v_10" size="50" value=""></td></tr>
				<tr><td>currency </td><td><input name="v_11" size="50" value=""></td></tr>  
				<tr><td>share_price  </td><td><input name="v_12" size="50" value=""></td></tr>  
				<tr><td>number_shares  </td><td><input name="v_13" size="50" value=""></td></tr>  
				<tr><td>rating_1_10  </td><td><input name="v_14" size="50" value=""></td></tr>  
				<tr><td>short_comment  </td><td><input name="v_15" size="50" value=""></td></tr>
                                <tr><td>symbol</td><td><input name="v_17" size="50" value=""></td></tr>
                                <tr><td>isin  </td><td><input name="v_18" size="50" value=""></td></tr>

				
												
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

$sql_string =  "select * from investment_companies where ";
$sql_string = $sql_string . "id = ".$v_id."  " ;
$sql = $db->prepare($sql_string);
$sql->execute();



@zeile=$sql->fetchrow_array();





print'		<form method="POST" action="./investment_companies.pl">

		<table>
		


		<tr><td>
			<table>
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_id"  value="'.$v_id.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_insert"  value="update"></td></tr>
				
				
				<tr><td>papier_art</td><td><input name="v_2" size="50" value="'.$zeile[1].'"></td></tr>  
				<tr><td>sektor_1</td><td><input name="v_3" size="50" value="'.$zeile[2].'"></td></tr>  
				<tr><td>sektor_2</td><td><input name="v_4" size="50" value="'.$zeile[3].'"></td></tr> 
				<tr><td>sektor_3</td><td><input name="v_5" size="50" value="'.$zeile[4].'"></td></tr> 
				<tr><td>sektor_4</td><td><input name="v_6" size="50" value="'.$zeile[5].'"></td></tr>
				<tr><td>name</td><td><input name="v_7" size="50" value="'.$zeile[6].'"></td></tr>  
				<tr><td>wkn</td><td><input name="v_8" size="50" value="'.$zeile[7].'"></td></tr>
				<tr><td>land</td><td><input name="v_9" size="50" value="'.$zeile[8].'"></td></tr>  
				<tr><td>webseite</td><td><input name="v_10" size="50" value="'.$zeile[9].'"></td></tr>
				<tr><td>currency</td><td><input name="v_11" size="50" value="'.$zeile[10].'"></td></tr>  
				<tr><td>share_price</td><td><input name="v_12" size="50" value="'.$zeile[11].'"></td></tr>  
				<tr><td>number_shares</td><td><input name="v_13" size="50" value="'.$zeile[12].'"></td></tr>  
				<tr><td>rating_1_10</td><td><input name="v_14" size="50" value="'.$zeile[13].'"></td></tr>   
				<tr><td>short_comment</td><td><input name="v_15" size="50" value="'.$zeile[14].'"></td></tr>
                                <tr><td>symbol</td><td><input name="v_17" size="50" value="'.$zeile[20].'"></td></tr>
                                <tr><td>isin  </td><td><input name="v_18" size="50" value="'.$zeile[16].'"></td></tr>
				
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
$sql_string = 'update investment_companies set ';




$sql_string = $sql_string . 'papier_art  = "' . $v_2 . '",' ; 
$sql_string = $sql_string . 'sektor_1  = "' . $v_3 . '",' ;  
$sql_string = $sql_string . 'sektor_2  = "' . $v_4 . '",' ; 
$sql_string = $sql_string . 'sektor_3  = "' . $v_5 . '",' ; 
$sql_string = $sql_string . 'sektor_4  = "' . $v_6 . '",' ; 
$sql_string = $sql_string . 'name   = "' . $v_7 . '",' ;  
$sql_string = $sql_string . 'wkn   = "' . $v_8 . '",' ;
$sql_string = $sql_string . 'land   = "' . $v_9 . '",' ; 
$sql_string = $sql_string . 'webseite  = "' . $v_10 . '",' ; 
$sql_string = $sql_string . 'currency   = "' . $v_11 . '",' ; 
$sql_string = $sql_string . 'share_price  = "' . $v_12 . '",' ;   
$sql_string = $sql_string . 'number_shares   = "' . $v_13 . '",' ;  
$sql_string = $sql_string . 'rating_1_10   = "' . $v_14 . '",' ;  
$sql_string = $sql_string . 'short_comment   = "' . $v_15 . '",' ;
$sql_string = $sql_string . 'symbol   = "' . $v_17 . '",' ;
$sql_string = $sql_string . 'ISIN   = "' . $v_18 . '",' ;
$sql_string = $sql_string . 'details  = "' . $v_16 . '"' ;
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

$sql_string = 'insert into investment_companies (   
papier_art  ,
sektor_1   ,
sektor_2  ,
sektor_3  ,
sektor_4  ,
name    ,
wkn  ,
land  , 
webseite,  
currency ,  
share_price,    
number_shares,    
rating_1_10   , 
short_comment  ,
symbol  ,
ISIN  ,
details ) values  (';


$sql_string = $sql_string . '"' . $v_2 . '",' ;
$sql_string = $sql_string . '"' . $v_3 . '",' ;
$sql_string = $sql_string . '"' . $v_4 . '",' ;
$sql_string = $sql_string . '"' . $v_5 . '",' ;
$sql_string = $sql_string . '"' . $v_6 . '",' ;
$sql_string = $sql_string . '"' . $v_7 . '",' ;
$sql_string = $sql_string . '"' . $v_8 . '",' ;
$sql_string = $sql_string . '"' . $v_9 . '",' ;
$sql_string = $sql_string . '"' . $v_10 . '",' ;
$sql_string = $sql_string . '"' . $v_11 . '",' ;
$sql_string = $sql_string . '"' . $v_12 . '",' ;
$sql_string = $sql_string . '"' . $v_13 . '",' ;
$sql_string = $sql_string . '"' . $v_14 . '",' ;
$sql_string = $sql_string . '"' . $v_15 . '",' ;
$sql_string = $sql_string . '"' . $v_17 . '",' ;
$sql_string = $sql_string . '"' . $v_18 . '",' ;
$sql_string = $sql_string . '"' . $v_16 . '")' ;



$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";
$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};




# --------end insert table ------------------------------------------------------------
$db = DBI->connect(investment_connectionstring(),investment_connectionuser(),investment_connectionpassword()) or print "nix verbindung\n";
$sql_string =  "select * from investment_companies where " . $v_filter . "order by papier_art, sektor_1, sektor_2, sektor_3, sektor_4, name" . $v_limit;
print $sql_string;
$sql = $db->prepare($sql_string);
$sql->execute();

print "<br><a href='investment_companies.pl?v_insert=new_prepare&v_u=".$v_u."&v_s=".$v_s."&v_id='><b>insert new</b></a></br></br>";

print'<form method="POST" action="./investment_companies.pl">
<input type="hidden" name="v_s"  value="'.$v_s.'">
<input type="hidden" name="v_u"  value="'.$v_u.'">
<input type="hidden" name="v_id"  value="'.$v_id.'">
<input type="hidden" name="v_insert"  value="">';
print '<select name="v_filter">
		<option vlaue="nur aktien">nur aktien</option>
		<option vlaue="Neue 10">Neue 10</option>';
	
			$db2 = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
			$sql_string2 =  "select distinct sektor_1 from investment_companies order by sektor_1 ";
			$sql2 = $db2->prepare($sql_string2);
			$sql2->execute();
			while(@zeile=$sql2->fetchrow_array())
			{
			print '<option vlaue="'. $zeile[0] . '">'. $zeile[0] . '</option>';	
			}
			$sql2->finish;
			$db2->disconnect;
print '	</select>
	<input type="submit" value="filter">';
	
	
print'<form method="POST" action="/cgi-bin/investment_companies.pl">
<input type="hidden" name="v_s"  value="'.$v_s.'">
<input type="hidden" name="v_u"  value="'.$v_u.'">
<input type="hidden" name="v_id"  value="'.$v_id.'">
<input type="hidden" name="v_insert"  value="">';
print '<input  name="v_search" size="50" ><input type="submit" value="search">';	
	
	
	
print'<form method="POST" action="./investment_companies.pl">';	





print "<center>";


print "<table border = '1' ><tr>";

print "<td  ><b>update</b>&nbsp;</td>";

print "<td  ><b>id&nbsp;</td>"; 
print "<td  ><b>papier_art&nbsp;</td>";  
print "<td  ><b>sektor_1&nbsp;</td>";   
print "<td  ><b>sektor_2&nbsp;</td>";  
print "<td  ><b>sektor_3&nbsp;</td>";  
print "<td  ><b>sektor_4&nbsp;</td>";  
print "<td  ><b>name&nbsp;</td>";    
print "<td  ><b>wkn&nbsp;</td>";  
print "<td  ><b>detail</td>";  
print "<td  ><b>chart&nbsp;</td>";  
print "<td  ><b>land&nbsp;</td>";   
print "<td  ><b>webseite&nbsp;</td>";  
print "<td  ><b>currency&nbsp;</td>";   
print "<td  ><b>share_price&nbsp;</td>";    
print "<td  ><b>number_shares&nbsp;</td>";    
print "<td  ><b>rating_1_10&nbsp;</td>";    
print "<td  ><b>short_comment______________________________________________</td>";  
print "<td  ><b>symbol</td>";  
print "<td  ><b>ISIN</td>";  

print "</tr>";



while(@zeile=$sql->fetchrow_array())
{

	
if ( $zeile[13] eq '10') {print "<tr bgcolor='#FF0000'>"; }
elsif ( $zeile[13] eq '9') {print "<tr bgcolor='#FF0000'>"; }
elsif ( $zeile[13] eq '8') {print "<tr bgcolor='#FA8303'>"; }
elsif ( $zeile[13] eq '7') {print "<tr bgcolor='#FA8303'>"; }
elsif ( $zeile[13] eq '6') {print "<tr bgcolor='#FABD03'>"; }
elsif ( $zeile[13] eq '5') {print "<tr bgcolor='#FABD03'>"; }
else  {print "<tr >"; };

  
  print "<td><a href='./investment_companies.pl?v_insert=update_prepare&v_u=".$v_u."&v_s=".$v_s."&v_id=$zeile[0]'><b>update</b></a></td>";
  print "<td> $zeile[0] &nbsp;</td>";
  print "<td> $zeile[1] &nbsp;</td>";
  print "<td> $zeile[2] &nbsp;</td>";
  print "<td> $zeile[3] &nbsp;</td>";
  print "<td> $zeile[4] &nbsp;</td>";
  print "<td> $zeile[5] &nbsp;</td>";
  print "<td><b> $zeile[6] &nbsp;</b></td>";
  if ($zeile[7] eq "")
  	{
  	print "<td>&nbsp;</td>";
	}
	else
	{
	print "<td>" . $zeile[7]. "</td>";
	}
  print "<td onclick=\"detail_opener('$v_u' ,'$v_s','$zeile[0]')\" ><b><u>details</u></b></td>";
  print "<td onclick='action_opener(".$zeile[7].")' ><b>chart</b></td>";
    
    
  print "<td> $zeile[8] &nbsp;</td>";
  print "<td> $zeile[9] &nbsp;</td>";
  print "<td> $zeile[10] &nbsp;</td>";
  print "<td> $zeile[11] &nbsp;</td>";
  print "<td> $zeile[12] &nbsp;</td>";
  print "<td> $zeile[13] &nbsp;</td>";
  print "<td> $zeile[14] &nbsp;</td>";
  print "<td> $zeile[20] &nbsp;</td>";
  print "<td> $zeile[16] &nbsp;</td>";


  



 print "</tr>\n\n";
 

};



print "</table>";
print "</center>";

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
