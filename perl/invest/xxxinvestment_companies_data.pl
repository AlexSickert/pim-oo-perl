#!/usr/bin/perl

use strict;
use CGI qw(:standard);
use DBI;


my $db;
my $db2;
my $db3;
my $sql;
my $sql_string;

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
my $v_19 = param("v_19");
my $v_20 = param("v_20");

my $v_21 = param("v_21");
my $v_22 = param("v_22");
my $v_23 = param("v_23");
my $v_24 = param("v_24");
my $v_25 = param("v_25");
my $v_26 = param("v_26");
my $v_27 = param("v_27");
my $v_28 = param("v_28");
my $v_29 = param("v_29");
my $v_30 = param("v_30");

my $v_31 = param("v_31");
my $v_32 = param("v_32");
my $v_33 = param("v_33");
my $v_34 = param("v_34");
my $v_35 = param("v_35");
my $v_36 = param("v_36");
my $v_37 = param("v_37");
my $v_38 = param("v_38");
my $v_39 = param("v_39");
my $v_40 = param("v_40");

my $v_41 = param("v_41");
my $v_42 = param("v_42");
my $v_43 = param("v_43");
my $v_44 = param("v_44");
my $v_45 = param("v_45");
my $v_46 = param("v_46");
my $v_47 = param("v_47");
my $v_48 = param("v_48");
my $v_49 = param("v_49");
my $v_50 = param("v_50");

my $v_51 = param("v_51");
my $v_52 = param("v_52");
my $v_53 = param("v_53");
my $v_54 = param("v_54");
my $v_55 = param("v_55");
my $v_56 = param("v_56");
my $v_57 = param("v_57");
my $v_58 = param("v_58");
my $v_59 = param("v_59");

my $v_60 = param("v_60");
my $v_61 = param("v_61");
my $v_62 = param("v_62");
my $v_63 = param("v_63");
my $v_64 = param("v_64");
my $v_65 = param("v_65");
my $v_66 = param("v_66");
my $v_67 = param("v_67");
my $v_68 = param("v_68");
my $v_69 = param("v_69");


my $v_70 = param("v_70");
my $v_71 = param("v_71");
my $v_72 = param("v_72");
my $v_73 = param("v_73");
my $v_74 = param("v_74");
my $v_75 = param("v_75");
my $v_76 = param("v_76");
my $v_77 = param("v_77");
my $v_78 = param("v_78");
my $v_79 = param("v_79");

my $v_80 = param("v_80");
my $v_81 = param("v_81");
my $v_82 = param("v_82");
my $v_83 = param("v_83");
my $v_84 = param("v_84");
my $v_85 = param("v_85");
my $v_86 = param("v_86");
my $v_87 = param("v_87");
my $v_88 = param("v_88");
my $v_89 = param("v_89");

my $v_90 = param("v_90");
my $v_91 = param("v_91");
my $v_92 = param("v_92");
my $v_93 = param("v_93");
my $v_94 = param("v_94");
my $v_95 = param("v_95");
my $v_96 = param("v_96");
my $v_97 = param("v_97");
my $v_98 = param("v_98");
my $v_99 = param("v_99");

my $v_100 = param("v_100");
my $v_101 = param("v_101");
my $v_102 = param("v_102");
my $v_103 = param("v_103");
my $v_104 = param("v_104");
my $v_105 = param("v_105");
my $v_106 = param("v_106");
my $v_107 = param("v_107");
my $v_108 = param("v_108");
my $v_109 = param("v_109");
my $v_110 = param("v_110");




my $v_day = (localtime())[3];
my $v_month = (localtime())[4];
my $v_year = (localtime())[5];

$v_year = $v_year + 1900;
$v_month = $v_month + 1;




do "the_base_header.pl";
do "the_base_db_connect.pl";
do "investment_functions.pl";




header($v_u,$v_s);


if (checklogin($v_u,$v_s) eq 'yes')
{

# ------------------ anfang innerer block mit permission ------------


# create table and header of fields

print "<br><a href='investment_companies_data.pl?v_insert=new_prepare&v_u=".$v_u."&v_s=".$v_s."&v_id='><b>insert new</b></a></br></br>";


print "<table border = '1' ><tr  >";

print "<td  class='header_bottom'><b>update</b>&nbsp;</td>";

print "<td  class='header_bottom'><b>id&nbsp;</td>"; 

print "<td  class='header_bottom'><b>Comp_id&nbsp;</td>";  
print "<td  class='header_bottom'><b>Name&nbsp;</td>";  
print "<td  class='header_bottom'><b>year&nbsp;</td>";   
print "<td  class='header_bottom'><b>quarter&nbsp;</td>";  
print "<td  class='header_bottom'><b>Mitarbeiter&nbsp;</td>";  
print "<td  class='header_bottom'><b>Currency&nbsp;</td>";  
print "<td  class='header_bottom'><b>Factor&nbsp;</td>";  
print "<td  class='header_bottom'><b>aktien&nbsp;</td>";  
print "<td  class='header_bottom'><b>ergebnis je aktie&nbsp;</td>"; 
# ---------- Bewertung -------------------------
print "<td  class='header_bottom'><b>Overall summary</td>"; 
print "<td  class='header_bottom'><b>Sector</td>"; 
print "<td  class='header_bottom'><b>Company</td>"; 
print "<td  class='header_bottom'><b>Valuation</td>"; 
# ---------- Bewertung  - Details-------------------------
print "<td  class='header_bottom'><b>Sector Demand growth</td>"; 
print "<td  class='header_bottom'><b>Sector interest dependece</td>"; 
print "<td  class='header_bottom'><b>Sector Demand cyclical</td>"; 
print "<td  class='header_bottom'><b>Sector Demand 4</td>"; 
print "<td  class='header_bottom'><b>Sector Dmenad high ticket</td>"; 
print "<td  class='header_bottom'><b>Sector Pricing conolidated</td>"; 
print "<td  class='header_bottom'><b>Sector Pricing entry barriers</td>"; 
print "<td  class='header_bottom'><b>Sector Pricing customer power</td>"; 
print "<td  class='header_bottom'><b>Sector Pricing overcapacity</td>"; 
print "<td  class='header_bottom'><b>Sector Pricing competition</td>"; 

print "<td  class='header_bottom'><b>Sector Cost 1</td>"; 
print "<td  class='header_bottom'><b>Sector Cost material price dep.</td>"; 
print "<td  class='header_bottom'><b>Sector Cost employment cost dep.</td>"; 
print "<td  class='header_bottom'><b>Sector General gowth sector</td>"; 
print "<td  class='header_bottom'><b>Sector General Dependent by interest</td>"; 
print "<td  class='header_bottom'><b>Sector General dominted by few stocks</td>"; 
print "<td  class='header_bottom'><b>Sector Global sector</td>"; 
print "<td  class='header_bottom'><b>Sector General currency movments</td>"; 
print "<td  class='header_bottom'><b>Sector General 6</td>"; 
print "<td  class='header_bottom'><b>Sector General political regulation risk</td>"; 

print "<td  class='header_bottom'><b>company strong position</td>"; 
print "<td  class='header_bottom'><b>company strong brand</td>"; 
print "<td  class='header_bottom'><b>company pricing power</td>"; 
print "<td  class='header_bottom'><b>company entry barriers</td>"; 
print "<td  class='header_bottom'><b>company efficient cost base</td>"; 
print "<td  class='header_bottom'><b>company good management</td>"; 
print "<td  class='header_bottom'><b>company quality integrity</td>"; 
print "<td  class='header_bottom'><b>company sharholder value driven</td>"; 
print "<td  class='header_bottom'><b>company clean accounting</td>"; 
print "<td  class='header_bottom'><b>company good return on sales</td>"; 

print "<td  class='header_bottom'><b>company return on capital</td>"; 
print "<td  class='header_bottom'><b>company adding value</td>"; 
print "<td  class='header_bottom'><b>company good financial position</td>"; 
print "<td  class='header_bottom'><b>company low debt strong cash flow</td>"; 
print "<td  class='header_bottom'><b>company good outlook</td>"; 
print "<td  class='header_bottom'><b>company confidence in forecast</td>"; 

print "<td  class='header_bottom'><b>Valuation price earnings</td>"; 
print "<td  class='header_bottom'><b>Valuation price earnings 2</td>"; 
print "<td  class='header_bottom'><b>Valuation income yield</td>"; 
print "<td  class='header_bottom'><b>Valuation DCF</td>"; 
print "<td  class='header_bottom'><b>Valuation Enterprise value ev-Ebitda</td>"; 
print "<td  class='header_bottom'><b>Valuation Sales EV-Sales</td>"; 
print "<td  class='header_bottom'><b>Valuation Price-Assets</td>"; 

# ---------- Bilanz -------------------------
print "<td  class='header_bottom'><b>fixed assets &nbsp;</td>"; 
print "<td  class='header_bottom'><b>intangible assets&nbsp;</td>"; 
print "<td  class='header_bottom'><b>tangible assets&nbsp;</td>"; 

print "<td  class='header_bottom'><b>investments&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Sachanlagen&nbsp;</td>"; 
print "<td  class='header_bottom'><b>immatr. Verm. Gegenst.&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Ausleihungen&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Sonstige&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Current Assets&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Debtors&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Cash&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Rechnungs- abgrenzung&nbsp;</td>"; 

print "<td  class='header_bottom'><b>Vorräte&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Liabilities&nbsp;</td>"; 
print "<td  class='header_bottom'><b>in 1 Year&nbsp;</td>"; 
print "<td  class='header_bottom'><b>more than 1 Year&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Provisions and charges&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Verb. gegenüb. Bank&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Lieferung u. Leistung&nbsp;</td>"; 
print "<td  class='header_bottom'><b>andere&nbsp;</td>"; 
print "<td  class='header_bottom'><b>sonstiges&nbsp;</td>"; 
# -------- Profit Loss ------------------------
print "<td  class='header_bottom'><b>Turnover&nbsp;</td>"; 

print "<td  class='header_bottom'><b>Cost of Sales&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Personal&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Abschreibung&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Sonst Aufwendungen&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Material&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Lagerveränderung&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Forschung&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Gross profit&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Marketing&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Admin&nbsp;</td>"; 

print "<td  class='header_bottom'><b>EBIT&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Zinsen&nbsp;</td>"; 
print "<td  class='header_bottom'><b>profit before Tax (erg. gew. gesch. tät.)&nbsp;</td>"; 
print "<td  class='header_bottom'><b>ausserordentl. Afwendungen&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Tax&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Retained Profit (jahresüberschuss)&nbsp;</td>"; 
# ---------- cas flow -----------------------------
print "<td  class='header_bottom'><b>EBIT</td>";  
print "<td  class='header_bottom'><b>Good will amotisation&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Depreciation&nbsp;</td>"; 
print "<td  class='header_bottom'><b>Sole and assets&nbsp;</td>"; 
print "<td  class='header_bottom'><b>increase in debtors&nbsp;</td>";   
print "<td  class='header_bottom'><b>increase in creditors&nbsp;</td>";  
print "<td  class='header_bottom'><b>cash flow from operating activities (cash flow aus laufender gesch. tät)&nbsp;</td>";  


print "</tr>";
print "<td  class='header_bottom' style='background-color: #ff4444;' colspan='11' ><b>General Data</td>"; 

print "<td  class='header_bottom' style='background-color: #44ff44;' colspan='4' ><b>Bewertung summary</td>"; 
print "<td  class='header_bottom' style='background-color: #ff4444;' colspan='20' ><b>Bewertung Details - Sector (+/- 3)</td>";
print "<td  class='header_bottom' style='background-color: #44ff44;' colspan='16' ><b>Bewertung Details - Company (+/- 3)</td>"; 
print "<td  class='header_bottom' style='background-color: #ff4444;' colspan='7' ><b>Bewertung Details - Valuation</td>";  


print "<td  class='header_bottom' style='background-color: #44ff44;' colspan='21' ><b>Bilanz</td>"; 
print "<td  class='header_bottom' style='background-color: #ff4444;' colspan='17' ><b>Profit and Loss</td>"; 
print "<td  class='header_bottom' style='background-color: #44ff44;' colspan='7' ><b>Cash Flow</td>"; 
 
print "<tr>";

print "</tr>";



#-------------------------- new action input form ----------------------------------

if ($v_insert eq 'new_prepare')
{
print'		<form method="POST" action="/cgi-bin/investment_companies_data.pl">


				
				<input type="hidden" name="v_s"  value="'.$v_s.'">
				<input type="hidden" name="v_u"  value="'.$v_u.'">
				
				<input type="hidden" name="v_insert"  value="yes">
				<tr>
				<td><input type="submit" value="save"></td><td></td>
				
				<td><input name="v_1" size="8" value=""></td>
				<td><input name="v_2" size="8" value=""></td>
				<td><input name="v_3" size="8" value=""></td>
				<td><input name="v_4" size="8" value=""></td>
				<td><input name="v_5" size="8" value=""></td>
				<td><input name="v_6" size="8" value=""></td>
				<td><input name="v_7" size="8" value=""></td>
				<td><input name="v_8" size="8" value=""></td>
				<td><input name="v_9" size="8" value=""></td>
				<td><input name="v_10" size="8" value=""></td>
				
				<td><input name="v_11" size="8" value=""></td>
				<td><input name="v_12" size="8" value=""></td>
				<td><input name="v_13" size="8" value=""></td>
				<td><input name="v_14" size="8" value=""></td>
				<td><input name="v_15" size="8" value=""></td>
				<td><input name="v_16" size="8" value=""></td>
				<td><input name="v_17" size="8" value=""></td>
				<td><input name="v_18" size="8" value=""></td>
				<td><input name="v_19" size="8" value=""></td>
				<td><input name="v_20" size="8" value=""></td>
				
				<td><input name="v_21" size="8" value=""></td>
				<td><input name="v_22" size="8" value=""></td>
				<td><input name="v_23" size="8" value=""></td>
				<td><input name="v_24" size="8" value=""></td>
				<td><input name="v_25" size="8" value=""></td>
				<td><input name="v_26" size="8" value=""></td>
				<td><input name="v_27" size="8" value=""></td>
				<td><input name="v_28" size="8" value=""></td>
				<td><input name="v_29" size="8" value=""></td>
				<td><input name="v_30" size="8" value=""></td>
				
				<td><input name="v_31" size="8" value=""></td>
				<td><input name="v_32" size="8" value=""></td>
				<td><input name="v_33" size="8" value=""></td>
				<td><input name="v_34" size="8" value=""></td>
				<td><input name="v_35" size="8" value=""></td>
				<td><input name="v_36" size="8" value=""></td>
				<td><input name="v_37" size="8" value=""></td>
				<td><input name="v_38" size="8" value=""></td>
				<td><input name="v_39" size="8" value=""></td>
				<td><input name="v_40" size="8" value=""></td>
				
				<td><input name="v_41" size="8" value=""></td>
				<td><input name="v_42" size="8" value=""></td>
				<td><input name="v_43" size="8" value=""></td>
				<td><input name="v_44" size="8" value=""></td>
				<td><input name="v_45" size="8" value=""></td>
				<td><input name="v_46" size="8" value=""></td>
				<td><input name="v_47" size="8" value=""></td>
				<td><input name="v_48" size="8" value=""></td>
				<td><input name="v_49" size="8" value=""></td>
				<td><input name="v_50" size="8" value=""></td>
				
				<td><input name="v_51" size="8" value=""></td>
				<td><input name="v_52" size="8" value=""></td>
				<td><input name="v_53" size="8" value=""></td>
				<td><input name="v_54" size="8" value=""></td>
				<td><input name="v_55" size="8" value=""></td>
				<td><input name="v_56" size="8" value=""></td>
				<td><input name="v_57" size="8" value=""></td>
				<td><input name="v_58" size="8" value=""></td>
				<td><input name="v_59" size="8" value=""></td>
				
				<td><input name="v_60" size="8" value=""></td>
				<td><input name="v_61" size="8" value=""></td>
				<td><input name="v_62" size="8" value=""></td>
				<td><input name="v_63" size="8" value=""></td>
				<td><input name="v_64" size="8" value=""></td>
				<td><input name="v_65" size="8" value=""></td>
				<td><input name="v_66" size="8" value=""></td>
				<td><input name="v_67" size="8" value=""></td>
				<td><input name="v_68" size="8" value=""></td>
				<td><input name="v_69" size="8" value=""></td>
				
				<td><input name="v_70" size="8" value=""></td>
				<td><input name="v_71" size="8" value=""></td>
				<td><input name="v_72" size="8" value=""></td>
				<td><input name="v_73" size="8" value=""></td>
				<td><input name="v_74" size="8" value=""></td>
				<td><input name="v_75" size="8" value=""></td>
				<td><input name="v_76" size="8" value=""></td>
				<td><input name="v_77" size="8" value=""></td>
				<td><input name="v_78" size="8" value=""></td>
				<td><input name="v_79" size="8" value=""></td>
				
				<td><input name="v_80" size="8" value=""></td>
				<td><input name="v_81" size="8" value=""></td>
				<td><input name="v_82" size="8" value=""></td>
				<td><input name="v_83" size="8" value=""></td>
				<td><input name="v_84" size="8" value=""></td>
				<td><input name="v_85" size="8" value=""></td>
				<td><input name="v_86" size="8" value=""></td>
				<td><input name="v_87" size="8" value=""></td>
				<td><input name="v_88" size="8" value=""></td>
				<td><input name="v_89" size="8" value=""></td>
				
				<td><input name="v_90" size="8" value=""></td>
				<td><input name="v_91" size="8" value=""></td>
				<td><input name="v_92" size="8" value=""></td>
				<td><input name="v_93" size="8" value=""></td>
				<td><input name="v_94" size="8" value=""></td>
				<td><input name="v_95" size="8" value=""></td>
				<td><input name="v_96" size="8" value=""></td>
				<td><input name="v_97" size="8" value=""></td>
				<td><input name="v_98" size="8" value=""></td>
				<td><input name="v_99" size="8" value=""></td>
				
				<td><input name="v_100" size="8" value=""></td>
				<td><input name="v_101" size="8" value=""></td>
				<td><input name="v_102" size="8" value=""></td>
				<td><input name="v_103" size="8" value=""></td>
				<td><input name="v_104" size="8" value=""></td>
				<td><input name="v_105" size="8" value=""></td>
				<td><input name="v_106" size="8" value=""></td>
				<td><input name="v_107" size="8" value=""></td>
				<td><input name="v_108" size="8" value=""></td>
				<td><input name="v_109" size="8" value=""></td>
				
		
				
				
				</tr>								
				
				
				
	
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

$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

$sql_string =  "select * from investment_company_data where ";
$sql_string = $sql_string . "id = ".$v_id."  " ;
$sql = $db->prepare($sql_string);
$sql->execute();


@zeile=$sql->fetchrow_array();


print'		<form method="POST" action="/cgi-bin/investment_companies_data.pl">

		
				<input type="hidden" name="v_s"  value="'.$v_s.'">
				<input type="hidden" name="v_u"  value="'.$v_u.'">
				<input type="hidden" name="v_id"  value="'.$v_id.'">
				<input type="hidden" name="v_insert"  value="update">
				<tr>
				<td><input type="submit" value="save"></td>
				<td>&nbsp;</td>
				<td><input name="v_1" size="16" value="'.$zeile[1].'"></td>
				<td><input name="v_2" size="16" value="'.$zeile[2].'"></td>
				<td><input name="v_3" size="16" value="'.$zeile[3].'"></td>
				<td><input name="v_4" size="16" value="'.$zeile[4].'"></td>
				<td><input name="v_5" size="16" value="'.$zeile[5].'"></td>
				<td><input name="v_6" size="16" value="'.$zeile[6].'"></td>
				<td><input name="v_7" size="16" value="'.$zeile[7].'"></td>
				<td><input name="v_8" size="16" value="'.$zeile[8].'"></td>
				<td><input name="v_9" size="16" value="'.$zeile[9].'"></td>
				<td><input name="v_10" size="16" value="'.$zeile[10].'"></td>
				
				<td><input name="v_11" size="16" value="'.$zeile[11].'"></td>
				<td><input name="v_12" size="16" value="'.$zeile[12].'"></td>
				<td><input name="v_13" size="16" value="'.$zeile[13].'"></td>
				<td><input name="v_14" size="16" value="'.$zeile[14].'"></td>
				<td><input name="v_15" size="16" value="'.$zeile[15].'"></td>
				<td><input name="v_16" size="16" value="'.$zeile[16].'"></td>
				<td><input name="v_17" size="16" value="'.$zeile[17].'"></td>
				<td><input name="v_18" size="16" value="'.$zeile[18].'"></td>
				<td><input name="v_19" size="16" value="'.$zeile[19].'"></td>
				<td><input name="v_20" size="16" value="'.$zeile[20].'"></td>
				
				<td><input name="v_21" size="16" value="'.$zeile[21].'"></td>
				<td><input name="v_22" size="16" value="'.$zeile[22].'"></td>
				<td><input name="v_23" size="16" value="'.$zeile[23].'"></td>
				<td><input name="v_24" size="16" value="'.$zeile[24].'"></td>
				<td><input name="v_25" size="16" value="'.$zeile[25].'"></td>
				<td><input name="v_26" size="16" value="'.$zeile[26].'"></td>
				<td><input name="v_27" size="16" value="'.$zeile[27].'"></td>
				<td><input name="v_28" size="16" value="'.$zeile[28].'"></td>
				<td><input name="v_29" size="16" value="'.$zeile[29].'"></td>
				<td><input name="v_30" size="16" value="'.$zeile[30].'"></td>
				
				<td><input name="v_31" size="16" value="'.$zeile[31].'"></td>
				<td><input name="v_32" size="16" value="'.$zeile[32].'"></td>
				<td><input name="v_33" size="16" value="'.$zeile[33].'"></td>
				<td><input name="v_34" size="16" value="'.$zeile[34].'"></td>
				<td><input name="v_35" size="16" value="'.$zeile[35].'"></td>
				<td><input name="v_36" size="16" value="'.$zeile[36].'"></td>
				<td><input name="v_37" size="16" value="'.$zeile[37].'"></td>
				<td><input name="v_38" size="16" value="'.$zeile[38].'"></td>
				<td><input name="v_39" size="16" value="'.$zeile[39].'"></td>
				<td><input name="v_40" size="16" value="'.$zeile[40].'"></td>
				
				<td><input name="v_41" size="16" value="'.$zeile[41].'"></td>
				<td><input name="v_42" size="16" value="'.$zeile[42].'"></td>
				<td><input name="v_43" size="16" value="'.$zeile[43].'"></td>
				<td><input name="v_44" size="16" value="'.$zeile[44].'"></td>
				<td><input name="v_45" size="16" value="'.$zeile[45].'"></td>
				<td><input name="v_46" size="16" value="'.$zeile[46].'"></td>
				<td><input name="v_47" size="16" value="'.$zeile[47].'"></td>
				<td><input name="v_48" size="16" value="'.$zeile[48].'"></td>
				<td><input name="v_49" size="16" value="'.$zeile[49].'"></td>
				<td><input name="v_50" size="16" value="'.$zeile[50].'"></td> 
				<td><input name="v_51" size="16" value="'.$zeile[51].'"></td> 
				<td><input name="v_52" size="16" value="'.$zeile[52].'"></td> 
				<td><input name="v_53" size="16" value="'.$zeile[53].'"></td> 
				<td><input name="v_54" size="16" value="'.$zeile[54].'"></td> 
				<td><input name="v_55" size="16" value="'.$zeile[55].'"></td> 
				<td><input name="v_56" size="16" value="'.$zeile[56].'"></td> 
				<td><input name="v_57" size="16" value="'.$zeile[57].'"></td> 
				<td><input name="v_58" size="16" value="'.$zeile[58].'"></td> 
				<td><input name="v_59" size="16" value="'.$zeile[59].'"></td> 
				
				<td><input name="v_60" size="16" value="'.$zeile[60].'"></td>
				<td><input name="v_61" size="16" value="'.$zeile[61].'"></td>
				<td><input name="v_62" size="16" value="'.$zeile[62].'"></td>
				<td><input name="v_63" size="16" value="'.$zeile[63].'"></td>
				<td><input name="v_64" size="16" value="'.$zeile[64].'"></td>
				<td><input name="v_65" size="16" value="'.$zeile[65].'"></td>
				<td><input name="v_66" size="16" value="'.$zeile[66].'"></td>
				<td><input name="v_67" size="16" value="'.$zeile[67].'"></td>
				<td><input name="v_68" size="16" value="'.$zeile[68].'"></td>
				<td><input name="v_69" size="16" value="'.$zeile[69].'"></td>
				
				<td><input name="v_70" size="16" value="'.$zeile[70].'"></td>
				<td><input name="v_71" size="16" value="'.$zeile[71].'"></td>
				<td><input name="v_72" size="16" value="'.$zeile[72].'"></td>
				<td><input name="v_73" size="16" value="'.$zeile[73].'"></td>
				<td><input name="v_74" size="16" value="'.$zeile[74].'"></td>
				<td><input name="v_75" size="16" value="'.$zeile[75].'"></td>
				<td><input name="v_76" size="16" value="'.$zeile[76].'"></td>
				<td><input name="v_77" size="16" value="'.$zeile[77].'"></td>
				<td><input name="v_78" size="16" value="'.$zeile[78].'"></td>
				<td><input name="v_79" size="16" value="'.$zeile[79].'"></td>
				
				<td><input name="v_80" size="16" value="'.$zeile[80].'"></td>
				<td><input name="v_81" size="16" value="'.$zeile[81].'"></td>
				<td><input name="v_82" size="16" value="'.$zeile[82].'"></td>
				<td><input name="v_83" size="16" value="'.$zeile[83].'"></td>
				<td><input name="v_84" size="16" value="'.$zeile[84].'"></td>
				<td><input name="v_85" size="16" value="'.$zeile[85].'"></td>
				<td><input name="v_86" size="16" value="'.$zeile[86].'"></td>
				<td><input name="v_87" size="16" value="'.$zeile[87].'"></td>
				<td><input name="v_88" size="16" value="'.$zeile[88].'"></td>
				<td><input name="v_89" size="16" value="'.$zeile[89].'"></td>
				
				<td><input name="v_90" size="16" value="'.$zeile[90].'"></td>
				<td><input name="v_91" size="16" value="'.$zeile[91].'"></td>
				<td><input name="v_92" size="16" value="'.$zeile[92].'"></td>
				<td><input name="v_93" size="16" value="'.$zeile[93].'"></td>
				<td><input name="v_94" size="16" value="'.$zeile[94].'"></td>
				<td><input name="v_95" size="16" value="'.$zeile[95].'"></td>
				<td><input name="v_96" size="16" value="'.$zeile[96].'"></td>
				<td><input name="v_97" size="16" value="'.$zeile[97].'"></td>
				<td><input name="v_98" size="16" value="'.$zeile[98].'"></td>
				<td><input name="v_99" size="16" value="'.$zeile[99].'"></td>
				
				<td><input name="v_100" size="16" value="'.$zeile[100].'"></td>
				<td><input name="v_101" size="16" value="'.$zeile[101].'"></td>
				<td><input name="v_102" size="16" value="'.$zeile[102].'"></td>
				<td><input name="v_103" size="16" value="'.$zeile[103].'"></td>
				<td><input name="v_104" size="16" value="'.$zeile[104].'"></td>
				<td><input name="v_105" size="16" value="'.$zeile[105].'"></td>
				<td><input name="v_106" size="16" value="'.$zeile[106].'"></td>
				<td><input name="v_107" size="16" value="'.$zeile[107].'"></td>
				<td><input name="v_108" size="16" value="'.$zeile[108].'"></td>
				<td><input name="v_109" size="16" value="'.$zeile[109].'"></td>
				
				
				
				</tr>
	
		</form>

';

};


# --------------------------- end prepare update ----------------------------

# --------insert table ----------------------------------------------------------------



if ($v_insert eq 'update')
{
$sql_string = 'update investment_company_data set ';

$sql_string = $sql_string . 'p_1   = "' . $v_1 . '",' ;
$sql_string = $sql_string . 'p_2   = "' . $v_2 . '",' ;
$sql_string = $sql_string . 'p_3   = "' . $v_3 . '",' ;
$sql_string = $sql_string . 'p_4   = "' . $v_4 . '",' ;
$sql_string = $sql_string . 'p_5   = "' . $v_5 . '",' ;
$sql_string = $sql_string . 'p_6   = "' . $v_6 . '",' ;
$sql_string = $sql_string . 'p_7   = "' . $v_7 . '",' ;
$sql_string = $sql_string . 'p_8   = "' . $v_8 . '",' ;
$sql_string = $sql_string . 'p_9   = "' . $v_9 . '",' ;
$sql_string = $sql_string . 'p_10   = "' . $v_10 . '",' ;

$sql_string = $sql_string . 'p_11   = "' . $v_11 . '",' ;
$sql_string = $sql_string . 'p_12   = "' . $v_12 . '",' ;
$sql_string = $sql_string . 'p_13   = "' . $v_13 . '",' ;
$sql_string = $sql_string . 'p_14   = "' . $v_14 . '",' ;
$sql_string = $sql_string . 'p_15   = "' . $v_15 . '",' ;
$sql_string = $sql_string . 'p_16   = "' . $v_16 . '",' ;
$sql_string = $sql_string . 'p_17   = "' . $v_17 . '",' ;
$sql_string = $sql_string . 'p_18   = "' . $v_18 . '",' ;
$sql_string = $sql_string . 'p_19   = "' . $v_19 . '",' ;
$sql_string = $sql_string . 'p_20   = "' . $v_20 . '",' ;

$sql_string = $sql_string . 'p_21   = "' . $v_21 . '",' ;
$sql_string = $sql_string . 'p_22   = "' . $v_22 . '",' ;
$sql_string = $sql_string . 'p_23   = "' . $v_23 . '",' ;
$sql_string = $sql_string . 'p_24   = "' . $v_24 . '",' ;
$sql_string = $sql_string . 'p_25   = "' . $v_25 . '",' ;
$sql_string = $sql_string . 'p_26   = "' . $v_26 . '",' ;
$sql_string = $sql_string . 'p_27   = "' . $v_27 . '",' ;
$sql_string = $sql_string . 'p_28   = "' . $v_28 . '",' ;
$sql_string = $sql_string . 'p_29   = "' . $v_29 . '",' ;
$sql_string = $sql_string . 'p_30   = "' . $v_30 . '",' ;

$sql_string = $sql_string . 'p_31   = "' . $v_31 . '",' ;
$sql_string = $sql_string . 'p_32   = "' . $v_32 . '",' ;
$sql_string = $sql_string . 'p_33   = "' . $v_33 . '",' ;
$sql_string = $sql_string . 'p_34   = "' . $v_34 . '",' ;
$sql_string = $sql_string . 'p_35   = "' . $v_35 . '",' ;
$sql_string = $sql_string . 'p_36   = "' . $v_36 . '",' ;
$sql_string = $sql_string . 'p_37   = "' . $v_37 . '",' ;
$sql_string = $sql_string . 'p_38   = "' . $v_38 . '",' ;
$sql_string = $sql_string . 'p_39   = "' . $v_39 . '",' ;
$sql_string = $sql_string . 'p_40   = "' . $v_40 . '",' ;

$sql_string = $sql_string . 'p_41   = "' . $v_41 . '",' ;
$sql_string = $sql_string . 'p_42   = "' . $v_42 . '",' ;
$sql_string = $sql_string . 'p_43   = "' . $v_43 . '",' ;
$sql_string = $sql_string . 'p_44   = "' . $v_44 . '",' ;
$sql_string = $sql_string . 'p_45   = "' . $v_45 . '",' ;
$sql_string = $sql_string . 'p_46   = "' . $v_46 . '",' ;
$sql_string = $sql_string . 'p_47   = "' . $v_47 . '",' ;
$sql_string = $sql_string . 'p_48   = "' . $v_48 . '",' ;
$sql_string = $sql_string . 'p_49   = "' . $v_49 . '",' ;
$sql_string = $sql_string . 'p_50   = "' . $v_50 . '",' ;
$sql_string = $sql_string . 'p_51   = "' . $v_51 . '",' ;
$sql_string = $sql_string . 'p_52   = "' . $v_52 . '",' ;
$sql_string = $sql_string . 'p_53   = "' . $v_53 . '",' ;
$sql_string = $sql_string . 'p_54   = "' . $v_54 . '",' ;
$sql_string = $sql_string . 'p_55   = "' . $v_55 . '",' ;
$sql_string = $sql_string . 'p_56   = "' . $v_56 . '",' ;
$sql_string = $sql_string . 'p_57   = "' . $v_57 . '",' ;
$sql_string = $sql_string . 'p_58   = "' . $v_58 . '",' ;
$sql_string = $sql_string . 'p_59   = "' . $v_59 . '",' ;

$sql_string = $sql_string . 'p_60   = "' . $v_60 . '",' ;
$sql_string = $sql_string . 'p_61   = "' . $v_61 . '",' ;
$sql_string = $sql_string . 'p_62   = "' . $v_62 . '",' ;
$sql_string = $sql_string . 'p_63   = "' . $v_63 . '",' ;
$sql_string = $sql_string . 'p_64   = "' . $v_64 . '",' ;
$sql_string = $sql_string . 'p_65   = "' . $v_65 . '",' ;
$sql_string = $sql_string . 'p_66   = "' . $v_66 . '",' ;
$sql_string = $sql_string . 'p_67   = "' . $v_67 . '",' ;
$sql_string = $sql_string . 'p_68   = "' . $v_68 . '",' ;
$sql_string = $sql_string . 'p_69   = "' . $v_69 . '",' ;

$sql_string = $sql_string . 'p_70   = "' . $v_70 . '",' ;
$sql_string = $sql_string . 'p_71   = "' . $v_71 . '",' ;
$sql_string = $sql_string . 'p_72   = "' . $v_72 . '",' ;
$sql_string = $sql_string . 'p_73   = "' . $v_73 . '",' ;
$sql_string = $sql_string . 'p_74   = "' . $v_74 . '",' ;
$sql_string = $sql_string . 'p_75   = "' . $v_75 . '",' ;
$sql_string = $sql_string . 'p_76   = "' . $v_76 . '",' ;
$sql_string = $sql_string . 'p_77   = "' . $v_77 . '",' ;
$sql_string = $sql_string . 'p_78   = "' . $v_78 . '",' ;
$sql_string = $sql_string . 'p_79   = "' . $v_79 . '",' ;

$sql_string = $sql_string . 'p_80   = "' . $v_80 . '",' ;
$sql_string = $sql_string . 'p_81   = "' . $v_81 . '",' ;
$sql_string = $sql_string . 'p_82   = "' . $v_82 . '",' ;
$sql_string = $sql_string . 'p_83   = "' . $v_83 . '",' ;
$sql_string = $sql_string . 'p_84   = "' . $v_84 . '",' ;
$sql_string = $sql_string . 'p_85   = "' . $v_85 . '",' ;
$sql_string = $sql_string . 'p_86   = "' . $v_86 . '",' ;
$sql_string = $sql_string . 'p_87   = "' . $v_87 . '",' ;
$sql_string = $sql_string . 'p_88   = "' . $v_88 . '",' ;
$sql_string = $sql_string . 'p_89   = "' . $v_89 . '",' ;

$sql_string = $sql_string . 'p_90   = "' . $v_90 . '",' ;
$sql_string = $sql_string . 'p_91   = "' . $v_91 . '",' ;
$sql_string = $sql_string . 'p_92   = "' . $v_92 . '",' ;
$sql_string = $sql_string . 'p_93   = "' . $v_93 . '",' ;
$sql_string = $sql_string . 'p_94   = "' . $v_94 . '",' ;
$sql_string = $sql_string . 'p_95   = "' . $v_95 . '",' ;
$sql_string = $sql_string . 'p_96   = "' . $v_96 . '",' ;
$sql_string = $sql_string . 'p_97   = "' . $v_97 . '",' ;
$sql_string = $sql_string . 'p_98   = "' . $v_98 . '",' ;
$sql_string = $sql_string . 'p_99   = "' . $v_99 . '",' ;

$sql_string = $sql_string . 'p_100  = "' . $v_100 . '",' ;
$sql_string = $sql_string . 'p_101  = "' . $v_101 . '",' ;
$sql_string = $sql_string . 'p_102  = "' . $v_102 . '",' ;
$sql_string = $sql_string . 'p_103  = "' . $v_103 . '",' ;
$sql_string = $sql_string . 'p_104  = "' . $v_104 . '",' ;
$sql_string = $sql_string . 'p_105  = "' . $v_105 . '",' ;
$sql_string = $sql_string . 'p_106  = "' . $v_106 . '",' ;
$sql_string = $sql_string . 'p_107  = "' . $v_107 . '",' ;
$sql_string = $sql_string . 'p_108  = "' . $v_108 . '",' ;
$sql_string = $sql_string . 'p_109  = "' . $v_109 . '"' ;
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

$sql_string = 'insert into investment_company_data ( 
 
p_1, 
p_2, 
p_3, 
p_4, 
p_5, 
p_6, 
p_7, 
p_8, 
p_9, 
p_10, 

p_11, 
p_12, 
p_13, 
p_14, 
p_15, 
p_16, 
p_17, 
p_18, 
p_19, 
p_20, 

p_21, 
p_22, 
p_23, 
p_24, 
p_25, 
p_26, 
p_27, 
p_28, 
p_29, 
p_30, 

p_31, 
p_32, 
p_33, 
p_34, 
p_35, 
p_36, 
p_37, 
p_38, 
p_39, 
p_40,

p_41,
p_42,
p_43,
p_44,
p_45,
p_46,
p_47,
p_48,
p_49,
p_50,
p_51,
p_52,
p_53,
p_54,
p_55,
p_56,
p_57,
p_58,
p_59,
p_60,
p_61,
p_62,
p_63,
p_64,
p_65,
p_66,
p_67,
p_68,
p_69,
p_70,
p_71,
p_72,
p_73,
p_74,
p_75,
p_76,
p_77,
p_78,
p_79,
p_80,
p_81,
p_82,
p_83,
p_84,
p_85,
p_86,
p_87,
p_88,
p_89,
p_90,
p_91,
p_92,
p_93,
p_94,
p_95,
p_96,
p_97,
p_98,
p_99,
p_100,
p_101,
p_102,
p_103,
p_104,
p_105,
p_106,
p_107,
p_108,
p_109 ) values  (';

$sql_string = $sql_string . '"' . $v_1 . '",' ;
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
$sql_string = $sql_string . '"' . $v_16 . '",' ;
$sql_string = $sql_string . '"' . $v_17 . '",' ;
$sql_string = $sql_string . '"' . $v_18 . '",' ;
$sql_string = $sql_string . '"' . $v_19 . '",' ;
$sql_string = $sql_string . '"' . $v_20 . '",' ;

$sql_string = $sql_string . '"' . $v_21 . '",' ;
$sql_string = $sql_string . '"' . $v_22 . '",' ;
$sql_string = $sql_string . '"' . $v_23 . '",' ;
$sql_string = $sql_string . '"' . $v_24 . '",' ;
$sql_string = $sql_string . '"' . $v_25 . '",' ;
$sql_string = $sql_string . '"' . $v_26 . '",' ;
$sql_string = $sql_string . '"' . $v_27 . '",' ;
$sql_string = $sql_string . '"' . $v_28 . '",' ;
$sql_string = $sql_string . '"' . $v_29 . '",' ;
$sql_string = $sql_string . '"' . $v_30 . '",' ;

$sql_string = $sql_string . '"' . $v_31 . '",' ;
$sql_string = $sql_string . '"' . $v_32 . '",' ;
$sql_string = $sql_string . '"' . $v_33 . '",' ;
$sql_string = $sql_string . '"' . $v_34 . '",' ;
$sql_string = $sql_string . '"' . $v_35 . '",' ;
$sql_string = $sql_string . '"' . $v_36 . '",' ;
$sql_string = $sql_string . '"' . $v_37 . '",' ;
$sql_string = $sql_string . '"' . $v_38 . '",' ;
$sql_string = $sql_string . '"' . $v_39 . '",' ;
$sql_string = $sql_string . '"' . $v_40 . '",' ;

$sql_string = $sql_string . '"' . $v_41 . '",' ;
$sql_string = $sql_string . '"' . $v_42 . '",' ;
$sql_string = $sql_string . '"' . $v_43 . '",' ;
$sql_string = $sql_string . '"' . $v_44 . '",' ;
$sql_string = $sql_string . '"' . $v_45 . '",' ;
$sql_string = $sql_string . '"' . $v_46 . '",' ;
$sql_string = $sql_string . '"' . $v_47 . '",' ;
$sql_string = $sql_string . '"' . $v_48 . '",' ;
$sql_string = $sql_string . '"' . $v_49 . '",' ;
$sql_string = $sql_string . '"' . $v_50 . '",' ;
$sql_string = $sql_string . '"' . $v_51 . '",' ;
$sql_string = $sql_string . '"' . $v_52 . '",' ;
$sql_string = $sql_string . '"' . $v_53 . '",' ;
$sql_string = $sql_string . '"' . $v_54 . '",' ;
$sql_string = $sql_string . '"' . $v_55 . '",' ;
$sql_string = $sql_string . '"' . $v_56 . '",' ;
$sql_string = $sql_string . '"' . $v_57 . '",' ;
$sql_string = $sql_string . '"' . $v_58 . '",' ;
$sql_string = $sql_string . '"' . $v_59 . '",' ;
$sql_string = $sql_string . '"' . $v_60 . '",' ;
$sql_string = $sql_string . '"' . $v_61 . '",' ;
$sql_string = $sql_string . '"' . $v_62 . '",' ;
$sql_string = $sql_string . '"' . $v_63 . '",' ;
$sql_string = $sql_string . '"' . $v_64 . '",' ;
$sql_string = $sql_string . '"' . $v_65 . '",' ;
$sql_string = $sql_string . '"' . $v_66 . '",' ;
$sql_string = $sql_string . '"' . $v_67 . '",' ;
$sql_string = $sql_string . '"' . $v_68 . '",' ;
$sql_string = $sql_string . '"' . $v_69 . '",' ;
$sql_string = $sql_string . '"' . $v_70 . '",' ;
$sql_string = $sql_string . '"' . $v_71 . '",' ;
$sql_string = $sql_string . '"' . $v_72 . '",' ;
$sql_string = $sql_string . '"' . $v_73 . '",' ;
$sql_string = $sql_string . '"' . $v_74 . '",' ;
$sql_string = $sql_string . '"' . $v_75 . '",' ;
$sql_string = $sql_string . '"' . $v_76 . '",' ;
$sql_string = $sql_string . '"' . $v_77 . '",' ;
$sql_string = $sql_string . '"' . $v_78 . '",' ;
$sql_string = $sql_string . '"' . $v_79 . '",' ;
$sql_string = $sql_string . '"' . $v_80 . '",' ;
$sql_string = $sql_string . '"' . $v_81 . '",' ;
$sql_string = $sql_string . '"' . $v_82 . '",' ;
$sql_string = $sql_string . '"' . $v_83 . '",' ;
$sql_string = $sql_string . '"' . $v_84 . '",' ;
$sql_string = $sql_string . '"' . $v_85 . '",' ;
$sql_string = $sql_string . '"' . $v_86 . '",' ;
$sql_string = $sql_string . '"' . $v_87 . '",' ;
$sql_string = $sql_string . '"' . $v_88 . '",' ;
$sql_string = $sql_string . '"' . $v_89 . '",' ;
$sql_string = $sql_string . '"' . $v_90 . '",' ;
$sql_string = $sql_string . '"' . $v_91 . '",' ;
$sql_string = $sql_string . '"' . $v_92 . '",' ;
$sql_string = $sql_string . '"' . $v_93 . '",' ;
$sql_string = $sql_string . '"' . $v_94 . '",' ;
$sql_string = $sql_string . '"' . $v_95 . '",' ;
$sql_string = $sql_string . '"' . $v_96 . '",' ;
$sql_string = $sql_string . '"' . $v_97 . '",' ;
$sql_string = $sql_string . '"' . $v_98 . '",' ;
$sql_string = $sql_string . '"' . $v_99 . '",' ;
$sql_string = $sql_string . '"' . $v_100 . '",' ;
$sql_string = $sql_string . '"' . $v_101 . '",' ;
$sql_string = $sql_string . '"' . $v_102 . '",' ;
$sql_string = $sql_string . '"' . $v_103 . '",' ;
$sql_string = $sql_string . '"' . $v_104 . '",' ;
$sql_string = $sql_string . '"' . $v_105 . '",' ;
$sql_string = $sql_string . '"' . $v_106 . '",' ;
$sql_string = $sql_string . '"' . $v_107 . '",' ;
$sql_string = $sql_string . '"' . $v_108 . '",' ;
$sql_string = $sql_string . '"' . $v_109 . '")' ;


$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";
$sql = $db->prepare($sql_string);
$sql->execute();
$sql->finish;
$db->disconnect;

};


# --------end insert table ------------------------------------------------------------
$db = DBI->connect(connectionstring(),connectionuser(),connectionpassword()) or print "nix verbindung\n";

$sql_string =  "select * from investment_company_data order by p_1, p_3, p_4 ";



$sql = $db->prepare($sql_string);


$sql->execute();




while(@zeile=$sql->fetchrow_array())
{

	

print "<tr >"; 

  
  print "<td><a href='investment_companies_data.pl?v_insert=update_prepare&v_u=".$v_u."&v_s=".$v_s."&v_id=$zeile[0]'><b>update</b></a></td>";
  print "<td> $zeile[0] </td>";
  
  print "<td class='inv_numbers' >". fill_empty($zeile[1]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[2]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[3]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[4]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[5]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[6]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[7]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[8]) . "</td>";
  print "<td class='inv_numbers' >". fill_empty($zeile[9]) . "</td>";
  
print "<td class='inv_numbers' >".  fill_empty($zeile[10]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[11]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[12]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[13]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[14]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[15]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[16]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[17]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[18]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[19]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[20]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[21]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[22]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[23]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[24]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[25]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[26]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[27]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[28]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[29]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[30]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[31]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[32]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[33]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[34]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[35]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[36]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[37]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[38]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[39]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[40]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[41]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[42]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[43]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[44]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[45]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[46]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[47]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[48]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[49]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[50]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[51]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[52]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[53]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[54]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[55]) . "</td>";
print "<td class='inv_numbers' >".  fill_empty($zeile[56]) . "</td>";

# -------- ab hier mit currency ------------------------
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[57]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[58]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[59]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[60]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[61]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[62]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[63]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[64]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[65]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[66]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[67]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[68]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[69]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[70]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[71]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[72]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[73]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[74]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[75]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[76]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[77]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[78]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[79]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[80]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[81]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[82]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[83]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[84]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[85]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[86]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[87]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[88]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[89]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[90]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[91]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[92]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[93]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[94]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[95]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[96]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[97]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[98]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[99]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[100]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[101]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[102]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[103]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[104]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[105]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[106]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[107]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[108]) . "</td>";
print "<td class='inv_numbers' >". currency_interpolation($zeile[7], $zeile[109]) . "</td>";


  

  


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
