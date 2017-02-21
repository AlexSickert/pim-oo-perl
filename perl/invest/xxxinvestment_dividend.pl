#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;


my $db;
my $sql;
my $sql_string;
my $sql_string_check;
my @zeile = ();


my $v_s = param("v_s");
my $v_u = param("v_u");
my $v_insert = param("v_insert");
my $v_id = param("v_id");

my $v_wkn = param("v_wkn");
my $v_datum = param("v_datum");
my $v_betrag = param("v_betrag");
my $v_comment = param("v_comment");



my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_year = $v_year + 1900;
$v_month = $v_month + 1;




do "the_base_header.pl";
do "the_base_db_connect.pl";




header($v_u,$v_s);




if (checklogin($v_u,$v_s) eq 'yes')
{


# ------------------ anfang innerer block mit permission ------------



#-------------------------- new action input form ----------------------------------
if ($v_insert eq 'new_prepare')
{
print'		<form method="POST" action="/cgi-bin/investment_dividend.pl">

		<table>
		


		<tr><td>
			<table>
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_insert"  value="yes"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_wkn"  value="'.$v_wkn.'"></td></tr>
				<tr><td>datum</td><td><input name="v_datum" size="50" value="'.$v_datum.'"></td></tr>
								
				<tr><td>betrag</td><td><input name="v_betrag" size="50" value="'.$v_betrag.'"></td></tr>
							
		
				<tr><td>comment</td><td><textarea name="v_comment" rows="10" cols="50" ></textarea></td></tr>
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

print'
<br><a href="investment_dividend.pl?v_insert=new_prepare&v_u='.$v_u.'&v_wkn='.$v_wkn.'&v_s='.$v_s.'"><b>new entry</b></a>
<br><br>';	
	
	
}
;
# ---------------------------end new action input form ----------------------------

# ---------------------------prepare update  form ----------------------------

if ($v_insert eq 'update_prepare')
{



$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

$sql_string =  "select * from investment_dividend  where ";
$sql_string = $sql_string . "id = ".$v_id."  " ;
$sql = $db->prepare($sql_string);
$sql->execute();



@zeile=$sql->fetchrow_array();





print'		<form method="POST" action="/cgi-bin/investment_dividend.pl">

		<table>
		


		<tr><td>
			<table>
				<tr><td></td><td><input type="hidden" name="v_s"  value="'.$v_s.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_u"  value="'.$v_u.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_id"  value="'.$v_id.'"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_insert"  value="update"></td></tr>
				<tr><td></td><td><input type="hidden" name="v_wkn"  value="'.$v_wkn.'"></td></tr>
								
				<tr><td>datum</td><td><input name="v_datum" size="50" value="'.$zeile[2].'"></td></tr>
				
				
				<tr><td>betrag</td><td><input name="v_betrag" size="50" value="'.$zeile[3].'"></td></tr>
				
				
		
				<tr><td>comment</td><td><textarea name="v_comment" rows="10" cols="50" >'.$zeile[4].'</textarea></td></tr>
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
$sql_string = 'update investment_dividend  set ';
$sql_string = $sql_string . 'datum = "' . $v_datum . '",' ;
$sql_string = $sql_string . 'betrag = "' . $v_betrag . '",' ;
$sql_string = $sql_string . 'comment = "' . $v_comment . '"' ;
$sql_string = $sql_string . 'where id = ' . $v_id . '';



$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};
# --------end insert table ------------------------------------------------------------



# --------insert table ----------------------------------------------------------------
if ($v_insert eq 'yes')
{

$sql_string = 'insert into investment_dividend  (   
id_deals ,
datum,
betrag ,
comment ) values  (';

$sql_string = $sql_string . '"' . $v_wkn . '",' ;
$sql_string = $sql_string . '"' . $v_datum . '",' ;
$sql_string = $sql_string . '"' . $v_betrag . '",' ;
$sql_string = $sql_string . '"' . $v_comment . '")' ;

print $sql_string;
$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};




# --------end insert table ------------------------------------------------------------
$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";



$sql_string =  "select * from investment_dividend   where id_deals = '" . $v_wkn . "' order by id desc ";

print $sql_string;



$sql = $db->prepare($sql_string);


$sql->execute();


print "<table border = '1' >";


print "<td  >update</td>";
print "<td  >id</td>";
print "<td  >id_deals</td>";
print "<td  >datum</td>";
print "<td  >betrag</td>";
print "<td  >comment</td>";


while(@zeile=$sql->fetchrow_array())
{
print "<tr>";

  print "<td><a href='investment_dividend.pl?v_insert=update_prepare&v_u=".$v_u."&v_wkn=".$v_wkn."&v_s=".$v_s."&v_id=$zeile[0]'><b>update</b></a></td>";
  print "<td> $zeile[0] &nbsp;</td>";
  print "<td> $zeile[1] &nbsp;</td>";
  print "<td> $zeile[2] &nbsp;</td>";
  print "<td> $zeile[3] &nbsp;</td>";
  print "<td> $zeile[4] &nbsp;</td>";

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
