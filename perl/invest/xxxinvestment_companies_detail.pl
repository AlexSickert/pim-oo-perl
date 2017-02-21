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

my $v_date_insert = param("v_date_insert");
my $v_date_action = param("v_date_action");
my $v_action = param("v_action");
my $v_status = param("v_status");
my $v_detail = param("v_detail");

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




# --------insert table ----------------------------------------------------------------
if ($v_action eq 'save')
{

$sql_string = 'update investment_companies set ';
$sql_string = $sql_string . 'details  = "' . $v_detail . '"' ;
$sql_string = $sql_string . 'where id = ' . $v_id . '';

$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};




# --------end insert table ------------------------------------------------------------
$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";






$sql_string =  "select * from investment_companies where ";
$sql_string = $sql_string . "id = ".$v_id."  " ;





$sql = $db->prepare($sql_string);


$sql->execute();

print '<form method="POST" action="/cgi-bin/investment_companies_detail.pl">';
print "<table border = '1' >";






while(@zeile=$sql->fetchrow_array())
{
print "<tr>";

  print "<input type='hidden' name='v_u' value='".$v_u."'>";
  print "<input type='hidden' name='v_s' value='".$v_s."'>";
  print "<input type='hidden' name='v_id' value='".$zeile[0]."'>";
  print "<input type='hidden' name='v_action' value='save'>";
  

  
  
  
  
  print "<td>$zeile[6]&nbsp($zeile[7])&nbsp;<br><textarea name='v_detail' rows='20' cols='100' >$zeile[15]</textarea></td>";
 


 print "</tr>";
 print '<tr><td><input type="button" name="close" value="close window" onClick="window.close();"><input type="submit" value="........................save.............................">&nbsp; </td></tr>';
 
 
 
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
